using BookShopAPI.Common.Controller;
using BookShopAPI.Services.Admin.BookService.DTOs;
using BookShopAPI.Services.Admin.BookService.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace BookShopAPI.Controllers.Admin
{
    public class BooksController : BaseController
    {
        private readonly IBookService _service;

        public BooksController(IBookService service)
        {
            _service = service;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll() => Ok(await _service.GetAllAsync());

        [HttpGet("search")]
        public async Task<IActionResult> Search([FromQuery] string? keyword) =>
            Ok(await _service.SearchByKeywordAsync(keyword));

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(Guid id)
        {
            var book = await _service.GetByIdAsync(id);
            return book == null ? NotFound() : Ok(book);
        }

        [HttpPost]
        public async Task<IActionResult> Add([FromForm] BookRequestDTO dto, IFormFile? imageFile)
        {
            var result = await _service.AddAsync(dto, imageFile);
            return result ? Ok(new { message = "Thêm sách thành công!" }) : BadRequest("Thêm thất bại!");
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(Guid id, [FromForm] BookRequestDTO dto, IFormFile? imageFile)
        {
            var result = await _service.UpdateAsync(id, dto, imageFile);
            return result ? Ok(new { message = "Cập nhật thành công!" }) : BadRequest("Cập nhật thất bại!");
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(Guid id)
        {
            var result = await _service.DeleteAsync(id);
            return result ? Ok(new { message = "Xoá thành công!" }) : BadRequest("Xoá thất bại!");
        }
    }
}
