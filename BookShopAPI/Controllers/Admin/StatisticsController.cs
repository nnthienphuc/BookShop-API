using BookShopAPI.Common.Controller;
using BookShopAPI.Data;
using BookShopAPI.Services.Admin.StatisticsService;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BookShopAPI.Controllers.Admin
{
    [Route("api/admin/statistics")]
    [ApiController]
    public class StatisticsController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly IStatisticsService _statistics;

        public StatisticsController(IStatisticsService statistics, ApplicationDbContext context)
        {
            _statistics = statistics;
            _context = context;
        }

        [HttpGet("revenue")]
        public async Task<IActionResult> GetRevenue([FromQuery] DateTime? from, [FromQuery] DateTime? to)
        {
            var result = await _statistics.GetRevenueStatistics(from, to);
            return Ok(result);
        }

        [HttpGet("growth")]
        public IActionResult GetYearlyGrowth([FromQuery] int year)
        {
            var orders = _context.Orders
                .Where(o => o.CreatedTime.Year == year && !o.IsDeleted && o.Status == "Thành công")
                .ToList();

            var monthlyRevenue = Enumerable.Range(1, 12).ToDictionary(
                month => month,
                month => orders
                    .Where(o => o.CreatedTime.Month == month)
                    .Sum(o => o.TotalAmount)
            );

            return Ok(monthlyRevenue);
        }

    }
}
