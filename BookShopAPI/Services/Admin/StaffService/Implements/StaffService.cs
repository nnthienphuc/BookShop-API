using BookShopAPI.Common.Enum;
using BookShopAPI.Common.Helper;
using BookShopAPI.Data;
using BookShopAPI.Models;
using BookShopAPI.Services.Admin.StaffService.DTOs;
using BookShopAPI.Services.Admin.StaffService.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace BookShopAPI.Services.Admin.StaffService.Implements
{
    public class StaffService : IStaffService
    {
        private readonly IStaffRepository _staffRepository;
        private readonly ApplicationDbContext _context;
        private readonly IHttpContextAccessor _httpContext;

        public StaffService(IStaffRepository staffRepository, ApplicationDbContext context, IHttpContextAccessor httpContext)
        {
            _staffRepository = staffRepository;
            _context = context;
            _httpContext = httpContext;
        }

        public async Task<IEnumerable<StaffResponseDTO>> GetAllAsync()
        {
            var staffs = await _staffRepository.GetAllAsync();

            return staffs.Select(s => new StaffResponseDTO
            {
                Id = s.Id,
                FamilyName = s.FamilyName,
                GivenName = s.GivenName,
                DateOfBirth = s.DateOfBirth,
                Address = s.Address,
                Phone = s.Phone,
                Email = s.Email,
                CitizenIdentification = s.CitizenIdentification,
                Role = s.Role,
                Gender = s.Gender,
                IsActived = s.IsActived,
                IsDeleted = s.IsDeleted
            });
        }

        public async Task<StaffResponseDTO?> GetByIdAsync(Guid id)
        {
            var staff = await _staffRepository.GetByIdAsync(id);

            if (staff == null)
                throw new KeyNotFoundException($"Không tìm thấy nhân viên với ID '{id}'.");

            return new StaffResponseDTO
            {
                Id = staff.Id,
                FamilyName = staff.FamilyName,
                GivenName = staff.GivenName,
                DateOfBirth = staff.DateOfBirth,
                Address = staff.Address,
                Phone = staff.Phone,
                Email = staff.Email,
                CitizenIdentification = staff.CitizenIdentification,
                Role = staff.Role,
                Gender = staff.Gender,
                IsActived = staff.IsActived,
                IsDeleted = staff.IsDeleted
            };
        }

        public async Task<StaffResponseDTO?> GetByPhoneAsync(string phone)
        {
            var staff = await _staffRepository.GetByPhoneAsync(phone);

            if (staff == null)
                throw new KeyNotFoundException($"Không tìm thấy nhân viên với số điện thoại '{phone}'.");

            return new StaffResponseDTO
            {
                Id = staff.Id,
                FamilyName = staff.FamilyName,
                GivenName = staff.GivenName,
                DateOfBirth = staff.DateOfBirth,
                Address = staff.Address,
                Phone = staff.Phone,
                Email = staff.Email,
                CitizenIdentification = staff.CitizenIdentification,
                Role = staff.Role,
                Gender = staff.Gender,
                IsActived = staff.IsActived,
                IsDeleted = staff.IsDeleted
            };
        }

        public async Task<StaffResponseDTO?> GetByEmailAsync(string email)
        {
            var staff = await _staffRepository.GetByEmailAsync(email);

            if (staff == null)
                throw new KeyNotFoundException($"Không tìm thấy nhân viên với email '{email}'.");

            return new StaffResponseDTO
            {
                Id = staff.Id,
                FamilyName = staff.FamilyName,
                GivenName = staff.GivenName,
                DateOfBirth = staff.DateOfBirth,
                Address = staff.Address,
                Phone = staff.Phone,
                Email = staff.Email,
                CitizenIdentification = staff.CitizenIdentification,
                Role = staff.Role,
                Gender = staff.Gender,
                IsActived = staff.IsActived,
                IsDeleted = staff.IsDeleted
            };
        }

        public async Task<StaffResponseDTO?> GetByCitizenIdentificationAsync(string citizenIdentification)
        {
            var staff = await _staffRepository.GetByCitizenIdentificationAsync(citizenIdentification);

            if (staff == null)
                throw new KeyNotFoundException($"Không tìm thấy nhân viên với số CCCD '{citizenIdentification}'.");

            return new StaffResponseDTO
            {
                Id = staff.Id,
                FamilyName = staff.FamilyName,
                GivenName = staff.GivenName,
                DateOfBirth = staff.DateOfBirth,
                Address = staff.Address,
                Phone = staff.Phone,
                Email = staff.Email,
                CitizenIdentification = staff.CitizenIdentification,
                Role = staff.Role,
                Gender = staff.Gender,
                IsActived = staff.IsActived,
                IsDeleted = staff.IsDeleted
            };
        }

        public async Task<IEnumerable<StaffResponseDTO>> SearchByKeywordAsync(string keyword)
        {
            var staffs = await _staffRepository.SearchByKeyword(keyword);

            return staffs.Select(s => new StaffResponseDTO
            {
                Id = s.Id,
                FamilyName = s.FamilyName,
                GivenName = s.GivenName,
                DateOfBirth = s.DateOfBirth,
                Address = s.Address,
                Phone = s.Phone,
                Email = s.Email,
                CitizenIdentification = s.CitizenIdentification,
                Role = s.Role,
                Gender = s.Gender,
                IsActived = s.IsActived,
                IsDeleted = s.IsDeleted
            });
        }

        public async Task<bool> UpdateAsync(Guid id, StaffRequestDTO staffUpdateDTO)
        {
            if (!IsOver18(staffUpdateDTO.DateOfBirth))
                throw new ArgumentException("Nhân viên phải từ 18 tuổi trở lên.");

            if (!IsValidEmail(staffUpdateDTO.Email))
                throw new ArgumentException("Email của nhân viên không đúng định dạng.");

            var existingStaff = await _staffRepository.GetByIdAsync(id);

            if (existingStaff == null)
                throw new KeyNotFoundException($"Không tìm thấy nhân viên với ID '{id}'.");

            var duplicatePhone = await _staffRepository.GetByPhoneAsync(staffUpdateDTO.Phone);
            if (duplicatePhone != null && id != duplicatePhone.Id)
                throw new InvalidOperationException("Đã tồn tại nhân viên khác với cùng số điện thoại.");

            var duplicateEmail = await _staffRepository.GetByEmailAsync(staffUpdateDTO.Email);
            if (duplicateEmail != null && id != duplicateEmail.Id)
                throw new InvalidOperationException("Đã tồn tại nhân viên khác với cùng email.");

            var duplicateCitizenIdentification = await _staffRepository.GetByCitizenIdentificationAsync(staffUpdateDTO.CitizenIdentification);
            if (duplicateCitizenIdentification != null && id != duplicateCitizenIdentification.Id)
                throw new InvalidOperationException("Đã tồn tại nhân viên khác với cùng số CCCD.");

            var logStaff = new Staff
            {
                FamilyName = existingStaff.FamilyName,
                GivenName = existingStaff.GivenName,
                DateOfBirth = existingStaff.DateOfBirth,
                Address = existingStaff.Address,
                Phone = existingStaff.Phone,
                Email = existingStaff.Email,
                CitizenIdentification = existingStaff.CitizenIdentification,
                Role = existingStaff.Role,
                Gender = existingStaff.Gender,
                IsDeleted = existingStaff.IsDeleted,
            };

            existingStaff.FamilyName = staffUpdateDTO.FamilyName;
            existingStaff.GivenName = staffUpdateDTO.GivenName;
            existingStaff.DateOfBirth = staffUpdateDTO.DateOfBirth;
            existingStaff.Address = staffUpdateDTO.Address;
            existingStaff.Phone = staffUpdateDTO.Phone;
            existingStaff.Email = staffUpdateDTO.Email;
            existingStaff.CitizenIdentification = staffUpdateDTO.CitizenIdentification;
            existingStaff.Role = staffUpdateDTO.Role;
            existingStaff.Gender = staffUpdateDTO.Gender;
            existingStaff.IsDeleted = staffUpdateDTO.IsDeleted;

            _staffRepository.Update(existingStaff);

            var result = await _staffRepository.SaveChangesAsync();

            if (result)
            {
                await AuditHelper.LogAuditAsync(
                    _httpContext,
                    _context,
                    AuditAction.UPDATE,
                    "Staff",
                    id,
                    $"Updated staff '{logStaff.FamilyName}' to '{existingStaff.FamilyName}', '{logStaff.GivenName}' to '{existingStaff.GivenName}', '{logStaff.DateOfBirth}' to '{existingStaff.DateOfBirth}', '{logStaff.Address}' to '{existingStaff.Address}', '{logStaff.Phone}' to '{existingStaff.Phone}', '{logStaff.Email}' to '{existingStaff.Email}', '{logStaff.CitizenIdentification}' to '{existingStaff.CitizenIdentification}', '{logStaff.Role}' to '{existingStaff.Role}', '{logStaff.Gender}' to '{existingStaff.Gender}'"
                );
            }

            return result;
        }

        public async Task<bool> DeleteAsync(Guid id)
        {
            var existingStaff = await _staffRepository.GetByIdAsync(id);

            if (existingStaff == null)
                throw new KeyNotFoundException($"Không tìm thấy nhân viên với ID '{id}'.");

            if (existingStaff.IsDeleted == true)
                throw new InvalidOperationException($"Nhân viên với ID {id} đã bị xoá trước đó.");

            _staffRepository.Delete(existingStaff);

            var result = await _staffRepository.SaveChangesAsync();

            if (result)
            {
                await AuditHelper.LogAuditAsync(
                    _httpContext,
                    _context,
                    AuditAction.DELETE,
                    "Staff",
                    id,
                    $"Soft deleted staff '{existingStaff.FamilyName} {existingStaff.GivenName}'"
                );
            }

            return result;
        }

        private bool IsOver18(DateOnly dateOfBirth)
        {
            var today = DateOnly.FromDateTime(DateTime.Today);

            if (dateOfBirth > today)
                throw new ArgumentException("Ngày sinh không thể nằm trong tương lai.");

            int age = today.Year - dateOfBirth.Year;

            if (dateOfBirth > today.AddYears(-age))
                age--;

            return age >= 18;
        }

        private bool IsValidEmail(string email)
        {
            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                return addr.Address == email;
            }
            catch
            {
                return false;
            }
        }
    }
}
