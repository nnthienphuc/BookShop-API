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
        private readonly IAuthRepository _repo;
        private readonly EmailSenderService _emailSenderService;
        private readonly IConfiguration _config;

        public AuthService(IAuthRepository repo, IConfiguration config, EmailSenderService emailSenderService)
        {
            _repo = repo;
            _config = config;
            _emailSenderService = emailSenderService;
        }

        public async Task RegisterAsync(RegisterDTO dto)
        {
            if (await _repo.GetByEmailAsync(dto.Email) != null)
                throw new InvalidOperationException("Email is already in use.");

            if (await _repo.GetByPhoneAsync(dto.Phone) != null)
                throw new InvalidOperationException("Phone is already in use.");

            if (await _repo.GetByCitizenIdentificationAsync(dto.CitizenIdentification) != null)
                throw new InvalidOperationException("Citizen identification is already in use.");

            if (dto.Password != dto.ConfirmPassword)
                throw new ArgumentException("Confirm password does not match password.");

            if (!IsOver18(dto.DateOfBirth))
                throw new ArgumentException("You must be at least 18 years old.");

            var hashedPassword = BCrypt.Net.BCrypt.HashPassword(dto.Password);

            var staff = new Staff
            {
                FamilyName = dto.FamilyName,
                GivenName = dto.GivenName,
                DateOfBirth = dto.DateOfBirth,
                Address = dto.Address,
                Phone = dto.Phone,
                Email = dto.Email,
                CitizenIdentification = dto.CitizenIdentification,
                HashPassword = hashedPassword,
                Gender = dto.Gender,
                Role = false,
                IsActived = false
            };

            await _repo.AddAsync(staff);
            await _repo.SaveChangesAsync();

            var token = GenerateActivationToken(staff.Id);
            var link = $"http://localhost:5286/api/auth/activate?token={token}";
            await _emailSenderService.SendEmailAsync(staff.Email, "Activate your account",
                $"Click to activate: <a href='{link}'>Verify account</a>");
        }

        public async Task ActivateAccountAsync(string token)
        {
            var principal = GetPrincipalFromToken(token);
            var staffId = GetStaffIdFromClaims(principal);
            var staff = await _repo.GetByIdAsync(staffId) ?? throw new KeyNotFoundException("Staff not found.");

            if (staff.IsActived)
                throw new InvalidOperationException("Account is already activated.");

            staff.IsActived = true;
            await _repo.SaveChangesAsync();
        }

        public async Task<string> LoginAsync(LoginDTO dto)
        {
            if (string.IsNullOrWhiteSpace(dto.Email))
                throw new ArgumentException("Email is required.");

            var staff = await _repo.GetByEmailAsync(dto.Email)
                ?? throw new UnauthorizedAccessException("Invalid email or account does not exist.");

            if (staff.IsDeleted)
                throw new UnauthorizedAccessException("Your account has been deleted.");

            if (!staff.IsActived)
                throw new UnauthorizedAccessException("Your account is not activated.");

            if (!BCrypt.Net.BCrypt.Verify(dto.Password, staff.HashPassword))
                throw new UnauthorizedAccessException("Invalid password.");

            return GenerateJwtToken(staff);
        }

        public async Task ResetPasswordAsync(ResetPasswordDTO dto)
        {
            var staff = await _repo.GetByEmailAsync(dto.Email)
                ?? throw new UnauthorizedAccessException("Invalid account.");

            if (staff.IsDeleted)
                throw new UnauthorizedAccessException("Your account has been deleted.");

            if (!staff.IsActived)
                throw new UnauthorizedAccessException("Your account is not activated.");

            var token = GenerateResetPasswordToken(staff.Id);
            var link = $"http://localhost:5208/api/auth/reset-password?token={token}";

            await _emailSenderService.SendEmailAsync(staff.Email, "Reset Password",
                $"Click to reset: <a href='{link}'>Reset Password</a>");
        }

        public async Task ResetPasswordFromTokenAsync(ResetPasswordConfirmDTO dto)
        {
            var principal = GetPrincipalFromToken(dto.Token);
            var staffId = GetStaffIdFromClaims(principal);
            var staff = await _repo.GetByIdAsync(staffId) ?? throw new KeyNotFoundException("Staff not found.");

            if (staff.IsDeleted)
                throw new UnauthorizedAccessException("Your account has been deleted.");

            if (!staff.IsActived)
                throw new UnauthorizedAccessException("Your account is not activated.");

            if (dto.NewPassword != dto.ConfirmNewPassword)
                throw new ArgumentException("New password and confirm password do not match.");

            staff.HashPassword = BCrypt.Net.BCrypt.HashPassword(dto.NewPassword);
            await _repo.SaveChangesAsync();
        }


        public async Task ChangePasswordAsync(Guid staffId, ChangePasswordDTO dto)
        {
            var staff = await _repo.GetByIdAsync(staffId)
                ?? throw new UnauthorizedAccessException("Invalid account.");

            if (staff.IsDeleted)
                throw new UnauthorizedAccessException("Your account has been deleted.");

            if (!staff.IsActived)
                throw new UnauthorizedAccessException("Your account is not activated.");

            if (!BCrypt.Net.BCrypt.Verify(dto.OldPassword, staff.HashPassword))
                throw new UnauthorizedAccessException("Old password is incorrect.");

            if (dto.NewPassword != dto.ConfirmNewPassword)
                throw new ArgumentException("New password and confirm do not match.");

            staff.HashPassword = BCrypt.Net.BCrypt.HashPassword(dto.NewPassword);
            await _repo.SaveChangesAsync();
        }

        private string GenerateJwtToken(Staff staff)
        {
            var jwtKey = _config["Jwt:Key"] ?? throw new Exception("JWT key missing");
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, staff.Email),
                new Claim("staffId", staff.Id.ToString()),
                new Claim("email", staff.Email),
                new Claim(ClaimTypes.Role, staff.Role ? "Admin" : "Staff")
            };

            var token = new JwtSecurityToken(
                issuer: _config["Jwt:Issuer"],
                audience: _config["Jwt:Audience"],
                claims: claims,
                expires: DateTime.UtcNow.AddMinutes(int.Parse(_config["Jwt:ExpireMinutes"] ?? "60")),
                signingCredentials: credentials);

            return new JwtSecurityTokenHandler().WriteToken(token);
        }

        private string GenerateActivationToken(Guid staffId)
        {
            return GenerateTokenWithClaims(new[] { new Claim("staffId", staffId.ToString()) }, 60);
        }

        private string GenerateResetPasswordToken(Guid staffId)
        {
            return GenerateTokenWithClaims(new[]
            {
                new Claim("staffId", staffId.ToString()),
                new Claim("purpose", "reset_password")
            }, 15);
        }

        private string GenerateTokenWithClaims(IEnumerable<Claim> claims, int expireMinutes)
        {
            var key = _config["Jwt:Key"] ?? throw new Exception("JWT key missing");
            var credentials = new SigningCredentials(new SymmetricSecurityKey(Encoding.UTF8.GetBytes(key)), SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken(
                claims: claims,
                expires: DateTime.UtcNow.AddMinutes(expireMinutes),
                signingCredentials: credentials);

            return new JwtSecurityTokenHandler().WriteToken(token);
        }

        private ClaimsPrincipal GetPrincipalFromToken(string token)
        {
            var jwtKey = _config["Jwt:Key"] ?? throw new Exception("JWT key missing");

            var handler = new JwtSecurityTokenHandler();
            var parameters = new TokenValidationParameters
            {
                ValidateIssuerSigningKey = true,
                IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey)),
                ValidateIssuer = false,
                ValidateAudience = false,
                ValidateLifetime = true
            };

            return handler.ValidateToken(token, parameters, out _);
        }

        private Guid GetStaffIdFromClaims(ClaimsPrincipal principal)
        {
            var claim = principal.FindFirst("staffId") ?? throw new UnauthorizedAccessException("Token invalid.");
            return Guid.Parse(claim.Value);
        }

        private bool IsOver18(DateOnly birth)
        {
            var today = DateOnly.FromDateTime(DateTime.Today);
            var age = today.Year - birth.Year;
            if (birth > today.AddYears(-age)) age--;
            return age >= 18;
        }
    }
}
