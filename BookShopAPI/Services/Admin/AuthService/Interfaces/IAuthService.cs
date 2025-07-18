using BookShopAPI.Services.Admin.AuthService.DTOs;

namespace BookShopAPI.Services.Admin.AuthService.Interfaces
{
    public interface IAuthService
    {
        Task RegisterAsync(RegisterDTO registerDTO);
        Task<string> LoginAsync(LoginDTO loginDTO);
        Task ActivateAccountAsync(string token);
        Task ResetPasswordAsync(ResetPasswordDTO resetPasswordDTO);
        Task ResetPasswordFromTokenAsync(ResetPasswordConfirmDTO dto);
        Task ChangePasswordAsync(Guid staffId, ChangePasswordDTO changePasswordDTO);
    }
}
