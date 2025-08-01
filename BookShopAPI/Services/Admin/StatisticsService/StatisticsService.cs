using BookShopAPI.Data;
using BookShopAPI.Services.Admin.StatisticsService.DTOs;
using Microsoft.EntityFrameworkCore;

namespace BookShopAPI.Services.Admin.StatisticsService
{
    public class StatisticsService : IStatisticsService
    {
        private readonly ApplicationDbContext _context;

        public StatisticsService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<RevenueStatisticsDTO> GetRevenueStatistics(DateTime? from, DateTime? to)
        {
            var query = _context.Orders
                .Where(o => !o.IsDeleted);

            if (from.HasValue)
            {
                var startOfDay = from.Value.Date;
                query = query.Where(o => o.CreatedTime >= startOfDay);
            }

            if (to.HasValue)
            {
                // Lấy đến cuối ngày (23:59:59.9999999) của ngày to
                var endOfDay = to.Value.Date.AddDays(1).AddTicks(-1);
                query = query.Where(o => o.CreatedTime <= endOfDay);
            }

            var orders = await query.Include(o => o.OrderItems).ToListAsync();

            var dto = new RevenueStatisticsDTO
            {
                TotalOrders = orders.Count,
                TotalBooksSold = orders.Sum(o => o.OrderItems.Sum(oi => oi.Quantity)),
                TotalRevenue = orders.Sum(o => o.TotalAmount),
                RevenueByDate = orders
                    .GroupBy(o => o.CreatedTime.Date)
                    .ToDictionary(
                      g => g.Key.ToString("yyyy-MM-dd"),
                      g => g.Sum(o => o.TotalAmount)
                    )
            };

            return dto;
        }
    }

}
