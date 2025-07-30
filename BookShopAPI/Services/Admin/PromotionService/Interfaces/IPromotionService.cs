using BookShopAPI.Services.Admin.PromotionService.DTOs;

namespace BookShopAPI.Services.Admin.PromotionService.Interfaces
{
    public interface IPromotionService
    {
        Task<IEnumerable<PromotionResponseDTO>> GetAllAsync();
        Task<PromotionResponseDTO?> GetByIdAsync(Guid id);
        Task<PromotionResponseDTO?> GetByNameAsync(string name);
        Task<IEnumerable<PromotionResponseDTO>> SearchByKeywordAsync(string keyword);
        Task<bool> AddAsync(PromotionRequestDTO promotionCreateDTO);
        Task<bool> UpdateAsync(Guid id, PromotionRequestDTO promotionUpdateDTO);
        Task<bool> DeleteAsync(Guid id);
    }
}
