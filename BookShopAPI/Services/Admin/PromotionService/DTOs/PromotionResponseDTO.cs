﻿namespace BookShopAPI.Services.Admin.PromotionService.DTOs
{
    public class PromotionResponseDTO
    {
        public Guid Id { get; set; }
        public string Name { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public decimal Condition { get; set; }
        public decimal DiscountPercent { get; set; }
        public short Quantity { get; set; }
        public bool IsDeleted { get; set; }
    }
}
