﻿namespace BookShopAPI.Services.Admin.CustomerService.DTOs
{
    public class CustomerResponseDTO
    {
        public Guid Id { get; set; }
        public string FamilyName { get; set; }
        public string GivenName { get; set; }
        public DateOnly DateOfBirth { get; set; }
        public string Address { get; set; }
        public string Phone { get; set; }
        public bool Gender { get; set; }
        public string Email { get; set; }
        public bool IsDeleted { get; set; }
    }
}
