using BookShopAPI.Models;
using BookShopAPI.Services.Admin.AuthorService.DTOs;

namespace BookShopAPI.Services.Admin.AuthorService.Interfaces
{
    public interface IAuthorService
    {
        Task<IEnumerable<AuthorResponseDTO>> GetAllAsync();
        Task<AuthorResponseDTO?> GetByIdAsync(Guid id);
        Task<IEnumerable<AuthorResponseDTO>> SearchByKeywordAsync(string? keyword);
        Task<bool> AddAsync(AuthorRequestDTO dto);
        Task<bool> UpdateAsync(Guid id, AuthorRequestDTO dto);
        Task<bool> DeleteAsync(Guid id);
    }
}
