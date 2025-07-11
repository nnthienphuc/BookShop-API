using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BookShopAPI.Models;

[Index("Email", Name = "IX_Customer_Email", IsUnique = true)]
[Index("Phone", Name = "IX_Customer_Phone", IsUnique = true)]
public partial class Customer
{
    [Key]
    public Guid Id { get; set; }

    [StringLength(70)]
    public string FamilyName { get; set; } = null!;

    [StringLength(30)]
    public string GivenName { get; set; } = null!;

    public DateOnly DateOfBirth { get; set; }

    [StringLength(50)]
    public string Address { get; set; } = null!;

    [StringLength(10)]
    [Unicode(false)]
    public string Phone { get; set; } = null!;

    public bool Gender { get; set; }

    [StringLength(50)]
    [Unicode(false)]
    public string? Email { get; set; }

    [StringLength(255)]
    [Unicode(false)]
    public string? HashPassword { get; set; }

    public bool IsActived { get; set; }

    public bool IsDeleted { get; set; }

    [InverseProperty("Customer")]
    public virtual ICollection<Order> Orders { get; set; } = new List<Order>();
}
