using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BookShopAPI.Models;

[Index("Isbn", Name = "IX_Book", IsUnique = true)]
public partial class Book
{
    [Key]
    public Guid Id { get; set; }

    [StringLength(13)]
    [Unicode(false)]
    public string Isbn { get; set; } = null!;

    [StringLength(100)]
    public string Title { get; set; } = null!;

    public Guid CategoryId { get; set; }

    public Guid AuthorId { get; set; }

    public Guid PublisherId { get; set; }

    public short YearOfPublication { get; set; }

    [Column(TypeName = "decimal(8, 0)")]
    public decimal Price { get; set; }

    [Unicode(false)]
    public string? Image { get; set; }

    public int Quantity { get; set; }

    public bool IsDeleted { get; set; }

    [ForeignKey("AuthorId")]
    [InverseProperty("Books")]
    public virtual Author Author { get; set; } = null!;

    [ForeignKey("CategoryId")]
    [InverseProperty("Books")]
    public virtual Category Category { get; set; } = null!;

    [InverseProperty("Book")]
    public virtual ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();

    [ForeignKey("PublisherId")]
    [InverseProperty("Books")]
    public virtual Publisher Publisher { get; set; } = null!;
}
