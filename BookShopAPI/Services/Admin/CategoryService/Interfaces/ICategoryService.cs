using BookShopAPI.Services.Admin.CategoryService.DTOs;

namespace BookShopAPI.Services.Admin.CategoryService.Interfaces
{
    public interface ICategoryService
    {
        Task<IEnumerable<CategoryReponseDTO>> GetAllAsync();
        Task<IEnumerable<CategoryReponseDTO>> SearchByKeywordAsync(string keyword);
        Task<CategoryReponseDTO?> GetByIdAsync(Guid id);
        Task<CategoryReponseDTO?> GetByNameAsync(string name);
        Task<bool> AddAsync(CategoryCreateDTO dto)
    }
}
