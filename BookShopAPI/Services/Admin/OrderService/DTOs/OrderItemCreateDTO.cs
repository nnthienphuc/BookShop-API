namespace BookShopAPI.Services.Admin.OrderService.DTOs
{
    public class OrderItemCreateDTO
    {
        public required Guid BookId { get; set; }
        public required short Quantity { get; set; }
    }
}
