using BookShopAPI.Common.Controller;
using BookShopAPI.Services.Admin.AuthorService.DTOs;
using BookShopAPI.Services.Admin.AuthorService.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace BookShopAPI.Controllers.Admin
{
    public class AuthorsController : BaseController
    {
        private readonly IAuthorService _service;

        public AuthorsController(IAuthorService service)
        {
            _service = service ?? throw new ArgumentNullException(nameof(service));
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var result = await _service.GetAllAsync();

            return Ok(result);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(Guid id)
        {
            var result = await _service.GetByIdAsync(id);

            return Ok(result);
        }

        [HttpGet("search")]
        public async Task<IActionResult> SearchByKeyword([FromQuery]string? keyword)
        {
            var result = await _service.SearchByKeywordAsync(keyword);

            return Ok(result);
        }

        [HttpPost]
        public async Task<IActionResult> Add(AuthorRequestDTO dto)
        {
            await _service.AddAsync(dto);

            return Ok(new { message = "Add author successfully." });
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(Guid id, AuthorRequestDTO dto)
        {
            await _service.UpdateAsync(id, dto);

            return Ok(new { message = "Update author successfully." });
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(Guid id)
        {
            await _service.DeleteAsync(id);

            return Ok(new { message = "Soft delete author successfully." });
        }
    }
}
