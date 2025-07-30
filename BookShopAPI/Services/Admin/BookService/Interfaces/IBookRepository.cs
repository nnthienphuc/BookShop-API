using BookShopAPI.Models;

namespace BookShopAPI.Services.Admin.BookService.Interfaces
{
    public interface IBookRepository
    {
        Task<IEnumerable<Book>> GetAllAsync();
        Task<IEnumerable<Book>> SearchByKeywordAsync(string? keyword);
        Task<Book?> GetByIdAsync(Guid id);
        Task<Book?> GetByIsbnAsync(string isbn);
        Task AddAsync(Book book);
        void Update(Book book);
        void Delete(Book book);
        Task<bool> SaveChangesAsync();
    }
}
