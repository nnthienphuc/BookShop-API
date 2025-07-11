using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BookShopAPI.Models;

[Index("CitizenIdentification", Name = "IX_Staff_CI", IsUnique = true)]
[Index("Email", Name = "IX_Staff_Email", IsUnique = true)]
[Index("Phone", Name = "IX_Staff_Phone", IsUnique = true)]
public partial class Staff
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

    [StringLength(50)]
    [Unicode(false)]
    public string Email { get; set; } = null!;

    [StringLength(12)]
    [Unicode(false)]
    public string CitizenIdentification { get; set; } = null!;

    [StringLength(255)]
    [Unicode(false)]
    public string HashPassword { get; set; } = null!;

    public bool Role { get; set; }

    public bool Gender { get; set; }

    public bool IsActived { get; set; }

    public bool IsDeleted { get; set; }

    [InverseProperty("Staff")]
    public virtual ICollection<Order> Orders { get; set; } = new List<Order>();
}
