namespace BookShopAPI.Services.Admin.AuthorService.DTOs
{
    public class AuthorResponseDTO
    {
        public Guid Id { get; set; }
        public string Name { get; set; }
        public bool IsDeleted { get; set; }
    }
}
