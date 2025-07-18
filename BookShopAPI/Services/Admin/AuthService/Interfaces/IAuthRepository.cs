using BookShopAPI.Models;

namespace BookShopAPI.Services.Admin.AuthService.Interfaces
{
    public interface IAuthRepository
    {
        Task<Staff?> GetByIdAsync(Guid id);
        Task<Staff?> GetByEmailAsync(string email);
        Task<Staff?> GetByPhoneAsync(string phone);
        Task<Staff?> GetByCitizenIdentificationAsync(string citizenIdentification);
        Task AddAsync(Staff staff);
        Task<bool> SaveChangesAsync();
    }
}
