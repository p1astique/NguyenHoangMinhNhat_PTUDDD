
using Bai01_BTN.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace Bai01_BTN.Api.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    public DbSet<DienThoai> DienThoai => Set<DienThoai>();
}
