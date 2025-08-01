using BookShopAPI.Common.Controller;
using BookShopAPI.Services.Admin.StatisticsService;
using Microsoft.AspNetCore.Mvc;

namespace BookShopAPI.Controllers.Admin
{
    [Route("api/admin/statistics")]
    [ApiController]
    public class StatisticsController : ControllerBase
    {
        private readonly IStatisticsService _statistics;

        public StatisticsController(IStatisticsService statistics)
        {
            _statistics = statistics;
        }

        [HttpGet("revenue")]
        public async Task<IActionResult> GetRevenue([FromQuery] DateTime? from, [FromQuery] DateTime? to)
        {
            var result = await _statistics.GetRevenueStatistics(from, to);
            return Ok(result);
        }
    }
}
