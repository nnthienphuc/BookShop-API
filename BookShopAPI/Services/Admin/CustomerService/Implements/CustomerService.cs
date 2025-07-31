using BookShopAPI.Common.Enum;
using BookShopAPI.Common.Helper;
using BookShopAPI.Data;
using BookShopAPI.Models;
using BookShopAPI.Services.Admin.CustomerService.DTOs;
using BookShopAPI.Services.Admin.CustomerService.Interfaces;

namespace BookShopAPI.Services.Admin.CustomerService.Implements
{
    public class CustomerService : ICustomerService
    {
        private readonly ICustomerRepository _customerRepository;
        private readonly ApplicationDbContext _context;
        private readonly IHttpContextAccessor _httpContext;

        public CustomerService(ICustomerRepository customerRepository, ApplicationDbContext context, IHttpContextAccessor httpContext)
        {
            _customerRepository = customerRepository;
            _context = context;
            _httpContext = httpContext;
        }

        public async Task<IEnumerable<CustomerResponseDTO>> GetAllAsync()
        {
            var customers = await _customerRepository.GetAllAsync();

            return customers.Select(c => new CustomerResponseDTO
            {
                Id = c.Id,
                FamilyName = c.FamilyName,
                GivenName = c.GivenName,
                DateOfBirth = c.DateOfBirth,
                Address = c.Address,
                Phone = c.Phone,
                Gender = c.Gender,
                Email = c.Email,
                IsDeleted = c.IsDeleted
            });
        }

        public async Task<CustomerResponseDTO?> GetByIdAsync(Guid id)
        {
            var customer = await _customerRepository.GetByIdAsync(id);

            if (customer == null)
                throw new KeyNotFoundException($"Không tìm thấy khách hàng với ID '{id}'.");

            return new CustomerResponseDTO
            {
                Id = customer.Id,
                FamilyName = customer.FamilyName,
                GivenName = customer.GivenName,
                DateOfBirth = customer.DateOfBirth,
                Address = customer.Address,
                Phone = customer.Phone,
                Gender = customer.Gender,
                Email = customer.Email,
                IsDeleted = customer.IsDeleted
            };
        }

        public async Task<CustomerResponseDTO?> GetByPhoneAsync(string phone)
        {
            var customer = await _customerRepository.GetByPhoneAsync(phone);

            if (customer == null)
                throw new KeyNotFoundException($"Không tìm thấy khách hàng với số điện thoại '{phone}'.");

            return new CustomerResponseDTO
            {
                Id = customer.Id,
                FamilyName = customer.FamilyName,
                GivenName = customer.GivenName,
                DateOfBirth = customer.DateOfBirth,
                Address = customer.Address,
                Phone = customer.Phone,
                Gender = customer.Gender,
                Email = customer.Email,
                IsDeleted = customer.IsDeleted
            };
        }

        public async Task<IEnumerable<CustomerResponseDTO>> SearchByKeywordAsync(string keyword)
        {
            var customers = await _customerRepository.SearchByKeywordAsync(keyword);

            return customers.Select(c => new CustomerResponseDTO
            {
                Id = c.Id,
                FamilyName = c.FamilyName,
                GivenName = c.GivenName,
                DateOfBirth = c.DateOfBirth,
                Address = c.Address,
                Phone = c.Phone,
                Gender = c.Gender,
                Email = c.Email,
                IsDeleted = c.IsDeleted
            });
        }

        public async Task<bool> AddAsync(CustomerRequestDTO customerCreateDTO)
        {
            if (!IsOver18(customerCreateDTO.DateOfBirth))
                throw new ArgumentException("Khách hàng phải từ 18 tuổi trở lên.");

            var existingCustomer = await _customerRepository.GetByPhoneAsync(customerCreateDTO.Phone);
            if (existingCustomer != null)
                throw new InvalidOperationException("Đã tồn tại khách hàng với số điện thoại này.");

            var customer = new Customer
            {
                FamilyName = customerCreateDTO.FamilyName,
                GivenName = customerCreateDTO.GivenName,
                DateOfBirth = customerCreateDTO.DateOfBirth,
                Address = customerCreateDTO.Address,
                Phone = customerCreateDTO.Phone,
                Gender = customerCreateDTO.Gender
            };

            await _customerRepository.AddAsync(customer);

            var result = await _customerRepository.SaveChangesAsync();

            if (result)
            {
                await AuditHelper.LogAuditAsync(
                    _httpContext,
                    _context,
                    AuditAction.ADD,
                    "Customer",
                    customer.Id,
                    $"Created category '{customer.FamilyName}' + ' ' + '{customer.GivenName}'"
                );
            }

            return result;
        }

        public async Task<bool> UpdateAsync(Guid id, CustomerRequestDTO customerUpdateDTO)
        {
            var existingCustomer = await _customerRepository.GetByIdAsync(id);
            if (existingCustomer == null)
                throw new KeyNotFoundException($"Không tìm thấy khách hàng với ID '{id}'.");

            if (!IsOver18(customerUpdateDTO.DateOfBirth))
                throw new ArgumentException("Khách hàng phải từ 18 tuổi trở lên.");

            var duplicateCustomer = await _customerRepository.GetByPhoneAsync(customerUpdateDTO.Phone);
            if (duplicateCustomer != null && duplicateCustomer.Id != id)
                throw new InvalidOperationException("Đã tồn tại khách hàng khác với cùng số điện thoại.");

            var logCustomer = new Customer
            {
                FamilyName = existingCustomer.FamilyName,
                GivenName = existingCustomer.GivenName,
                DateOfBirth = existingCustomer.DateOfBirth,
                Address = existingCustomer.Address,
                Phone = existingCustomer.Phone,
                Gender = existingCustomer.Gender,
                IsDeleted = existingCustomer.IsDeleted,
                IsActived = false
            };

            existingCustomer.FamilyName = customerUpdateDTO.FamilyName;
            existingCustomer.GivenName = customerUpdateDTO.GivenName;
            existingCustomer.DateOfBirth = customerUpdateDTO.DateOfBirth;
            existingCustomer.Address = customerUpdateDTO.Address;
            existingCustomer.Phone = customerUpdateDTO.Phone;
            existingCustomer.Gender = customerUpdateDTO.Gender;
            existingCustomer.IsDeleted = customerUpdateDTO.IsDeleted;

            _customerRepository.Update(existingCustomer);

            var result = await _customerRepository.SaveChangesAsync();

            if (result)
            {
                await AuditHelper.LogAuditAsync(
                    _httpContext,
                    _context,
                    AuditAction.UPDATE,
                    "Customer",
                    id,
                    $"Updated category '{logCustomer.FamilyName}' to '{existingCustomer.FamilyName}', '{logCustomer.GivenName}' to '{existingCustomer.GivenName}', '{logCustomer.DateOfBirth}' to '{existingCustomer.DateOfBirth}', '{logCustomer.Address}' to '{existingCustomer.Address}', '{logCustomer.Phone}' to '{existingCustomer.Phone}', '{logCustomer.Gender}' to '{existingCustomer.Gender}'"
                );
            }

            return result;
        }

        public async Task<bool> DeleteAsync(Guid id)
        {
            var existingCustomer = await _customerRepository.GetByIdAsync(id);

            if (existingCustomer == null)
                throw new KeyNotFoundException($"Không tìm thấy khách hàng với ID '{id}'.");

            if (existingCustomer.IsDeleted == true)
                throw new InvalidOperationException($"Khách hàng với ID {id} đã bị xoá trước đó.");

            _customerRepository.Delete(existingCustomer);

            var result = await _customerRepository.SaveChangesAsync();

            if (result)
            {
                await AuditHelper.LogAuditAsync(
                    _httpContext,
                    _context,
                    AuditAction.DELETE,
                    "Customer",
                    id,
                    $"Soft deleted category '{existingCustomer.FamilyName} {existingCustomer.GivenName}'"
                );
            }

            return result;
        }

        public bool IsOver18(DateOnly dateOfBirth)
        {
            var today = DateOnly.FromDateTime(DateTime.Today);
            int age = today.Year - dateOfBirth.Year;

            if (dateOfBirth > today.AddYears(-age))
                age--;

            return age >= 18;
        }
    }
}
