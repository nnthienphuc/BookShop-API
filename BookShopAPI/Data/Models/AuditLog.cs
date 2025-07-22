using BookShopAPI.Models;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BookShopAPI.Data.Models
{
    public class AuditLog
    {
        [Key]
        public Guid Id { get; set; }

        [Required]
        public Guid StaffId { get; set; }

        [Required]
        [StringLength(50)]
        public string Action { get; set; } = null!;

        [Required]
        [StringLength(100)]
        public string EntityName { get; set; } = null!;

        [Required]
        public Guid EntityId { get; set; }

        [Required]
        public string Description { get; set; } = null!;

        [Required]
        public DateTime Timestamp { get; set; }

        [Required]
        [StringLength(45)]
        public string IPAddress { get; set; } = null!;

        [Required]
        [StringLength(200)]
        public string UserAgent { get; set; } = null!;

        [ForeignKey("StaffId")]
        public virtual Staff Staff { get; set; } = null!;
    }
}
