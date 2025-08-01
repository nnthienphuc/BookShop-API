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
            return Ok(new { message = "Đăng ký thành công. Vui lòng kiểm tra email để kích hoạt tài khoản." });
        }

        [HttpGet("activate")]
        public async Task<IActionResult> ActivateAccount([FromQuery] string token)
        {
            await _authService.ActivateAccountAsync(token);
            return Ok(new { message = "Tài khoản đã được kích hoạt thành công." });
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginDTO loginDTO)
        {
            var token = await _authService.LoginAsync(loginDTO);
            return Ok(new { token });
        }

        [HttpPost("reset-password")]
        public async Task<IActionResult> ResetPassword([FromBody] ResetPasswordDTO resetPasswordDTO)
        {
            try
            {
                await _authService.ResetPasswordAsync(resetPasswordDTO);
                return Ok(new { message = "Email đặt lại mật khẩu đã được gửi thành công." });
            }
            catch (UnauthorizedAccessException ex)
            {
                return Unauthorized(new { message = ex.Message });
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpGet("reset-password")]
        public async Task<IActionResult> ResetPassword([FromQuery] string token)
        {
            var success = await _authService.ResetPasswordFromTokenAsync(token);

            if (!success)
                return BadRequest(new { message = "Mã token không hợp lệ hoặc đã hết hạn." });

            return Ok(new { message = "Đặt lại mật khẩu thành công. Mật khẩu mới của bạn là: '123456'." });
        }

        [HttpPut("change-password")]
        [Authorize]
        public async Task<IActionResult> ChangePassword([FromBody] ChangePasswordDTO changePasswordDTO)
        {
            var staffIdClaim = User.FindFirst("staffId");
            if (staffIdClaim == null)
                throw new UnauthorizedAccessException("Token không hợp lệ.");

            var staffId = Guid.Parse(staffIdClaim.Value);
            await _authService.ChangePasswordAsync(staffId, changePasswordDTO);
            return Ok(new { message = "Đã thay đổi mật khẩu thành công." });
        }
    }
}