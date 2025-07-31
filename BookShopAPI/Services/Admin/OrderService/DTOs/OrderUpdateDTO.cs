namespace BookShopAPI.Services.Admin.OrderService.DTOs
{
    public class OrderUpdateDTO
    {
        public string Status { get; set; }

        public string? Note { get; set; }
        public bool IsDeleted { get; set; }
    }
}
