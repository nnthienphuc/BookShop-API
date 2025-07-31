using System.ComponentModel.DataAnnotations;

namespace BookShopAPI.Services.Admin.CustomerService.DTOs
{
    public class CustomerRequestDTO
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

        public required bool Gender { get; set; }
        public required bool IsDeleted { get; set; }
    }
}
