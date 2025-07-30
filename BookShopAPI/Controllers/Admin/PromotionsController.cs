using BookShopAPI.Common.Controller;
using BookShopAPI.Services.Admin.PromotionService.DTOs;
using BookShopAPI.Services.Admin.PromotionService.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace BookShopAPI.Controllers.Admin
{
    public class PromotionsController : BaseController
    {
        private readonly IPromotionService _promotionService;

        public PromotionsController(IPromotionService promotionService)
        {
            _promotionService = promotionService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var result = await _promotionService.GetAllAsync();

            return Ok(result);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(Guid id)
        {
            var result = await _promotionService.GetByIdAsync(id);

            return Ok(result);
        }

        [HttpGet("search")]
        public async Task<IActionResult> SearchByKeyword([FromQuery] string? keyword)
        {
            var result = await _promotionService.SearchByKeywordAsync(keyword);

            return Ok(result);
        }

        [HttpPost]
        public async Task<IActionResult> Add([FromBody] PromotionRequestDTO promotionCreateDTO)
        {
            await _promotionService.AddAsync(promotionCreateDTO);

            return Ok(new { message = "Đã thêm khuyến mãi thành công." });
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(Guid id, [FromBody] PromotionRequestDTO promotionUpdateDTO)
        {
            await _promotionService.UpdateAsync(id, promotionUpdateDTO);

            return Ok(new { message = "Đã cập nhật khuyến mãi thành công." });
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(Guid id)
        {
            await _promotionService.DeleteAsync(id);

            return Ok(new { message = "Đã xóa khuyến mãi thành công." });
        }
    }
}
