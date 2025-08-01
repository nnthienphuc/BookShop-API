using BookShopAPI.Common.Enum;
using BookShopAPI.Common.Helper;
using BookShopAPI.Data;
using BookShopAPI.Models;
using BookShopAPI.Services.Admin.PublisherService.DTOs;
using BookShopAPI.Services.Admin.PublisherService.Interfaces;
using System.Net.WebSockets;

namespace BookShopAPI.Services.Admin.PublisherService.Implements
{
    public class PublisherService : IPublisherService
    {
        private readonly IPublisherRepository _repo;
        private readonly IHttpContextAccessor _httpContext;
        private readonly ApplicationDbContext _context;

        public PublisherService(IPublisherRepository repo, IHttpContextAccessor httpContext, ApplicationDbContext context)
        {
            _repo = repo ?? throw new ArgumentNullException(nameof(context));
            _httpContext = httpContext;
            _context = context;
        }

        public async Task<IEnumerable<PublisherResponseDTO>> GetAllAsync()
        {
            var publishers = await _repo.GetAllAsync();

            return publishers.Select(x => new PublisherResponseDTO
            {
                Id = x.Id,
                Name = x.Name,
                IsDeleted = x.IsDeleted
            });
        }

        public async Task<PublisherResponseDTO?> GetByIdAsync(Guid id)
        {
            var publisher = await _repo.GetByIdAsync(id);

            if (publisher == null)
                throw new KeyNotFoundException($"Không tìm thấy nhà xuất bản có id '{id}'.");

            return new PublisherResponseDTO
            {
                Id = publisher.Id,
                Name = publisher.Name,
                IsDeleted = publisher.IsDeleted
            };
        }

        public async Task<PublisherResponseDTO?> GetByNameAsync(string name)
        {
            var publisher = await _repo.GetByNameAsync(name);

            if (publisher == null)
                throw new KeyNotFoundException($"Không tìm thấy nhà xuất bản có tên '{name}'.");

            return new PublisherResponseDTO
            {
                Id = publisher.Id,
                Name = publisher.Name,
                IsDeleted = publisher.IsDeleted
            };
        }

        public async Task<IEnumerable<PublisherResponseDTO>> SearchByKeywordAsync(string? keyword)
        {
            var publishers = await _repo.SearchByKeywordAsync(keyword);

            return publishers.Select(x => new PublisherResponseDTO
            {
                Id = x.Id,
                Name = x.Name,
                IsDeleted = x.IsDeleted
            });
        }

        public async Task<bool> AddAsync(PublisherRequestDTO dto)
        {
            if (string.IsNullOrWhiteSpace(dto.Name))
                throw new ArgumentException("Tên không thể là null hoặc khoảng trắng.");

            var existingPublisher = await _repo.GetByNameAsync(dto.Name);
            if (existingPublisher != null)
                throw new InvalidOperationException($"Nhà xuất bản có tên '{dto.Name}' đã tồn tại.");

            var publisher = new Publisher
            {
                Name = dto.Name,
                IsDeleted = dto.IsDeleted
            };
            await _repo.AddAsync(publisher);

            var result = await _repo.SaveChangesAsync();
            if (result)
            {
                await AuditHelper.LogAuditAsync(
                    _httpContext,
                    _context,
                    AuditAction.ADD,
                    "Publisher",
                    publisher.Id,
                    $"Created publisher '{publisher.Name}'"
                    );
            }

            return result;
        }

        public async Task<bool> UpdateAsync(Guid id, PublisherRequestDTO dto)
        {
            if (string.IsNullOrWhiteSpace(dto.Name))
                throw new ArgumentException("Tên không thể là null hoặc khoảng trắng.");

            var existingPublisher = await _repo.GetByIdAsync(id);
            if (existingPublisher == null)
                throw new KeyNotFoundException($"Không tìm thấy nhà xuất bản có id '{id}'.");

            var existingName = await _repo.GetByNameAsync(dto.Name);
            if (existingName != null && existingName.Id != id)
                throw new InvalidOperationException($"Nhà xuất bản có tên '{dto.Name}' đã tồn tại.");

            var logPublisher = new Publisher
            {
                Id = existingPublisher.Id,
                Name = existingPublisher.Name,
                IsDeleted = existingPublisher.IsDeleted
            };

            existingPublisher.Name = dto.Name;
            existingPublisher.IsDeleted = dto.IsDeleted;

            _repo.Update(existingPublisher);

            var result = await _repo.SaveChangesAsync();
            if(result)
            {
                await AuditHelper.LogAuditAsync(
                   _httpContext,
                    _context,
                    AuditAction.UPDATE,
                    "Publisher",
                    id,
                    $"Updated publisher '{logPublisher.Name}' to '{existingPublisher.Name}', '{logPublisher.IsDeleted}' to '{existingPublisher.IsDeleted}'");
            }

            return result;
        }

        public async Task<bool> DeleteAsync(Guid id)
        {
            var existingPublisher = await _repo.GetByIdAsync(id);

            if (existingPublisher == null)
                throw new KeyNotFoundException($"Không tìm thấy nhà xuất bản có id '{id}'.");

            if (existingPublisher.IsDeleted == true)
                throw new InvalidOperationException($"Nhà xuất bản có id '{id}' đã bị xóa.");

            _repo.Delete(existingPublisher);

            var result = await _repo.SaveChangesAsync();

            if (result)
            {
                await AuditHelper.LogAuditAsync(
                   _httpContext,
                    _context,
                    AuditAction.DELETE,
                    "Publisher",
                    id,
                    $"Soft deleted publisher '{existingPublisher.Name}'");
            }

            return result;
        }
    }
}
