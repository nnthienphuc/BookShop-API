﻿using BookShopAPI.Common.Controller;
using BookShopAPI.Services.Admin.PublisherService.DTOs;
using BookShopAPI.Services.Admin.PublisherService.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace BookShopAPI.Controllers.Admin
{
    public class PublishersController : BaseController
    {
        private readonly IPublisherService _service;

        public PublishersController(IPublisherService service)
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
        public async Task<IActionResult> Add([FromBody] PublisherRequestDTO dto)
        {
            await _service.AddAsync(dto);

            return Ok(new { message = "Thêm nhà xuất bản thành công." });
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(Guid id, [FromBody] PublisherRequestDTO dto)
        {
            await _service.UpdateAsync(id, dto);

            return Ok(new { message = "Cập nhật nhà xuất bản thành công." });
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(Guid id)
        {
            await _service.DeleteAsync(id);

            return Ok(new { message = "Xóa nhà xuất bản thành công." });
        }
    }
}
