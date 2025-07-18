namespace BookShopAPI.Services.Admin.CategoryService.DTOs
{
    public class CategoryReponseDTO
    {
        public Guid Id { get; set; }
        public string Name { get; set; }
        public bool IsDeleted { get; set; }
    }
}
