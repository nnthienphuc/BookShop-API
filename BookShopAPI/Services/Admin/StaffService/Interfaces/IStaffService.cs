using BookShopAPI.Services.Admin.StaffService.DTOs;

namespace BookShopAPI.Services.Admin.StaffService.Interfaces
{
    public interface IStaffService
    {
        Task<IEnumerable<StaffResponseDTO>> GetAllAsync();
        Task<StaffResponseDTO?> GetByIdAsync(Guid id);
        Task<StaffResponseDTO?> GetByPhoneAsync(string phone);
        Task<StaffResponseDTO?> GetByEmailAsync(string email);
        Task<StaffResponseDTO?> GetByCitizenIdentificationAsync(string citizenIdentification);
        Task<IEnumerable<StaffResponseDTO>> SearchByKeywordAsync(string keyword);
        Task<bool> UpdateAsync(Guid id, StaffRequestDTO staffUpdateDTO);
        Task<bool> DeleteAsync(Guid id);
    }
}
