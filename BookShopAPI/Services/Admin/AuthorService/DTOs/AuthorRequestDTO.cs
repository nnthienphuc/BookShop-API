namespace BookShopAPI.Services.Admin.AuthorService.DTOs
{
    public class AuthorRequestDTO
    {
        public required string Name { get; set; }
        public required bool IsDeleted { get; set; }
    }
}
