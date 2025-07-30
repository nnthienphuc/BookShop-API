namespace BookShopAPI.Services.Admin.BookService.DTOs
{
    public class BookRequestDTO
    {
        public string Isbn { get; set; } = null!;
        public string Title { get; set; } = null!;
        public Guid CategoryId { get; set; }
        public Guid AuthorId { get; set; }
        public Guid PublisherId { get; set; }
        public short YearOfPublication { get; set; }
        public decimal Price { get; set; }
        public int Quantity { get; set; }
        public bool IsDeleted { get; set; }
    }
}
