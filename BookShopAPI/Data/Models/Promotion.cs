using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BookShopAPI.Models;

[Index("Name", Name = "IX_Promotion", IsUnique = true)]
public partial class Promotion
{
    [Key]
    public Guid Id { get; set; }

    [StringLength(100)]
    public string Name { get; set; } = null!;

    public DateTime StartDate { get; set; }

    public DateTime EndDate { get; set; }

    [Column(TypeName = "decimal(8, 0)")]
    public decimal Condition { get; set; }

    [Column(TypeName = "decimal(3, 2)")]
    public decimal DiscountPercent { get; set; }

    public short Quantity { get; set; }

    public bool IsDeleted { get; set; }

    [InverseProperty("Promotion")]
    public virtual ICollection<Order> Orders { get; set; } = new List<Order>();
}
