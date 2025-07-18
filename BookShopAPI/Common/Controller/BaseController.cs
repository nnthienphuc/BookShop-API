using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BookShopAPI.Common.Controller
{
    [ApiController]
    [Route("api/admin/[controller]")]
    [Authorize]
    public abstract class BaseController : ControllerBase
    {
    }
}
