using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BookShopAPI.Models;

[PrimaryKey("OrderId", "BookId")]
public partial class OrderItem
{
    [Key]
    public Guid OrderId { get; set; }

    [Key]
    public Guid BookId { get; set; }

    public short Quantity { get; set; }

    [Column(TypeName = "decimal(8, 0)")]
    public decimal Price { get; set; }

    public bool IsDeleted { get; set; }

    [ForeignKey("BookId")]
    [InverseProperty("OrderItems")]
    public virtual Book Book { get; set; } = null!;

    [ForeignKey("OrderId")]
    [InverseProperty("OrderItems")]
    public virtual Order Order { get; set; } = null!;
}
