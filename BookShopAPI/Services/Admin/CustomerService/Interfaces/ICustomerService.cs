using BookShopAPI.Services.Admin.CustomerService.DTOs;

namespace BookShopAPI.Services.Admin.CustomerService.Interfaces
{
    public interface ICustomerService
    {
        Task<IEnumerable<CustomerResponseDTO>> GetAllAsync();
        Task<CustomerResponseDTO?> GetByIdAsync(Guid id);
        Task<CustomerResponseDTO?> GetByPhoneAsync(string phone);
        Task<IEnumerable<CustomerResponseDTO>> SearchByKeywordAsync(string keyword);
        Task<bool> AddAsync(CustomerRequestDTO customerCreateDTO);
        Task<bool> UpdateAsync(Guid id, CustomerRequestDTO customerUpdateDTO);
        Task<bool> DeleteAsync(Guid id);
    }
}
