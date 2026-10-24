
using Bai01_BTN.Api.Data;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Đăng ký Controller cho Web API
builder.Services.AddControllers();

// Kết nối SQL Server thông qua AppDbContext
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection")
    )
);

var app = builder.Build();

// Khai báo các API Controller
app.MapControllers();

// Khởi chạy Web API
app.Run();
