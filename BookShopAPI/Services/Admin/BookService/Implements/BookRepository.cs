using BookShopAPI.Data;
using BookShopAPI.Models;
using BookShopAPI.Services.Admin.BookService.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace BookShopAPI.Services.Admin.BookService.Implements
{
    public class BookRepository : IBookRepository
    {
        private readonly ApplicationDbContext _context;

        public BookRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Book>> GetAllAsync()
        {
            return await _context.Books
                .Include(x => x.Author)
                .Include(x => x.Category)
                .Include(x => x.Publisher)
                .ToListAsync();
        }

        public async Task<IEnumerable<Book>> SearchByKeywordAsync(string? keyword)
        {
            return await _context.Books
                .Include(x => x.Author)
                .Include(x => x.Category)
                .Include(x => x.Publisher)
                .Where(x => string.IsNullOrWhiteSpace(keyword) || x.Title.Contains(keyword) || x.Isbn.Contains(keyword) || x.Author.Name.Contains(keyword) || x.Category.Name.Contains(keyword) || x.Publisher.Name.Contains(keyword))
                .ToListAsync();
        }

        public async Task<Book?> GetByIdAsync(Guid id)
        {
            return await _context.Books
                .Include(x => x.Author)
                .Include(x => x.Category)
                .Include(x => x.Publisher)
                .FirstOrDefaultAsync(x => x.Id == id);
        }

        public async Task<Book?> GetByIsbnAsync(string isbn)
        {
            return await _context.Books.FirstOrDefaultAsync(b => b.Isbn == isbn);
        }

        public async Task AddAsync(Book book) => await _context.Books.AddAsync(book);

        public void Update(Book book) => _context.Books.Update(book);

        public void Delete(Book book)
        {
            book.IsDeleted = true;
            _context.Books.Update(book);
        }

        public async Task<bool> SaveChangesAsync() => await _context.SaveChangesAsync() > 0;
    }
}
