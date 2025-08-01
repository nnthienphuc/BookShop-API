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
            await _service.AddAsync(dto, imageFile);
            return Ok(new { message = "Thêm sách thành công!" });
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(Guid id, [FromForm] BookRequestDTO dto, IFormFile? imageFile)
        {
            await _service.UpdateAsync(id, dto, imageFile);
            return Ok(new { message = "Cập nhật thành công!" });
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(Guid id)
        {
            await _service.DeleteAsync(id);
            return Ok(new { message = "Xoá thành công!" });
        }
    }
}
