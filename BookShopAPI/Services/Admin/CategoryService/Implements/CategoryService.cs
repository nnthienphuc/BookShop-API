using BookShopAPI.Models;
using BookShopAPI.Services.Admin.CategoryService.DTOs;
using BookShopAPI.Services.Admin.CategoryService.Interfaces;
using System.Runtime.CompilerServices;

namespace BookShopAPI.Services.Admin.CategoryService.Implements
{
    public class CategoryService : ICategoryService
    {
        private readonly ICategoryRepository _repo;

        public CategoryService (ICategoryRepository repo)
        {
            _repo = repo ?? throw new ArgumentNullException(nameof(repo));
        }

        public async Task<IEnumerable<CategoryResponseDTO>> GetAllAsync()
        {
            var categories = await _repo.GetAllAsync();

            return categories.Select(x => new CategoryResponseDTO
            {
                Id = x.Id,
                Name = x.Name,
                IsDeleted = x.IsDeleted
            });
        }

        public async Task<CategoryResponseDTO?> GetByIdAsync(Guid id)
        {
            var category = await _repo.GetByIdAsync(id);

            if (category == null)
                throw new KeyNotFoundException($"Category with id '{id}' is not found.");

            return new CategoryResponseDTO
            {
                Id = category.Id,
                Name = category.Name,
                IsDeleted = category.IsDeleted
            };
        }

        public async Task<CategoryResponseDTO?> GetByNameAsync(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
                throw new ArgumentException("Name cannot be null or whitespace.");

            var category = await _repo.GetByNameAsync(name);

            if (category == null)
                throw new KeyNotFoundException($"Category with name '{name}' is not found.");

            return new CategoryResponseDTO
            {
                Id = category.Id,
                Name = category.Name,
                IsDeleted = category.IsDeleted
            };
        }

        public async Task<IEnumerable<CategoryResponseDTO>> SearchByKeywordAsync(string keyword)
        {
            if (string.IsNullOrWhiteSpace(keyword))
                throw new ArgumentException("Keyword cannot be null or whitespace.");

            var categories = await _repo.SearchByKeywordAsync(keyword);

            return categories.Select(x => new CategoryResponseDTO
            {
                Id = x.Id,
                Name = x.Name,
                IsDeleted = x.IsDeleted
            });
        }

        public async Task<bool> AddAsync(CategoryRequestDTO dto)
        {
            string name = dto.Name;
            if (string.IsNullOrWhiteSpace(name))
                throw new ArgumentException("Name cannot be null or whitespace");

            var existingName = await _repo.GetByNameAsync(name);
            if (existingName != null)
                throw new InvalidOperationException($"Category with name '{name}' is existing.");

            var category = new Category
            {
                Name = dto.Name
            };

            await _repo.AddAsync(category);

            return await _repo.SaveChangesAsync();
        }

        public async Task<bool> UpdateAsync(Guid id, CategoryRequestDTO dto)
        {
            string name = dto.Name;
            if (string.IsNullOrWhiteSpace(name))
                throw new ArgumentException("Name cannot be null or whitespace.");

            var existingCategory = await _repo.GetByIdAsync(id);
            if (existingCategory == null)
                throw new KeyNotFoundException($"Category with id '{id}' is not found.");

            var existingName = await _repo.GetByNameAsync(name);
            if (existingName.Id != id)
        }
    }
}
