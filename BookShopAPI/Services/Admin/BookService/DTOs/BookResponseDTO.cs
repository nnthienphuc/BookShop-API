namespace BookShopAPI.Services.Admin.BookService.DTOs
{
    public class BookResponseDTO
    {
        public Guid Id { get; set; }
        public string Isbn { get; set; } = null!;
        public string Title { get; set; } = null!;
        public string CategoryName { get; set; } = null!;
        public string AuthorName { get; set; } = null!;
        public string PublisherName { get; set; } = null!;
        public short YearOfPublication { get; set; }
        public decimal Price { get; set; }
        public int Quantity { get; set; }
        public bool IsDeleted { get; set; }
        public string? Image { get; set; }
    }
}
