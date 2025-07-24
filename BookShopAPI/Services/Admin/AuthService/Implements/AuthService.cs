using BookShopAPI.Models;
using BookShopAPI.Services.Admin.AuthService.DTOs;
using BookShopAPI.Services.Admin.AuthService.Interfaces;
using BookShopAPI.Services.EmailService;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace BookShopAPI.Services.Admin.AuthService.Implements
{
    public class AuthService : IAuthService
    {
        private readonly IAuthRepository _authRepository;
        private readonly IConfiguration _config;
        private readonly EmailSenderService _emailService;

        public AuthService(IAuthRepository authRepository, IConfiguration config, EmailSenderService emailService)
        {
            _authRepository = authRepository;
            _config = config;
            _emailService = emailService;
        }

        public async Task<bool> RegisterAsync(RegisterDTO registerDTO)
        {
            var existingByEmail = await _authRepository.GetByEmailAsync(registerDTO.Email);
            var existingByPhone = await _authRepository.GetByPhoneAsync(registerDTO.Phone);
            var existingByCitizenIdentification = await _authRepository.GetByCitizenIdentificationAsync(registerDTO.CitizenIdentification);

            if (existingByEmail != null)
                throw new InvalidOperationException("Email đã được sử dụng.");

            if (existingByPhone != null)
                throw new InvalidOperationException("Số điện thoại đã được sử dụng.");

            if (existingByCitizenIdentification != null)
                throw new InvalidOperationException("CCCD đã được sử dụng.");

            if (registerDTO.Password != registerDTO.ConfirmPassword)
                throw new ArgumentException("Mật khẩu xác nhận không khớp với mật khẩu.");

            if (!IsOver18(registerDTO.DateOfBirth))
                throw new ArgumentException("Bạn phải đủ 18 tuổi trở lên.");

            string hashedPassword = BCrypt.Net.BCrypt.HashPassword(registerDTO.Password);

            var staff = new Staff
            {
                FamilyName = registerDTO.FamilyName,
                GivenName = registerDTO.GivenName,
                DateOfBirth = registerDTO.DateOfBirth,
                Address = registerDTO.Address,
                Phone = registerDTO.Phone,
                Email = registerDTO.Email,
                CitizenIdentification = registerDTO.CitizenIdentification,
                HashPassword = hashedPassword,
                Gender = registerDTO.Gender,
                Role = false,
                IsActived = false,
                IsDeleted = false,
            };

            await _authRepository.AddAsync(staff);

            var saved = await _authRepository.SaveChangesAsync();

            if (saved == false)
                return false;

            var token = GenerateActivationToken(staff.Id);
            var activationLink = $"http://localhost:5286/api/admin/auth/activate?token={token}";

            await _emailService.SendEmailAsync(staff.Email, "Kích hoạt tài khoản",
                $"Nhấn vào liên kết sau để kích hoạt tài khoản: <a href='{activationLink}'>Xác minh tài khoản</a>");

            Console.WriteLine($"Gửi email xác nhận đến: {staff.Email} thành công.");

            return true;
        }

        public async Task<bool> ActivateAccountAsync(string token)
        {
            var jwtKey = Environment.GetEnvironmentVariable("JWT_SECRET_KEY") ?? _config["Jwt:Key"];

            var handler = new JwtSecurityTokenHandler();

            var tokenValidationParameters = new TokenValidationParameters
            {
                ValidateIssuerSigningKey = true,
                IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey)),
                ValidateIssuer = false,
                ValidateAudience = false,
                ValidateLifetime = true
            };

            var principal = handler.ValidateToken(token, tokenValidationParameters, out var validatedToken);
            var staffIdClaim = principal.FindFirst("staffId");
            if (staffIdClaim == null) return false;

            var staffId = Guid.Parse(staffIdClaim.Value);
            var staff = await _authRepository.GetByIdAsync(staffId);
            if (staff == null) return false;

            if (staff.IsActived) return false;

            staff.IsActived = true;
            return await _authRepository.SaveChangesAsync();
        }


        private string GenerateActivationToken(Guid staffId)
        {
            var jwtKey = Environment.GetEnvironmentVariable("JWT_SECRET_KEY")
                      ?? _config["Jwt:Key"]
                      ?? throw new Exception("JWT key is missing");

            var jwtIssuer = _config["Jwt:Issuer"];
            var jwtAudience = _config["Jwt:Audience"];
            var expireMinutes = int.Parse(_config["Jwt:ExpireMinutes"] ?? "60");

            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            var claims = new[] { new Claim("staffId", staffId.ToString()) };

            var token = new JwtSecurityToken(
                issuer: jwtIssuer,
                audience: jwtAudience,
                claims: claims,
                expires: DateTime.UtcNow.AddMinutes(expireMinutes),
                signingCredentials: credentials
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }

        public async Task<String?> LoginAsync(LoginDTO loginDTO)
        {
            if (string.IsNullOrWhiteSpace(loginDTO.Email))
                throw new ArgumentException("Vui lòng nhập email và mật khẩu để đăng nhập.");

            var staff = await _authRepository.GetByEmailAsync(loginDTO.Email);

            if (staff == null)
                throw new UnauthorizedAccessException("Tài khoản không hợp lệ, vui lòng kiểm tra email hoặc tạo tài khoản mới.");

            if (staff.IsDeleted)
                throw new UnauthorizedAccessException("Tài khoản của bạn đã bị xóa. Vui lòng liên hệ quản trị viên.");

            if (!staff.IsActived)
                throw new UnauthorizedAccessException("Tài khoản của bạn chưa được kích hoạt. Vui lòng kiểm tra email để kích hoạt.");

            bool isValidPassword = BCrypt.Net.BCrypt.Verify(loginDTO.Password, staff.HashPassword);

            if (!isValidPassword)
                throw new UnauthorizedAccessException("Mật khẩu không đúng. Vui lòng thử lại.");

            var token = GenerateJwtToken(staff);

            return token;
        }

        private string GenerateJwtToken(Staff user)
        {
            var jwtKey = Environment.GetEnvironmentVariable("JWT_SECRET_KEY") ?? _config["Jwt:Key"];
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, user.Email),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                new Claim("staffId", user.Id.ToString()),
                new Claim("email", user.Email),
                new Claim(ClaimTypes.Role, user.Role ? "Admin" : "Staff")
            };

            var token = new JwtSecurityToken(
                issuer: _config["Jwt:Issuer"],
                audience: _config["Jwt:Audience"],
                claims: claims,
                expires: DateTime.UtcNow.AddMinutes(int.Parse(_config["Jwt:ExpireMinutes"] ?? "60")),
                signingCredentials: credentials
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }

        public async Task<bool> ResetPasswordAsync(ResetPasswordDTO resetPasswordDTO)
        {
            var staff = await _authRepository.GetByEmailAsync(resetPasswordDTO.Email);

            if (staff == null)
                throw new UnauthorizedAccessException("Tài khoản không hợp lệ, vui lòng kiểm tra email hoặc tạo tài khoản mới.");

            if (staff.IsDeleted == true)
                throw new UnauthorizedAccessException("Tài khoản của bạn đã bị xóa. Vui lòng liên hệ quản trị viên.");

            if (staff.IsActived == false)
                throw new UnauthorizedAccessException("Tài khoản của bạn chưa được kích hoạt. Vui lòng kiểm tra email để kích hoạt.");

            var token = GenerateResetPasswordToken(staff.Id);
            var resetLink = $"http://localhost:5286/api/admin/auth/reset-password?token={token}";

            await _emailService.SendEmailAsync(staff.Email, "Đặt lại mật khẩu",
                $"Nhấn vào liên kết sau để đặt lại mật khẩu về mặc định: <a href='{resetLink}'>Đặt lại mật khẩu</a>");

            return true;
        }

        public async Task<bool> ResetPasswordFromTokenAsync(string token)
        {
            var jwtKey = Environment.GetEnvironmentVariable("JWT_SECRET_KEY") ?? _config["Jwt:Key"];
            var handler = new JwtSecurityTokenHandler();

            var tokenValidationParameters = new TokenValidationParameters
            {
                ValidateIssuerSigningKey = true,
                IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey)),
                ValidateIssuer = false,
                ValidateAudience = false,
                ValidateLifetime = true
            };

            try
            {
                var principal = handler.ValidateToken(token, tokenValidationParameters, out var validatedToken);
                var staffIdClaim = principal.FindFirst("staffId");
                if (staffIdClaim == null) return false;

                var staffId = Guid.Parse(staffIdClaim.Value);
                var staff = await _authRepository.GetByIdAsync(staffId);
                if (staff == null || staff.IsDeleted) return false;

                staff.HashPassword = BCrypt.Net.BCrypt.HashPassword("123456");
                return await _authRepository.SaveChangesAsync();
            }
            catch
            {
                return false;
            }
        }

        private string GenerateResetPasswordToken(Guid staffId)
        {
            var jwtKey = Environment.GetEnvironmentVariable("JWT_SECRET_KEY") ?? _config["Jwt:Key"];
            var expireMinutes = 15;

            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
                new Claim("staffId", staffId.ToString()),
                new Claim("purpose", "reset_password")
            };

            var token = new JwtSecurityToken(
                claims: claims,
                expires: DateTime.UtcNow.AddMinutes(expireMinutes),
                signingCredentials: credentials
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }

        public async Task<bool> ChangePasswordAsync(Guid staffID, ChangePasswordDTO changePasswordDTO)
        {
            var staff = await _authRepository.GetByIdAsync(staffID);

            if (staff == null)
                throw new UnauthorizedAccessException("Tài khoản không hợp lệ, vui lòng kiểm tra email hoặc tạo tài khoản mới.");

            if (staff.IsDeleted == true)
                throw new UnauthorizedAccessException("Tài khoản của bạn đã bị xóa. Vui lòng liên hệ quản trị viên.");

            if (staff.IsActived == false)
                throw new UnauthorizedAccessException("Tài khoản của bạn chưa được kích hoạt. Vui lòng kiểm tra email để kích hoạt.");

            if (!BCrypt.Net.BCrypt.Verify(changePasswordDTO.OldPassword, staff.HashPassword))
                throw new UnauthorizedAccessException("Mật khẩu cũ không đúng. Vui lòng thử lại.");

            if (changePasswordDTO.NewPassword != changePasswordDTO.ConfirmNewPassword)
                throw new UnauthorizedAccessException("Mật khẩu mới và mật khẩu xác nhận không khớp.");

            staff.HashPassword = BCrypt.Net.BCrypt.HashPassword(changePasswordDTO.NewPassword);

            return await _authRepository.SaveChangesAsync();
        }

        private bool IsOver18(DateOnly dateOfBirth)
        {
            var today = DateOnly.FromDateTime(DateTime.Today);

            if (dateOfBirth > today)
                throw new ArgumentException("Ngày sinh không được nằm trong tương lai.");

            int age = today.Year - dateOfBirth.Year;

            if (dateOfBirth > today.AddYears(-age))
                age--;

            return age >= 18;
        }
    }
}
