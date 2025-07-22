using BookShopAPI.Common.Enum;
using BookShopAPI.Data;
using BookShopAPI.Data.Models;

namespace BookShopAPI.Common.Helper
{
    public static class AuditHelper
    {
        public static async Task LogAuditAsync(
            IHttpContextAccessor httpContextAccessor,
            ApplicationDbContext dbContext,
            AuditAction action,
            string entityName,
            Guid entityId,
            string? description = null)
        {
            var context = httpContextAccessor.HttpContext;

            if (context == null || context.User == null || !context.User.Identity?.IsAuthenticated == true)
                return;

            var staffId = CurrentUserHelper.GetStaffId(context.User);
            var ip = context.Connection?.RemoteIpAddress?.ToString() ?? "unknown";
            var ua = context.Request?.Headers["User-Agent"].ToString() ?? "unknown";

            var log = new AuditLog
            {
                StaffId = staffId,
                Action = action.ToString(),
                EntityName = entityName,
                EntityId = entityId,
                Description = description ?? "",
                IPAddress = ip,
                UserAgent = ua
            };

            dbContext.AuditLogs.Add(log);
            await dbContext.SaveChangesAsync();
        }
    }
}
