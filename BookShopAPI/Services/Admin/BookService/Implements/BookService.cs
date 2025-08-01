using BookShopAPI.Common.Enum;
using BookShopAPI.Common.Helper;
using BookShopAPI.Data;
using BookShopAPI.Models;
using BookShopAPI.Services.Admin.AuthorService.Interfaces;
using BookShopAPI.Services.Admin.BookService.DTOs;
using BookShopAPI.Services.Admin.BookService.Interfaces;
using BookShopAPI.Services.Admin.CategoryService.Interfaces;
using BookShopAPI.Services.Admin.PublisherService.Interfaces;

namespace BookShopAPI.Services.Admin.BookService.Implements
{
    public class BookService : IBookService
    {
        private readonly IBookRepository _repo;
        private readonly ICategoryRepository _categoryRepo;
        private readonly IAuthorRepository _authorRepo;
        private readonly IPublisherRepository _publisherRepo;
        private readonly ApplicationDbContext _context;
        private readonly IHttpContextAccessor _httpContext;
        private readonly IWebHostEnvironment _env;

        public BookService(
    IBookRepository repo,
    ICategoryRepository categoryRepo,
    IAuthorRepository authorRepo,
    IPublisherRepository publisherRepo,
    ApplicationDbContext context,
    IHttpContextAccessor httpContext,
    IWebHostEnvironment env)
        {
            _repo = repo;
            _categoryRepo = categoryRepo;
            _authorRepo = authorRepo;
            _publisherRepo = publisherRepo;
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

                AuthorId = x.AuthorId,
                AuthorName = x.Author.Name,

                CategoryId = x.CategoryId,
                CategoryName = x.Category.Name,

                PublisherId = x.PublisherId,
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

                AuthorId = x.AuthorId,
                AuthorName = x.Author.Name,

                CategoryId = x.CategoryId,
                CategoryName = x.Category.Name,

                PublisherId = x.PublisherId,
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
            if (book == null)
                throw new KeyNotFoundException($"Không tìm thấy sách có id '{id}.");

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
                    throw new ArgumentException("Mã ISBN là bắt buộc.");

                if (string.IsNullOrWhiteSpace(dto.Title))
                    throw new ArgumentException("Tiêu đề là bắt buộc.");

                if (dto.YearOfPublication <= 1500)
                    throw new ArgumentException("Năm xuất bản phải lớn hơn 1500.");

                if (dto.Price <= 1000)
                    throw new ArgumentException("Giá phải lớn hơn 1000.");

                if (dto.Quantity < 0)
                    throw new ArgumentException("Số lượng phải lớn hơn hoặc bằng 0.");

                await ValidateForeignKeysAsync(dto);

                if (imageFile == null || imageFile.Length == 0)
                    throw new ArgumentException("Ảnh bìa sách là bắt buộc.");

                var existing = await _repo.GetByIsbnAsync(dto.Isbn);
                if (existing != null)
                    throw new InvalidOperationException($"Sách có ISBN '{dto.Isbn}' đã tồn tại.");

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
                    throw new KeyNotFoundException($"Không tìm thấy sách có id '{id}'.");

                if (string.IsNullOrWhiteSpace(dto.Isbn))
                    throw new ArgumentException("Mã ISBN là bắt buộc.");

                if (string.IsNullOrWhiteSpace(dto.Title))
                    throw new ArgumentException("Tiêu đề là bắt buộc.");

                if (dto.YearOfPublication <= 1500)
                    throw new ArgumentException("Năm xuất bản phải lớn hơn 1500.");

                if (dto.Price <= 1000)
                    throw new ArgumentException("Giá phải lớn hơn 1000.");

                if (dto.Quantity < 0)
                    throw new ArgumentException("Số lượng phải lớn hơn hoặc bằng 0.");

                await ValidateForeignKeysAsync(dto);

                var duplicate = await _repo.GetByIsbnAsync(dto.Isbn);
                if (duplicate != null && duplicate.Id != id)
                    throw new InvalidOperationException($"Sách có ISBN '{dto.Isbn}' đã tồn tại.");

                var logBook = new Book
                {
                    Isbn = book.Isbn,
                    Title = book.Title,
                    CategoryId = book.CategoryId,
                    AuthorId = book.AuthorId,
                    PublisherId = book.PublisherId,
                    YearOfPublication = book.YearOfPublication,
                    Price = book.Price,
                    Quantity = book.Quantity,
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
                    await AuditHelper.LogAuditAsync(_httpContext, _context, AuditAction.UPDATE, "Book", id, $"Updated book '{logBook.Isbn}' to '{book.Isbn}', '{logBook.Title}' to '{book.Title}', '{logBook.CategoryId}' to '{book.CategoryId}', '{logBook.AuthorId}' to '{book.AuthorId}', '{logBook.PublisherId}' to '{book.PublisherId}', '{logBook.YearOfPublication}' to '{book.YearOfPublication}', '{logBook.Price}' to '{logBook.Price}', '{logBook.Quantity}' to '{book.Quantity}', IsDeleted: '{logBook.IsDeleted}' → '{book.IsDeleted}'");
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
                throw new KeyNotFoundException($"Không tìm thấy sách có id '{id}'.");

            if (book.IsDeleted)
                throw new InvalidOperationException($"Sách có id '{id}' đã bị xóa.");

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

        private async Task ValidateForeignKeysAsync(BookRequestDTO dto)
        {
            var category = await _categoryRepo.GetByIdAsync(dto.CategoryId);
            if (category == null || category.IsDeleted)
                throw new ArgumentException("Danh mục không hợp lệ hoặc đã bị xóa.");

            var author = await _authorRepo.GetByIdAsync(dto.AuthorId);
            if (author == null || author.IsDeleted)
                throw new ArgumentException("Tác giả không hợp lệ hoặc đã bị xóa.");

            var publisher = await _publisherRepo.GetByIdAsync(dto.PublisherId);
            if (publisher == null || publisher.IsDeleted)
                throw new ArgumentException("Nhà xuất bản không hợp lệ hoặc đã bị xóa.");
        }
    }
}
