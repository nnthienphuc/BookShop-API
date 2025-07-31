using BookShopAPI.Data;
using BookShopAPI.Middlewares;
using BookShopAPI.Services.Admin.AuthorService.Implements;
using BookShopAPI.Services.Admin.AuthorService.Interfaces;
using BookShopAPI.Services.Admin.AuthService.Implements;
using BookShopAPI.Services.Admin.AuthService.Interfaces;
using BookShopAPI.Services.Admin.BookService.Implements;
using BookShopAPI.Services.Admin.BookService.Interfaces;
using BookShopAPI.Services.Admin.CategoryService.Implements;
using BookShopAPI.Services.Admin.CategoryService.Interfaces;
using BookShopAPI.Services.Admin.CustomerService.Implements;
using BookShopAPI.Services.Admin.CustomerService.Interfaces;
using BookShopAPI.Services.Admin.PromotionService.Implements;
using BookShopAPI.Services.Admin.PromotionService.Interfaces;
using BookShopAPI.Services.Admin.PublisherService.Implements;
using BookShopAPI.Services.Admin.PublisherService.Interfaces;
using BookShopAPI.Services.EmailService;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.Text;

var builder = WebApplication.CreateBuilder(new WebApplicationOptions
{
    Args = args,
    EnvironmentName = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") ?? "Production"
});

// Đọc biến môi trường
builder.Configuration.AddEnvironmentVariables();
var jwtKey = Environment.GetEnvironmentVariable("JWT_SECRET_KEY") ?? builder.Configuration["Jwt:Key"];
var smtpUser = Environment.GetEnvironmentVariable("SMTP_USERNAME") ?? builder.Configuration["EmailSettings:SmtpUsername"];
var smtpPass = Environment.GetEnvironmentVariable("SMTP_PASSWORD") ?? builder.Configuration["EmailSettings:SmtpPassword"];

//Console.WriteLine($"[DEBUG] JWT Key: {jwtKey}");
//Console.WriteLine($"[DEBUG] JWT Key Length: {jwtKey.Length}");

// Kết nối DB
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFrontend", policy =>
        policy
            .WithOrigins("http://localhost:5173") // dùng đúng port frontend
            .AllowAnyHeader()
            .AllowAnyMethod()
            .AllowCredentials());
});

// JWT Authentication
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = builder.Configuration["Jwt:Issuer"],
            ValidAudience = builder.Configuration["Jwt:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey))
        };
    });

// Swagger (Dev only)
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "BookShop API", Version = "v1" });

    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Description = @"JWT Authorization header using the Bearer scheme. Example: Bearer {token}",
        Name = "Authorization",
        In = ParameterLocation.Header,
        Type = SecuritySchemeType.Http,
        Scheme = "bearer",
        BearerFormat = "JWT"
    });

    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference { Type = ReferenceType.SecurityScheme, Id = "Bearer" },
                In = ParameterLocation.Header
            },
            new List<string>()
        }
    });
});

// Services & DI
//builder.Services.AddScoped<ExceptionMiddleware>();
builder.Services.AddScoped<EmailSenderService>();
builder.Services.AddHttpContextAccessor(); // để inject được IHttpContextAccessor
builder.Services.AddScoped<IAuthService, AuthService>();
builder.Services.AddScoped<IAuthRepository, AuthRepository>();
builder.Services.AddScoped<ICategoryService, CategoryService>();
builder.Services.AddScoped<ICategoryRepository, CategoryRepository>();
builder.Services.AddScoped<IAuthorService, AuthorService>();
builder.Services.AddScoped<IAuthorRepository, AuthorRepository>();
builder.Services.AddScoped<IPublisherService, PublisherService>();
builder.Services.AddScoped<IPublisherRepository, PublisherRepository>();
builder.Services.AddScoped<IBookService, BookService>();
builder.Services.AddScoped<IBookRepository, BookRepository>();
builder.Services.AddScoped<IPromotionRepository, PromotionRepository>();
builder.Services.AddScoped<IPromotionService, PromotionService>();
builder.Services.AddScoped<ICustomerRepository, CustomerRepository>();
builder.Services.AddScoped<ICustomerService, CustomerService>();

// Helpers
builder.Services.AddHttpContextAccessor();

// Controllers
builder.Services.AddControllersWithViews();

var app = builder.Build();

// Dev: Swagger UI
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "BookShop API V1");
        c.RoutePrefix = "swagger";
    });
}
else
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

//app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseMiddleware<ExceptionMiddleware>();

app.UseRouting();

app.UseCors("AllowFrontend");

app.UseAuthentication();
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();