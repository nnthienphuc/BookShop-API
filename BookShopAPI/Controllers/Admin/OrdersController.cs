using BookShopAPI.Common.Controller;
using BookShopAPI.Services.Admin.OrderService.DTOs;
using BookShopAPI.Services.Admin.OrderService.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BookShopAPI.Controllers.Admin
{
    public class OrdersController : BaseController
    {
        private readonly IOrderService _orderService;

        public OrdersController(IOrderService orderService)
        {
            _orderService = orderService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var result = await _orderService.GetAllAsync(User);

            return Ok(result);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(Guid id)
        {
            var result = await _orderService.GetByIdAsync(id, User);

            return Ok(result);
        }

        [HttpGet("items/{orderId}")]
        public async Task<IActionResult> GetItemsByOrderId(Guid orderId)
        {
            var result = await _orderService.GetItemsByOrderIdAsync(orderId, User);

            return Ok(result);
        }

        [HttpGet("search")]
        public async Task<IActionResult> SearchByKeyword([FromQuery] string? keyword)
        {
            var result = await _orderService.SearchByKeywordAsync(keyword, User);

            return Ok(result);
        }

        [HttpPost]
        public async Task<IActionResult> Add([FromBody] OrderCreateDTO orderCreateDTO)
        {
            var result = await _orderService.AddAsync(orderCreateDTO, User);

            return Ok(new { message = "Đã bán hàng thành công." });
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(Guid id, [FromBody] OrderUpdateDTO orderUpdateDTO)
        {
            var result = await _orderService.UpdateAsync(id, orderUpdateDTO);

            return Ok(new { message = "Đã cập nhật hóa đơn thành công" });
        }

        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(Guid id)
        {
            var result = await _orderService.DeleteAsync(id);

            return Ok(new { message = "Đã xóa hóa đơn thành công" });
        }

        [Authorize(Roles = "Admin")]
        [HttpDelete("items/{orderId}/{bookId}")]
        public async Task<IActionResult> DeleteItem(Guid orderId, Guid bookId)
        {
            var result = await _orderService.DeleteItem(orderId, bookId);
            return Ok(new { message = "Đã xóa chi tiết hóa đơn thành công." });
        }
    }
}
