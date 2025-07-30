namespace BookShopAPI.Services.Admin.PublisherService.DTOs
{
    public class PublisherResponseDTO
    {
        public Guid Id { get; set; }
        public string Name { get; set; }
        public bool IsDeleted { get; set; }
    }
}
