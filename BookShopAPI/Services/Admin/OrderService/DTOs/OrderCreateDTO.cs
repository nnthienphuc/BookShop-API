namespace BookShopAPI.Services.Admin.OrderService.DTOs
{
    public class OrderCreateDTO
    {
        public required Guid CustomerId { get; set; }
        public Guid? PromotionId { get; set; }
        public string PaymentMethod { get; set; }
        public List<OrderItemCreateDTO> Items { get; set; } = new();
    }
}
