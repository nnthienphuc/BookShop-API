using BookShopAPI.Common.Enum;
using BookShopAPI.Common.Helper;
using BookShopAPI.Data;
using BookShopAPI.Models;
using BookShopAPI.Services.Admin.BookService.DTOs;
using BookShopAPI.Services.Admin.BookService.Interfaces;

namespace BookShopAPI.Services.Admin.BookService.Implements
{
    public class BookService : IBookService
    {
        private readonly IBookRepository _repo;
        private readonly ApplicationDbContext _context;
        private readonly IHttpContextAccessor _httpContext;
        private readonly IWebHostEnvironment _env;

        public BookService(
            IBookRepository repo,
            ApplicationDbContext context,
            IHttpContextAccessor httpContext,
            IWebHostEnvironment env)
        {
            _repo = repo;
            _context = context;
            _httpContext = httpContext;
            _env = env;
        }

        public async Task<IEnumerable<BookResponseDTO>> GetAllAsync()
        {
            var books = await _repo.GetAllAsync();

            return books.Select(x => new BookResponseDTO
            {
                Id = x.Id,
                Title = x.Title,
                Isbn = x.Isbn,
                AuthorName = x.Author.Name,
                CategoryName = x.Category.Name,
                PublisherName = x.Publisher.Name,
                YearOfPublication = x.YearOfPublication,
                Price = x.Price,
                Quantity = x.Quantity,
                IsDeleted = x.IsDeleted,
                Image = x.Image
            });
        }

        public async Task<IEnumerable<BookResponseDTO>> SearchByKeywordAsync(string? keyword)
        {
            var books = await _repo.SearchByKeywordAsync(keyword);

            return books.Select(x => new BookResponseDTO
            {
                Id = x.Id,
                Title = x.Title,
                Isbn = x.Isbn,
                AuthorName = x.Author.Name,
                CategoryName = x.Category.Name,
                PublisherName = x.Publisher.Name,
                YearOfPublication = x.YearOfPublication,
                Price = x.Price,
                Quantity = x.Quantity,
                IsDeleted = x.IsDeleted,
                Image = x.Image
            });
        }

        public async Task<BookResponseDTO?> GetByIdAsync(Guid id)
        {
            var book = await _repo.GetByIdAsync(id);
            if (book == null) return null;

            return new BookResponseDTO
            {
                Id = book.Id,
                Title = book.Title,
                Isbn = book.Isbn,
                AuthorName = book.Author.Name,
                CategoryName = book.Category.Name,
                PublisherName = book.Publisher.Name,
                YearOfPublication = book.YearOfPublication,
                Price = book.Price,
                Quantity = book.Quantity,
                IsDeleted = book.IsDeleted,
                Image = book.Image
            };
        }

        public async Task<bool> AddAsync(BookRequestDTO dto, IFormFile? imageFile)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(dto.Isbn))
                    throw new ArgumentException("ISBN cannot be null or whitespace.");

                var existing = await _repo.GetByIsbnAsync(dto.Isbn);
                if (existing != null)
                    throw new InvalidOperationException($"Book with ISBN '{dto.Isbn}' already exists.");

                var imagePath = await SaveImageAsync(imageFile, dto.Isbn);

                var book = new Book
                {
                    Id = Guid.NewGuid(),
                    Isbn = dto.Isbn,
                    Title = dto.Title,
                    CategoryId = dto.CategoryId,
                    AuthorId = dto.AuthorId,
                    PublisherId = dto.PublisherId,
                    YearOfPublication = dto.YearOfPublication,
                    Price = dto.Price,
                    Quantity = dto.Quantity,
                    IsDeleted = dto.IsDeleted,
                    Image = imagePath
                };

                await _repo.AddAsync(book);
                var result = await _repo.SaveChangesAsync();

                if (result)
                {
                    await AuditHelper.LogAuditAsync(_httpContext, _context, AuditAction.ADD, "Book", book.Id, $"Added book '{book.Title}'");
                }

                return result;
            }
            
            catch (Exception ex)
    {
                // Ghi log hoặc re-throw lỗi cụ thể để debug
                throw new Exception($"Lỗi cập nhật sách: {ex.Message}", ex);
            }
        }

        public async Task<bool> UpdateAsync(Guid id, BookRequestDTO dto, IFormFile? imageFile)
        {
            try
            {
                var book = await _repo.GetByIdAsync(id);
                if (book == null)
                    throw new KeyNotFoundException($"Book with id '{id}' not found.");

                if (string.IsNullOrWhiteSpace(dto.Isbn))
                    throw new ArgumentException("ISBN cannot be null or whitespace.");

                var duplicate = await _repo.GetByIsbnAsync(dto.Isbn);
                if (duplicate != null && duplicate.Id != id)
                    throw new InvalidOperationException($"Book with ISBN '{dto.Isbn}' already exists.");

                var logBook = new Book
                {
                    Title = book.Title,
                    IsDeleted = book.IsDeleted,
                    Image = book.Image
                };

                var imagePath = await SaveImageAsync(imageFile, dto.Isbn);

                book.Isbn = dto.Isbn;
                book.Title = dto.Title;
                book.CategoryId = dto.CategoryId;
                book.AuthorId = dto.AuthorId;
                book.PublisherId = dto.PublisherId;
                book.YearOfPublication = dto.YearOfPublication;
                book.Price = dto.Price;
                book.Quantity = dto.Quantity;
                book.IsDeleted = dto.IsDeleted;
                if (!string.IsNullOrWhiteSpace(imagePath))
                {
                    book.Image = imagePath;
                }

                _repo.Update(book);
                var result = await _repo.SaveChangesAsync();

                if (result)
                {
                    await AuditHelper.LogAuditAsync(_httpContext, _context, AuditAction.UPDATE, "Book", id, $"Updated book '{logBook.Title}' to '{book.Title}', IsDeleted: '{logBook.IsDeleted}' → '{book.IsDeleted}'");
                }

                return result;
            }
            
            catch (Exception ex)
            {
                // Ghi log hoặc re-throw lỗi cụ thể để debug
                throw new Exception($"Lỗi cập nhật sách: {ex.Message}", ex);
            }
        }

        public async Task<bool> DeleteAsync(Guid id)
        {
            var book = await _repo.GetByIdAsync(id);
            if (book == null)
                throw new KeyNotFoundException($"Book with id '{id}' not found.");

            if (book.IsDeleted)
                throw new InvalidOperationException($"Book with id '{id}' is already deleted.");

            _repo.Delete(book);
            var result = await _repo.SaveChangesAsync();

            if (result)
            {
                await AuditHelper.LogAuditAsync(_httpContext, _context, AuditAction.DELETE, "Book", id, $"Deleted book '{book.Title}'");
            }

            return result;
        }

        private async Task<string?> SaveImageAsync(IFormFile? imageFile, string isbn)
        {
            if (imageFile == null || imageFile.Length == 0) return null;

            var folderPath = Path.Combine(_env.WebRootPath, "images", "books");
            if (!Directory.Exists(folderPath))
                Directory.CreateDirectory(folderPath);

            var fileName = isbn + Path.GetExtension(imageFile.FileName);
            var filePath = Path.Combine(folderPath, fileName);

            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await imageFile.CopyToAsync(stream);
            }

            return $"images/books/{fileName}";
        }
    }
}
