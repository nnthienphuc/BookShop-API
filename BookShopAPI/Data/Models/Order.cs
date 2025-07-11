using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BookShopAPI.Models;

public partial class Order
{
    [Key]
    public Guid Id { get; set; }

    public Guid? StaffId { get; set; }

    public Guid CustomerId { get; set; }

    public Guid? PromotionId { get; set; }

    public DateTime CreatedTime { get; set; }

    [Column(TypeName = "decimal(11, 3)")]
    public decimal ShippingFee { get; set; }

    [StringLength(50)]
    public string PaymentMethod { get; set; } = null!;

    [Column(TypeName = "decimal(11, 3)")]
    public decimal TotalAmount { get; set; }

    [StringLength(50)]
    public string Status { get; set; } = null!;

    public string? Note { get; set; }

    public bool IsDeleted { get; set; }

    [ForeignKey("CustomerId")]
    [InverseProperty("Orders")]
    public virtual Customer Customer { get; set; } = null!;

    [InverseProperty("Order")]
    public virtual ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();

    [ForeignKey("PromotionId")]
    [InverseProperty("Orders")]
    public virtual Promotion? Promotion { get; set; }

    [ForeignKey("StaffId")]
    [InverseProperty("Orders")]
    public virtual Staff? Staff { get; set; }
}
