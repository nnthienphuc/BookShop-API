using BookShopAPI.Common.Enum;
using BookShopAPI.Common.Helper;
using BookShopAPI.Data;
using BookShopAPI.Models;
using BookShopAPI.Services.Admin.AuthorService.DTOs;
using BookShopAPI.Services.Admin.AuthorService.Interfaces;

namespace BookShopAPI.Services.Admin.AuthorService.Implements
{
    public class AuthorService : IAuthorService
    {
        private readonly ApplicationDbContext _context;
        private readonly IHttpContextAccessor _httpContext;
        private readonly IAuthorRepository _repo;

        public AuthorService(ApplicationDbContext context, IHttpContextAccessor httpContext, IAuthorRepository repo)
        {
            _repo = repo ?? throw new ArgumentNullException(nameof(context));
            _httpContext = httpContext;
            _context = context;
        }

        public async Task<IEnumerable<AuthorResponseDTO>> GetAllAsync()
        {
            var authors = await _repo.GetAllAsync();

            return authors.Select(x => new AuthorResponseDTO
            {
                Id = x.Id,
                Name = x.Name,
                IsDeleted = x.IsDeleted
            });
        }

        public async Task<AuthorResponseDTO?> GetByIdAsync(Guid id)
        {
            var author = await _repo.GetByIdAsync(id);

            if (author == null)
                throw new KeyNotFoundException($"Không tìm thấy tác giả có id '{id}'.");

            return new AuthorResponseDTO
            {
                Id = author.Id,
                Name = author.Name,
                IsDeleted = author.IsDeleted
            };
        }

        public async Task<IEnumerable<AuthorResponseDTO>> SearchByKeywordAsync(string? keyword)
        {
            var authors = await _repo.SearchByKeywordAsync(keyword);

            return authors.Select(x => new AuthorResponseDTO
            {
                Id = x.Id,
                Name = x.Name,
                IsDeleted = x.IsDeleted
            });
        }

        public async Task<bool> AddAsync(AuthorRequestDTO dto)
        {
            if (string.IsNullOrWhiteSpace(dto.Name))
                throw new ArgumentException("Tên không thể là null hoặc khoảng trắng.");

            var author = new Author
            {
                Name = dto.Name,
                IsDeleted = dto.IsDeleted
            };

            await _repo.AddAsync(author);

            var result = await _repo.SaveChangesAsync();

            if (result)
            {
                await AuditHelper.LogAuditAsync(
                    _httpContext,
                    _context,
                    AuditAction.ADD,
                    "Author",
                    author.Id,
                    $"Created author '{author.Name}'"
                    );
            }

            return result;
        }

        public async Task<bool> UpdateAsync(Guid id, AuthorRequestDTO dto)
        {
            var existingAuthor = await _repo.GetByIdAsync(id);
            if (existingAuthor == null)
                throw new KeyNotFoundException($"Không tìm tìm thấy tác giả có id '{id}'.");

            if (string.IsNullOrWhiteSpace(dto.Name))
                throw new ArgumentException("Tên không thể là null hoặc khoảng trắng.");

            var logAuthor = new Author
            {
                Id = existingAuthor.Id,
                Name = existingAuthor.Name,
                IsDeleted = existingAuthor.IsDeleted
            };

            existingAuthor.Name = dto.Name;
            existingAuthor.IsDeleted = dto.IsDeleted;

            _repo.Update(existingAuthor);

            var result = await _repo.SaveChangesAsync();
        
            if (result)
            {
                await AuditHelper.LogAuditAsync(
                    _httpContext,
                    _context,
                    AuditAction.UPDATE,
                    "Author",
                    id,
                    $"Updated author '{logAuthor.Name}' to '{existingAuthor.Name}', '{logAuthor.IsDeleted}' to '{existingAuthor.IsDeleted}'"
                    );
            }

            return result;
        }

        public async Task<bool> DeleteAsync(Guid id)
        {
            var existingAuthor = await _repo.GetByIdAsync(id);
            if (existingAuthor == null)
                throw new KeyNotFoundException($"Không tìm thấy tác giả có id '{id}'.");

            if (existingAuthor.IsDeleted == true)
                throw new InvalidOperationException($"Tác giả có id '{id}' đã bị xóa.");

            _repo.Delete(existingAuthor);

            var result = await _repo.SaveChangesAsync();

            if (result)
            {
                await AuditHelper.LogAuditAsync(
                    _httpContext,
                    _context,
                    AuditAction.DELETE,
                    "Author",
                    id,
                    $"Soft deleted author '{existingAuthor.Name}'"
                    );
            }

            return result;
        }
    }
}
