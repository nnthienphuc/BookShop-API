namespace BookShopAPI.Services.Admin.PublisherService.DTOs
{
    public class PublisherRequestDTO
    {
        public required string Name { get; set; }
        public required bool IsDeleted { get; set; }
    }
}
