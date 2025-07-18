namespace BookShopAPI.Services.Admin.CategoryService.DTOs
{
    public class CategoryRequestDTO
    {
        public required string Name { get; set; }
        public required bool IsDeleted { get; set; }
    }
}
