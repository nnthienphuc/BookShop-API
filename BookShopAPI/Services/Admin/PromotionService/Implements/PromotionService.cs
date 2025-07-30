using BookShopAPI.Common.Enum;
using BookShopAPI.Common.Helper;
using BookShopAPI.Data;
using BookShopAPI.Models;
using BookShopAPI.Services.Admin.PromotionService.DTOs;
using BookShopAPI.Services.Admin.PromotionService.Interfaces;
using Microsoft.AspNetCore.Http;

namespace BookShopAPI.Services.Admin.PromotionService.Implements
{
    public class PromotionService : IPromotionService
    {
        private readonly IPromotionRepository _promotionRepository;
        private readonly ApplicationDbContext _context;
        private readonly IHttpContextAccessor _httpContext;

        public PromotionService(IPromotionRepository promotionRepository, ApplicationDbContext context, IHttpContextAccessor httpContext)
        {
            _promotionRepository = promotionRepository;
            _context = context;
            _httpContext = httpContext;
        }

        public async Task<IEnumerable<PromotionResponseDTO>> GetAllAsync()
        {
            var promotions = await _promotionRepository.GetAllAsync();

            return promotions.Select(p => new PromotionResponseDTO
            {
                Id = p.Id,
                Name = p.Name,
                StartDate = p.StartDate,
                EndDate = p.EndDate,
                Condition = p.Condition,
                DiscountPercent = p.DiscountPercent,
                Quantity = p.Quantity,
                IsDeleted = p.IsDeleted
            });
        }

        public async Task<PromotionResponseDTO?> GetByIdAsync(Guid id)
        {
            var promotion = await _promotionRepository.GetByIdAsync(id);

            if (promotion == null)
                throw new KeyNotFoundException($"Không tìm thấy khuyến mãi với ID '{id}'.");

            return new PromotionResponseDTO
            {
                Id = promotion.Id,
                Name = promotion.Name,
                StartDate = promotion.StartDate,
                EndDate = promotion.EndDate,
                Condition = promotion.Condition,
                DiscountPercent = promotion.DiscountPercent,
                Quantity = promotion.Quantity,
                IsDeleted = promotion.IsDeleted
            };
        }

        public async Task<PromotionResponseDTO?> GetByNameAsync(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
                throw new ArgumentException("Tên khuyến mãi không được để trống.");

            var promotion = await _promotionRepository.GetByNameAsync(name);

            if (promotion == null)
                throw new KeyNotFoundException($"Không tìm thấy khuyến mãi với tên '{name}'.");

            return new PromotionResponseDTO
            {
                Id = promotion.Id,
                Name = promotion.Name,
                StartDate = promotion.StartDate,
                EndDate = promotion.EndDate,
                Condition = promotion.Condition,
                DiscountPercent = promotion.DiscountPercent,
                Quantity = promotion.Quantity,
                IsDeleted = promotion.IsDeleted
            };
        }

        public async Task<IEnumerable<PromotionResponseDTO>> SearchByKeywordAsync(string keyword)
        {
            var promotions = await _promotionRepository.SearchByKeywordAsync(keyword);

            return promotions.Select(p => new PromotionResponseDTO
            {
                Id = p.Id,
                Name = p.Name,
                StartDate = p.StartDate,
                EndDate = p.EndDate,
                Condition = p.Condition,
                DiscountPercent = p.DiscountPercent,
                Quantity = p.Quantity,
                IsDeleted = p.IsDeleted
            });
        }

        public async Task<bool> AddAsync(PromotionRequestDTO promotionCreateDTO)
        {
            var now = DateTime.Now;

            if (promotionCreateDTO.StartDate < now)
                throw new ArgumentException("Ngày bắt đầu phải sau thời điểm hiện tại.");

            if (promotionCreateDTO.EndDate <= now)
                throw new ArgumentException("Ngày kết thúc phải sau thời điểm hiện tại.");

            if (promotionCreateDTO.StartDate >= promotionCreateDTO.EndDate)
                throw new ArgumentException("Ngày bắt đầu phải trước ngày kết thúc.");

            if (promotionCreateDTO.Condition < 0)
                throw new ArgumentException("Điều kiện áp dụng phải là số không âm.");

            if (promotionCreateDTO.DiscountPercent <= 0 || promotionCreateDTO.DiscountPercent > 100)
                throw new ArgumentException("Phần trăm giảm giá phải nằm trong khoảng từ 1 đến 100.");

            if (promotionCreateDTO.Quantity <= 0)
                throw new ArgumentException("Số lượng khuyến mãi phải lớn hơn 0.");

            var promotion = new Promotion
            {
                Name = promotionCreateDTO.Name,
                StartDate = promotionCreateDTO.StartDate,
                EndDate = promotionCreateDTO.EndDate,
                Condition = promotionCreateDTO.Condition,
                DiscountPercent = promotionCreateDTO.DiscountPercent,
                Quantity = promotionCreateDTO.Quantity
            };

            await _promotionRepository.AddAsync(promotion);

            var result = await _promotionRepository.SaveChangesAsync();

            if (result)
            {
                await AuditHelper.LogAuditAsync(
                    _httpContext,
                    _context,
                    AuditAction.ADD,
                    "Promotion",
                    promotion.Id,
                    $"Created promotion '{promotion.Name}'"
                );
            }

            return result;
        }

        public async Task<bool> UpdateAsync(Guid id, PromotionRequestDTO promotionUpdateDTO)
        {
            var existingPromotion = await _promotionRepository.GetByIdAsync(id);
            if (existingPromotion == null)
                throw new KeyNotFoundException($"Không tìm thấy khuyến mãi với ID '{id}'.");

            var duplicatePromotion = await _promotionRepository.GetByNameAsync(promotionUpdateDTO.Name);
            if (duplicatePromotion != null && duplicatePromotion.Id != id)
                throw new InvalidOperationException("Đã tồn tại khuyến mãi khác với cùng tên.");

            var now = DateTime.Now;

            if (promotionUpdateDTO.StartDate < now)
                throw new ArgumentException("Ngày bắt đầu phải sau thời điểm hiện tại.");

            if (promotionUpdateDTO.EndDate <= now)
                throw new ArgumentException("Ngày kết thúc phải sau thời điểm hiện tại.");

            if (promotionUpdateDTO.StartDate >= promotionUpdateDTO.EndDate)
                throw new ArgumentException("Ngày bắt đầu phải trước ngày kết thúc.");

            if (promotionUpdateDTO.Condition < 0)
                throw new ArgumentException("Điều kiện áp dụng phải là số không âm.");

            if (promotionUpdateDTO.DiscountPercent <= 0 || promotionUpdateDTO.DiscountPercent > 100)
                throw new ArgumentException("Phần trăm giảm giá phải nằm trong khoảng từ 1 đến 100.");

            if (promotionUpdateDTO.Quantity <= 0)
                throw new ArgumentException("Số lượng khuyến mãi phải lớn hơn 0.");

            var logPromotion = new Promotion
            {
                Name = existingPromotion.Name,
                StartDate = existingPromotion.StartDate,
                EndDate = existingPromotion.EndDate,
                Condition = existingPromotion.Condition,
                DiscountPercent = existingPromotion.DiscountPercent,
                Quantity = existingPromotion.Quantity,
                IsDeleted = existingPromotion.IsDeleted
            };

            existingPromotion.Name = promotionUpdateDTO.Name;
            existingPromotion.StartDate = promotionUpdateDTO.StartDate;
            existingPromotion.EndDate = promotionUpdateDTO.EndDate;
            existingPromotion.Condition = promotionUpdateDTO.Condition;
            existingPromotion.DiscountPercent = promotionUpdateDTO.DiscountPercent;
            existingPromotion.Quantity = promotionUpdateDTO.Quantity;
            existingPromotion.IsDeleted = promotionUpdateDTO.IsDeleted;

            _promotionRepository.Update(existingPromotion);

            var result = await _promotionRepository.SaveChangesAsync();

            if (result)
            {
                await AuditHelper.LogAuditAsync(
                    _httpContext,
                    _context,
                    AuditAction.UPDATE,
                    "Promotion",
                    id,
                    $"Updated category '{logPromotion.Name}' to '{existingPromotion.Name}', '{logPromotion.StartDate}' to '{existingPromotion.StartDate}', '{logPromotion.EndDate}' to '{existingPromotion.EndDate}', '{logPromotion.Condition}' to '{existingPromotion.Condition}', '{logPromotion.DiscountPercent}' to '{existingPromotion.DiscountPercent}', '{logPromotion.Quantity}' to '{existingPromotion.Quantity}', IsDeleted '{logPromotion.IsDeleted}' to '{existingPromotion.IsDeleted}'"
                );
            }

            return result;
        }

        public async Task<bool> DeleteAsync(Guid id)
        {
            var existingPromotion = await _promotionRepository.GetByIdAsync(id);
            if (existingPromotion == null)
                throw new KeyNotFoundException($"Không tìm thấy khuyến mãi với ID '{id}'.");

            if (existingPromotion.IsDeleted == true)
                throw new InvalidOperationException($"Khuyến mãi với ID {id} đã bị xoá trước đó.");

            _promotionRepository.Delete(existingPromotion);

            var result = await _promotionRepository.SaveChangesAsync();

            if (result)
            {
                await AuditHelper.LogAuditAsync(
                    _httpContext,
                    _context,
                    AuditAction.DELETE,
                    "Promotion",
                    id,
                    $"Soft deleted category '{existingPromotion.Name}'"
                );
            }

            return result;
        }
    }
}
