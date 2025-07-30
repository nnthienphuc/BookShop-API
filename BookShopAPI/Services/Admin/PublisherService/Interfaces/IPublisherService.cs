using BookShopAPI.Services.Admin.PublisherService.DTOs;

namespace BookShopAPI.Services.Admin.PublisherService.Interfaces
{
    public interface IPublisherService
    {
        Task<IEnumerable<PublisherResponseDTO>> GetAllAsync();
        Task<PublisherResponseDTO?> GetByIdAsync(Guid id);
        Task<PublisherResponseDTO?> GetByNameAsync(string name);
        Task<IEnumerable<PublisherResponseDTO>> SearchByKeywordAsync(string? keyword);
        Task<bool> AddAsync(PublisherRequestDTO dto);
        Task<bool> UpdateAsync(Guid id, PublisherRequestDTO dto);
        Task<bool> DeleteAsync(Guid id);
    }
}
