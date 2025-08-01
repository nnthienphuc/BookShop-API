using BookShopAPI.Services.Admin.StatisticsService.DTOs;

namespace BookShopAPI.Services.Admin.StatisticsService
{
    public interface IStatisticsService
    {
        Task<RevenueStatisticsDTO> GetRevenueStatistics(DateTime? from, DateTime? to);
    }
}
