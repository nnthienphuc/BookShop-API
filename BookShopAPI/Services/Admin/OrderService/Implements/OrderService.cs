using BookShopAPI.Common.Enum;
using BookShopAPI.Common.Helper;
using BookShopAPI.Data;
using BookShopAPI.Models;
using BookShopAPI.Services.Admin.OrderService.DTOs;
using BookShopAPI.Services.Admin.OrderService.Interfaces;
using System.Security.Claims;

namespace BookShopAPI.Services.Admin.OrderService.Implements
{
    public class OrderService : IOrderService
    {
        private readonly IOrderRepository _orderRepository;
        private readonly ApplicationDbContext _context;
        private readonly IHttpContextAccessor _httpContext;

        public OrderService(IOrderRepository orderRepository, ApplicationDbContext context, IHttpContextAccessor httpContext)
        {
            _orderRepository = orderRepository;
            _context = context;
            _httpContext = httpContext;
        }

        public async Task<IEnumerable<OrderDTO>> GetAllAsync(ClaimsPrincipal user)
        {
            var staffId = CurrentUserHelper.GetStaffId(user);
            var isAdmin = CurrentUserHelper.IsAdmin(user);

            var orders = await _orderRepository.GetAllAsync();

            if (!isAdmin)
                orders = orders.Where(o => o.StaffId == staffId).ToList();

            return orders.Select(o => new OrderDTO
            {
                Id = o.Id,
                StaffName = o.Staff.FamilyName + " " + o.Staff.GivenName,
                CustomerName = o.Customer.FamilyName + " " + o.Customer.GivenName,
                CustomerPhone = o.Customer.Phone,
                PromotionName = o.Promotion?.Name,
                StaffId = o.Staff.Id,
                CustomerId = o.Customer.Id,
                PromotionId = o.Promotion?.Id,
                CreatedTime = o.CreatedTime,
                PaymentMethod = o.PaymentMethod,
                ShippingFee = o.ShippingFee,
                TotalAmount = o.TotalAmount,
                Status = o.Status,
                Note = o.Note,
                IsDeleted = o.IsDeleted
            });
        }

        public async Task<OrderDTO?> GetByIdAsync(Guid id, ClaimsPrincipal user)
        {
            var order = await _orderRepository.GetByIdAsync(id);

            if (order == null)
                throw new KeyNotFoundException($"Không tìm thấy đơn hàng với ID '{id}'.");

            var staffId = CurrentUserHelper.GetStaffId(user);
            var isAdmin = CurrentUserHelper.IsAdmin(user);

            if (!isAdmin && order.StaffId != staffId)
                throw new UnauthorizedAccessException("Bạn chỉ có thể xem đơn hàng của chính mình.");

            return new OrderDTO
            {
                Id = order.Id,
                StaffName = order.Staff.FamilyName + ' ' + order.Staff.GivenName,
                CustomerName = order.Customer.FamilyName + ' ' + order.Customer.GivenName,
                CustomerPhone = order.Customer.Phone,
                PromotionName = order.Promotion?.Name,
                CreatedTime = order.CreatedTime,
                PaymentMethod = order.PaymentMethod,
                ShippingFee = order.ShippingFee,
                TotalAmount = order.TotalAmount,
                Status = order.Status,
                Note = order.Note,
                IsDeleted = order.IsDeleted
            };
        }

        public async Task<IEnumerable<OrderItemDTO>> GetItemsByOrderIdAsync(Guid orderId, ClaimsPrincipal user)
        {
            var order = await _orderRepository.GetByIdAsync(orderId);

            var orderItems = await _orderRepository.GetItemsByOrderIdAsync(orderId);

            var staffId = CurrentUserHelper.GetStaffId(user);
            var isAdmin = CurrentUserHelper.IsAdmin(user);

            if (!isAdmin && order.StaffId != staffId)
                throw new UnauthorizedAccessException("Bạn chỉ có thể xem đơn hàng của chính mình.");

            return orderItems.Select(oi => new OrderItemDTO
            {
                OrderId = orderId,
                BookId = oi.Book.Id,
                BookName = oi.Book.Title,
                Price = oi.Price,
                Quantity = oi.Quantity,
                IsDeleted = oi.IsDeleted
            });
        }

        public async Task<IEnumerable<OrderDTO>> SearchByKeywordAsync(string keyword, ClaimsPrincipal user)
        {
            var staffId = CurrentUserHelper.GetStaffId(user);
            var isAdmin = CurrentUserHelper.IsAdmin(user);

            var orders = await _orderRepository.SearchByKeywordAsync(keyword);

            if (!isAdmin)
                orders = orders.Where(o => o.StaffId == staffId).ToList();

            return orders.Select(o => new OrderDTO
            {
                Id = o.Id,
                StaffName = o.Staff.FamilyName + " " + o.Staff.GivenName,
                CustomerName = o.Customer.FamilyName + " " + o.Customer.GivenName,
                CustomerPhone = o.Customer.Phone,
                PromotionName = o.Promotion?.Name,
                StaffId = o.Staff.Id,
                CustomerId = o.Customer.Id,
                PromotionId = o.Promotion?.Id,
                CreatedTime = o.CreatedTime,
                PaymentMethod = o.PaymentMethod,
                ShippingFee = o.ShippingFee,
                TotalAmount = o.TotalAmount,
                Status = o.Status,
                Note = o.Note,
                IsDeleted = o.IsDeleted
            });
        }

        public async Task<bool> AddAsync(OrderCreateDTO orderCreateDTO, ClaimsPrincipal user)
        {
            if (orderCreateDTO.Items == null || !orderCreateDTO.Items.Any())
                throw new ArgumentException("Đơn hàng phải có ít nhất một sản phẩm.");

            var customer = await _orderRepository.GetCustomerByIdAsync(orderCreateDTO.CustomerId);
            if (customer == null || customer.IsDeleted)
                throw new ArgumentException("Khách hàng không hợp lệ hoặc đã bị xoá.");

            var order = new Order
            {
                Id = Guid.NewGuid(),
                StaffId = CurrentUserHelper.GetStaffId(user),
                CustomerId = orderCreateDTO.CustomerId,
                PromotionId = orderCreateDTO.PromotionId,
                CreatedTime = DateTime.Now,
                Status = "Thành công"
            };

            decimal subTotal = 0;

            foreach (var item in orderCreateDTO.Items)
            {
                var book = await _orderRepository.GetBookByIdAsync(item.BookId)
                    ?? throw new KeyNotFoundException($"Không tìm thấy sách với ID '{item.BookId}'.");

                if (book.Quantity < item.Quantity)
                    throw new InvalidOperationException($"Số lượng sách '{book.Title}' không đủ để bán.");

                if (book.IsDeleted)
                    throw new InvalidOperationException($"Sách '{book.Title}' đã bị xoá.");

                var orderItem = new OrderItem
                {
                    OrderId = order.Id,
                    BookId = item.BookId,
                    Quantity = item.Quantity,
                    Price = book.Price
                };

                book.Quantity -= item.Quantity;

                subTotal += (orderItem.Price * orderItem.Quantity);
                order.OrderItems.Add(orderItem);
            }

            decimal promotionAmount = 0;

            if (order.PromotionId.HasValue)
            {
                var promotion = await _orderRepository.GetPromotionByIdAsync(order.PromotionId.Value)
                    ?? throw new ArgumentException("Không tìm thấy khuyến mãi.");

                if (promotion.IsDeleted)
                    throw new InvalidOperationException($"Khuyến mãi '{promotion.Name}' đã bị xoá.");

                if (DateTime.Now < promotion.StartDate)
                    throw new InvalidOperationException("Khuyến mãi chưa bắt đầu.");

                if (DateTime.Now > promotion.EndDate)
                    throw new InvalidOperationException("Khuyến mãi đã hết hạn.");

                if (promotion.Quantity <= 0)
                    throw new InvalidOperationException("Khuyến mãi đã hết lượt sử dụng.");

                if (subTotal < promotion.Condition)
                    throw new InvalidOperationException("Đơn hàng không đủ điều kiện áp dụng khuyến mãi.");

                promotionAmount = subTotal * promotion.DiscountPercent;
                promotion.Quantity--;
            }

            order.TotalAmount = subTotal - promotionAmount;

            await _orderRepository.AddAsync(order);

            var result = await _orderRepository.SaveChangesAsync();

            if (result)
            {
                await AuditHelper.LogAuditAsync(
                    _httpContext,
                    _context,
                    AuditAction.ADD,
                    "Order",
                    order.Id,
                    $"Created order by '{order.StaffId}'"
                );
            }

            return result;
        }

        public async Task<bool> UpdateAsync(Guid id, OrderUpdateDTO orderUpdateDTO)
        {
            var order = await _orderRepository.GetByIdAsync(id);

            if (order == null)
                throw new KeyNotFoundException($"Không tìm thấy đơn hàng với ID '{id}'.");

            var logOrder = new OrderUpdateDTO
            {
                Status = order.Status,
                Note = order.Note,
                IsDeleted = order.IsDeleted,
            };

            order.Status = orderUpdateDTO.Status;
            order.Note = orderUpdateDTO.Note;
            order.IsDeleted = orderUpdateDTO.IsDeleted;

            _orderRepository.Update(order);

            var result = await _orderRepository.SaveChangesAsync();

            if (result)
            {
                await AuditHelper.LogAuditAsync(
                    _httpContext,
                    _context,
                    AuditAction.UPDATE,
                    "Order",
                    id,
                    $"Updated order '{logOrder.Status}' to '{logOrder.Status}', '{logOrder.Note}' to '{logOrder.Note}', '{logOrder.IsDeleted}' to '{logOrder.IsDeleted}'"
                );
            }

            return result;
        }

        public async Task<bool> DeleteAsync(Guid id)
        {
            var order = await _orderRepository.GetByIdAsync(id);

            if (order == null)
                throw new KeyNotFoundException($"Không tìm thấy đơn hàng với ID '{id}'.");

            _orderRepository.Delete(order);

            var result = await _orderRepository.SaveChangesAsync();

            if (result)
            {
                await AuditHelper.LogAuditAsync(
                    _httpContext,
                    _context,
                    AuditAction.DELETE,
                    "Order",
                    order.Id,
                    $"Soft deleted order by '{order.StaffId}'"
                );
            }

            return result;
        }

        public async Task<bool> DeleteItem(Guid orderId, Guid bookId)
        {
            var item = await _orderRepository.GetOrderItemByOrderIdAndBookIdAsync(orderId, bookId);

            if (item == null)
                throw new KeyNotFoundException("Không tìm thấy sản phẩm trong đơn hàng.");

            _orderRepository.DeleteItem(item);

            return await _orderRepository.SaveChangesAsync();
        }
    }
}
