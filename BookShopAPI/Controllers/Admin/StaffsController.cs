using BookShopAPI.Common.Controller;
using BookShopAPI.Services.Admin.StaffService.DTOs;
using BookShopAPI.Services.Admin.StaffService.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BookShopAPI.Controllers.Admin
{
    [Authorize(Roles = "Admin")]
    public class StaffsController : BaseController
    {
        private readonly IStaffService _staffService;

        public StaffsController(IStaffService staffService)
        {
            _staffService = staffService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var result = await _staffService.GetAllAsync();

            return Ok(result);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(Guid id)
        {
            var result = await _staffService.GetByIdAsync(id);

            return Ok(result);
        }

        [HttpGet("search")]
        public async Task<IActionResult> SearchByKeyword([FromQuery] string? keyword)
        {
            var result = await _staffService.SearchByKeywordAsync(keyword);

            return Ok(result);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(Guid id, [FromBody] StaffRequestDTO staffUpdateDTO)
        {
            var result = await _staffService.UpdateAsync(id, staffUpdateDTO);

            return Ok(new { message = "Đã cập nhật nhân viên thành công." });
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(Guid id)
        {
            var result = await _staffService.DeleteAsync(id);

            return Ok(new { message = "Đã xóa nhân viên thành công." });
        }
    }
}
