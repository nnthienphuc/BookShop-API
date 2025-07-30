namespace BookShopAPI.Services.Admin.PromotionService.DTOs
{
    public class PromotionRequestDTO
    {
        public required string Name { get; set; }
        public required DateTime StartDate { get; set; }
        public required DateTime EndDate { get; set; }
        public required decimal Condition { get; set; }
        public required decimal DiscountPercent { get; set; }
        public required short Quantity { get; set; }
        public required bool IsDeleted { get; set; }
    }
}
