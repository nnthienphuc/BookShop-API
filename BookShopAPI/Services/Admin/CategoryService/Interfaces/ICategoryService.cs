using BookShopAPI.Services.Admin.CategoryService.DTOs;

namespace BookShopAPI.Services.Admin.CategoryService.Interfaces
{
    public interface ICategoryService
    {
        Task<IEnumerable<CategoryResponseDTO>> GetAllAsync();
        Task<IEnumerable<CategoryResponseDTO>> SearchByKeywordAsync(string keyword);
        Task<CategoryResponseDTO?> GetByIdAsync(Guid id);
        Task<CategoryResponseDTO?> GetByNameAsync(string name);
        Task<bool> AddAsync(CategoryRequestDTO dto);
        Task<bool> UpdateAsync(Guid id, CategoryRequestDTO dto);
        Task<bool> DeleteAsync(Guid id);
    }
}
