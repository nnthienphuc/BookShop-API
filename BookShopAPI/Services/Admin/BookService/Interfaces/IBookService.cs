using BookShopAPI.Services.Admin.BookService.DTOs;

namespace BookShopAPI.Services.Admin.BookService.Interfaces
{
    public interface IBookService
    {
        Task<IEnumerable<BookResponseDTO>> GetAllAsync();
        Task<IEnumerable<BookResponseDTO>> SearchByKeywordAsync(string? keyword);
        Task<BookResponseDTO?> GetByIdAsync(Guid id);
        Task<bool> AddAsync(BookRequestDTO dto, IFormFile? imageFile);
        Task<bool> UpdateAsync(Guid id, BookRequestDTO dto, IFormFile? imageFile);
        Task<bool> DeleteAsync(Guid id);
    }
}
