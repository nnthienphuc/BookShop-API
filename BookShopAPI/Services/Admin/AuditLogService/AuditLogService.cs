using BookShopAPI.Data;
using BookShopAPI.Data.Models;

namespace BookShopAPI.Services.Admin.AuditLogService
{
    public class AuditLogService
    {
        private readonly ApplicationDbContext _context;
        private readonly IHttpContextAccessor _httpContext;

        public AuditLogService(ApplicationDbContext context, IHttpContextAccessor httpContext)
        {
            _context = context;
            _httpContext = httpContext;
        }

        public async Task LogAsync(Guid staffId, string action, string entity, Guid entityId, string? desc = null)
        {
            var context = _httpContext.HttpContext;
            var ip = context?.Connection?.RemoteIpAddress?.ToString();
            var ua = context?.Request?.Headers["User-Agent"].ToString();

            var log = new AuditLog
            {
                StaffId = staffId,
                Action = action,
                EntityName = entity,
                EntityId = entityId,
                Description = desc,
                IPAddress = ip,
                UserAgent = ua
            };

            _context.AuditLogs.Add(log);
            await _context.SaveChangesAsync();
        }
    }
}
