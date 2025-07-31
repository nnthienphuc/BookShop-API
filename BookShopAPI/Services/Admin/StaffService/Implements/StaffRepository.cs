using BookShopAPI.Data;
using BookShopAPI.Models;
using BookShopAPI.Services.Admin.StaffService.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace BookShopAPI.Services.Admin.StaffService.Implements
{
    public class StaffRepository : IStaffRepository
    {
        private readonly ApplicationDbContext _context;

        public StaffRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Staff>> GetAllAsync()
        {
            return await _context.Staffs.ToListAsync();
        }

        public async Task<Staff?> GetByIdAsync(Guid id)
        {
            return await _context.Staffs.FirstOrDefaultAsync(s => s.Id == id);
        }

        public async Task<Staff?> GetByPhoneAsync(string phone)
        {
            return await _context.Staffs.FirstOrDefaultAsync(s => s.Phone == phone);
        }

        public async Task<Staff?> GetByEmailAsync(string email)
        {
            return await _context.Staffs.FirstOrDefaultAsync(s => s.Email.ToLower() == email.ToLower());
        }

        public async Task<Staff?> GetByCitizenIdentificationAsync(string citizenIdentification)
        {
            return await _context.Staffs.FirstOrDefaultAsync(s => s.CitizenIdentification == citizenIdentification);
        }

        public async Task<IEnumerable<Staff>> SearchByKeyword(string keyword)
        {
            return string.IsNullOrWhiteSpace(keyword)
                ? await _context.Staffs.ToListAsync()
                : await _context.Staffs
                .Where(p => p.FamilyName.Contains(keyword) || p.GivenName.Contains(keyword) || p.Address.Contains(keyword)
                || p.Phone.Contains(keyword) || p.Email.Contains(keyword) || p.CitizenIdentification.Contains(keyword))
                .ToListAsync();
        }

        public void Update(Staff staff)
        {
            _context.Staffs.Update(staff);
        }

        public void Delete(Staff staff)
        {
            staff.IsDeleted = true;

            _context.Update(staff);
        }

        public async Task<bool> SaveChangesAsync()
        {
            return await _context.SaveChangesAsync() > 0;
        }
    }
}
