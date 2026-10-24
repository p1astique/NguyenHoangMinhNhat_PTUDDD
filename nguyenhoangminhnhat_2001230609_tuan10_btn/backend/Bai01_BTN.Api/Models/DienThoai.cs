
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Bai01_BTN.Api.Models;

[Table("DienThoai")]
public class DienThoai
{
    [Key]
    [MaxLength(20)]
    public string MaSP { get; set; } = string.Empty;

    [Required]
    [MaxLength(150)]
    public string TenSP { get; set; } = string.Empty;

    [Required]
    [MaxLength(100)]
    public string HangSanXuat { get; set; } = string.Empty;

    [Column(TypeName = "decimal(18,0)")]
    public decimal Gia { get; set; }

    public string? MoTa { get; set; }

    [MaxLength(500)]
    public string? HinhAnh { get; set; }
}
