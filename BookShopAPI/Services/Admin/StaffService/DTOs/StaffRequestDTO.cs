using System.ComponentModel.DataAnnotations;

namespace BookShopAPI.Services.Admin.StaffService.DTOs
{
    public class StaffRequestDTO
    {
        [Required(ErrorMessage = "Họ không được để trống.")]
        [StringLength(70)]
        [RegularExpression(@".*\S.*", ErrorMessage = "Họ không được chỉ chứa khoảng trắng.")]
        public required string FamilyName { get; set; }

        [Required(ErrorMessage = "Tên không được để trống.")]
        [StringLength(30)]
        [RegularExpression(@".*\S.*", ErrorMessage = "Tên không được chỉ chứa khoảng trắng.")]
        public required string GivenName { get; set; }

        public required DateOnly DateOfBirth { get; set; }

        [Required(ErrorMessage = "Địa chỉ không được để trống.")]
        [StringLength(50)]
        [RegularExpression(@".*\S.*", ErrorMessage = "Địa chỉ không được chỉ chứa khoảng trắng.")]
        public required string Address { get; set; }

        [Required(ErrorMessage = "Số điện thoại không được để trống.")]
        [StringLength(10)]
        [RegularExpression(@"\S+", ErrorMessage = "Số điện thoại không được chỉ chứa khoảng trắng.")]
        public required string Phone { get; set; }

        [Required(ErrorMessage = "Email không được để trống.")]
        [StringLength(50)]
        [RegularExpression(@"\S+", ErrorMessage = "Email không được chỉ chứa khoảng trắng.")]
        public required string Email { get; set; }

        [Required(ErrorMessage = "Số căn cước công dân không được để trống.")]
        [StringLength(12)]
        [RegularExpression(@"\S+", ErrorMessage = "Số căn cước công dân không được chỉ chứa khoảng trắng.")]
        public required string CitizenIdentification { get; set; }

        public required bool Role { get; set; }
        public required bool Gender { get; set; }
        public required bool IsActived { get; set; }
        public required bool IsDeleted { get; set; }
    }
}
