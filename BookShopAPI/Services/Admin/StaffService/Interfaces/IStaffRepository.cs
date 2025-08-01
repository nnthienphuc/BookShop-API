﻿using BookShopAPI.Models;

namespace BookShopAPI.Services.Admin.StaffService.Interfaces
{
    public interface IStaffRepository
    {
        Task<IEnumerable<Staff>> GetAllAsync();
        Task<Staff?> GetByIdAsync(Guid id);
        Task<Staff?> GetByPhoneAsync(string phone);
        Task<Staff?> GetByEmailAsync(string email);
        Task<Staff?> GetByCitizenIdentificationAsync(string citizenIdentification);
        Task<IEnumerable<Staff>> SearchByKeyword(string keyword);
        void Update(Staff staff);
        void Delete(Staff staff);
        Task<bool> SaveChangesAsync();
    }
}
