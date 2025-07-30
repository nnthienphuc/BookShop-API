using BookShopAPI.Data;
using BookShopAPI.Models;
using BookShopAPI.Services.Admin.PublisherService.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace BookShopAPI.Services.Admin.PublisherService.Implements
{
    public class PublisherRepository : IPublisherRepository
    {
        private readonly ApplicationDbContext _context;

        public PublisherRepository(ApplicationDbContext context)
        {
            _context = context ?? throw new ArgumentNullException(nameof(context));
        }

        public async Task<IEnumerable<Publisher>> GetAllAsync()
        {
            return await _context.Publishers.ToListAsync();
        }

        public async Task<Publisher?> GetByIdAsync(Guid id)
        {
            return await _context.Publishers.FirstOrDefaultAsync(x => x.Id == id);
        }

        public async Task<Publisher?> GetByNameAsync(string name)
        {
            return await _context.Publishers.FirstOrDefaultAsync(x => x.Name == name);
        }

        public async Task<IEnumerable<Publisher>> SearchByKeywordAsync(string? keyword)
        {
            return string.IsNullOrWhiteSpace(keyword)
                ? await _context.Publishers.ToListAsync()
                : await _context.Publishers.Where(x => x.Name.Contains(keyword)).ToListAsync();
        }

        public async Task AddAsync(Publisher publisher)
        {
            await _context.Publishers.AddAsync(publisher);
        }

        public void Update(Publisher publisher)
        {
            _context.Update(publisher);
        }

        public void Delete(Publisher publisher)
        {
            publisher.IsDeleted = true;

            _context.Update(publisher);
        }

        public async Task<bool> SaveChangesAsync()
        {
            return await _context.SaveChangesAsync() > 0;
        }
    }
}
