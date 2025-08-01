namespace BookShopAPI.Services.Admin.StatisticsService.DTOs
{
    public class RevenueStatisticsDTO
    {
        public int TotalOrders { get; set; }
        public int TotalBooksSold { get; set; }
        public decimal TotalRevenue { get; set; }
        public Dictionary<string, decimal> RevenueByDate { get; set; }
    }
}
