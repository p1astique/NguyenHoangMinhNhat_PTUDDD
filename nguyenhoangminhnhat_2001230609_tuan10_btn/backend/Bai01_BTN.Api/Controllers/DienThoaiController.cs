
using Bai01_BTN.Api.Data;
using Bai01_BTN.Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Bai01_BTN.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class DienThoaiController : ControllerBase
{
    private readonly AppDbContext _context;

    public DienThoaiController(AppDbContext context)
    {
        _context = context;
    }

    // API lấy danh sách tất cả điện thoại
    // GET: /api/DienThoai
    [HttpGet]
    public async Task<ActionResult<List<DienThoai>>> GetAll()
    {
        var danhSach = await _context.DienThoai
            .AsNoTracking()
            .OrderBy(dt => dt.MaSP)
            .ToListAsync();

        return Ok(danhSach);
    }

    // API lấy thông tin chi tiết một điện thoại
    // GET: /api/DienThoai/DT001
    [HttpGet("{id}")]
    public async Task<ActionResult<DienThoai>> GetById(string id)
    {
        var dienThoai = await _context.DienThoai
            .AsNoTracking()
            .FirstOrDefaultAsync(dt => dt.MaSP == id);

        if (dienThoai == null)
        {
            return NotFound(new
            {
                message = "Không tìm thấy điện thoại"
            });
        }

        return Ok(dienThoai);
    }
}
