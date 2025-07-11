using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BookShopAPI.Models;

[Index("Name", Name = "IX_Category", IsUnique = true)]
public partial class Category
{
    [Key]
    public Guid Id { get; set; }

    [StringLength(100)]
    public string Name { get; set; } = null!;

    public bool IsDeleted { get; set; }

    [InverseProperty("Category")]
    public virtual ICollection<Book> Books { get; set; } = new List<Book>();
}
