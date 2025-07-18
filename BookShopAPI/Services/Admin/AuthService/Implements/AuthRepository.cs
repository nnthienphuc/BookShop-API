using BookShopAPI.Data;
using BookShopAPI.Models;
using BookShopAPI.Services.Admin.AuthService.Interfaces;
using Microsoft.EntityFrameworkCore;
using Microsoft.Identity.Client;

namespace BookShopAPI.Services.Admin.AuthService.Implements
{
    public class AuthRepository : IAuthRepository
    {
        private readonly ApplicationDbContext _context;

        public AuthRepository(ApplicationDbContext context)
        {
            _context = context ?? throw new ArgumentNullException(nameof(context));
        }

        public async Task AddAsync (Staff staff)
        {
            await _context.Staffs.AddAsync(staff);
        }

        public async Task<Staff?> GetByIdAsync (Guid id)
        {
            return await _context.Staffs.FirstOrDefaultAsync(x => x.Id == id);
        }

        public async Task<Staff?> GetByEmailAsync (string email)
        {
            return await _context.Staffs.FirstOrDefaultAsync(x => x.Email == email);
        }

        public async Task<Staff?> GetByPhoneAsync (string phone)
        {
            return await _context.Staffs.FirstOrDefaultAsync(x => x.Phone == phone);
        }

        public async Task<Staff?> GetByCitizenIdentificationAsync (string citizenIdentification)
        {
            return await _context.Staffs.FirstOrDefaultAsync(x => x.CitizenIdentification == citizenIdentification);
        }

        public async Task<bool> SaveChangesAsync()
        {
            return await _context.SaveChangesAsync() > 0;
        }
    }
}
