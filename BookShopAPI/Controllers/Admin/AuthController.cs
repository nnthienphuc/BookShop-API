using BookShopAPI.Common.Controller;
using BookShopAPI.Services.Admin.AuthService.DTOs;
using BookShopAPI.Services.Admin.AuthService.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BookShopAPI.Controllers.Admin
{
    [AllowAnonymous]
    public class AuthController : BaseController
    {
        private readonly IAuthService _authService;

        public AuthController(IAuthService authService)
        {
            _authService = authService;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterDTO registerDTO)
        {
            await _authService.RegisterAsync(registerDTO);
            return Ok(new { message = "Registration successful. Please check your email to activate your account." });
        }

        [HttpGet("activate")]
        public async Task<IActionResult> ActivateAccount([FromQuery] string token)
        {
            await _authService.ActivateAccountAsync(token);
            return Ok(new { message = "Account activated successfully." });
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginDTO loginDTO)
        {
            var token = await _authService.LoginAsync(loginDTO);
            return Ok(new { token });
        }

        [HttpPost("forgot-password")]
        public async Task<IActionResult> ForgotPassword([FromBody] ResetPasswordDTO resetPasswordDTO)
        {
            await _authService.ResetPasswordAsync(resetPasswordDTO);
            return Ok(new { message = "Reset password email sent successfully." });
        }

        [HttpPost("reset-password")]
        public async Task<IActionResult> ResetPassword([FromQuery] string token)
        {
            await _authService.ResetPasswordFromTokenAsync(token);
            return Ok(new { message = "Password reset successfully. Your new password is: '123456'" });
        }

        [HttpPut("change-password")]
        [Authorize]
        public async Task<IActionResult> ChangePassword([FromBody] ChangePasswordDTO changePasswordDTO)
        {
            var staffIdClaim = User.FindFirst("staffId");
            if (staffIdClaim == null)
                throw new UnauthorizedAccessException("Invalid token.");

            var staffId = Guid.Parse(staffIdClaim.Value);
            await _authService.ChangePasswordAsync(staffId, changePasswordDTO);
            return Ok(new { message = "Password changed successfully." });
        }
    }
}