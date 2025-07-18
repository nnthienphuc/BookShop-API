using System.ComponentModel.DataAnnotations;

namespace BookShopAPI.Services.Admin.AuthService.DTOs
{
    public class ResetPasswordConfirmDTO
    {
        public required string Token { get; set; }

        [Required]
        [StringLength(100, MinimumLength = 6)]
        public required string NewPassword { get; set; }

        [Required]
        [Compare("NewPassword", ErrorMessage = "Confirm password does not match.")]
        public required string ConfirmNewPassword { get; set; }
    }

}
