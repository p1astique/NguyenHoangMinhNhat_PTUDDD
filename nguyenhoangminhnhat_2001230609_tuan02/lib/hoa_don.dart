abstract class HoaDon {
  String maKH;
  String tenKH;
  int soLuong;
  double giaBan;

  HoaDon(this.maKH, this.tenKH, this.soLuong, this.giaBan) {
    if (!RegExp(r'^KH\d{4}$').hasMatch(maKH)) throw ArgumentError('Mã khách hàng phải có dạng KH0002');
    if (tenKH.trim().isEmpty) throw ArgumentError('Tên khách hàng không được để trống');
    if (soLuong <= 0) throw ArgumentError('Số lượng phải lớn hơn 0');
    if (giaBan <= 0) throw ArgumentError('Giá bán phải lớn hơn 0');
  }

  double chietKhau();
  double troGia();

  double get tienHang => soLuong * giaBan;
  double get vat => tienHang * 0.1;
  double thanhTien() => tienHang - chietKhau() + vat;

  @override
  String toString() => '$maKH\t$tenKH\t$soLuong\t$giaBan\t${chietKhau()}\t${troGia()}\t${thanhTien()}';
}

class KhachHangCaNhan extends HoaDon {
  final double khoangCach;

  KhachHangCaNhan(super.maKH, super.tenKH, super.soLuong, super.giaBan, this.khoangCach);

  @override
  double chietKhau() {
    double result = soLuong < 3 ? 0.0 : tienHang * 0.05;
    if (khoangCach < 10) result += soLuong * 50000;
    return result;
  }

  @override
  double troGia() => tienHang * 0.02 + (soLuong > 2 ? 100000 : 0);
}

class DaiLyCap1 extends HoaDon {
  final int soNamHopTac;

  DaiLyCap1(super.maKH, super.tenKH, super.soLuong, super.giaBan, this.soNamHopTac);

  @override
  double chietKhau() {
    final tyLe = (0.30 + (soNamHopTac > 5 ? (soNamHopTac - 5) * 0.01 : 0.0)).clamp(0.0, 0.35).toDouble();
    return tienHang * tyLe;
  }

  @override
  double troGia() => 0;
}

class KhachHangCongTy extends HoaDon {
  final int soNhanVien;

  KhachHangCongTy(super.maKH, super.tenKH, super.soLuong, super.giaBan, this.soNhanVien);

  @override
  double chietKhau() {
    if (soNhanVien > 5000) return tienHang * 0.07;
    if (soNhanVien > 1000) return tienHang * 0.05;
    return 0;
  }

  @override
  double troGia() => soLuong * 120000;
}

class QuanLyHoaDon {
  final List<HoaDon> danhSach = [];

  void them(HoaDon hoaDon) => danhSach.add(hoaDon);
  double tongThanhTien() => danhSach.fold(0, (sum, hoaDon) => sum + hoaDon.thanhTien());
  double tongTroGia() => danhSach.fold(0, (sum, hoaDon) => sum + hoaDon.troGia());
  double tongChietKhauCongTy() => danhSach.whereType<KhachHangCongTy>().fold(0, (sum, hoaDon) => sum + hoaDon.chietKhau());

  HoaDon? khachMuaNhieuNhat() => danhSach.isEmpty ? null : danhSach.reduce((a, b) => a.soLuong >= b.soLuong ? a : b);

  void sapXep() {
    danhSach.sort((a, b) {
      final soLuong = a.soLuong.compareTo(b.soLuong);
      return soLuong != 0 ? soLuong : b.thanhTien().compareTo(a.thanhTien());
    });
  }

  List<HoaDon> timTheoMa(String maKH) => danhSach.where((hoaDon) => hoaDon.maKH == maKH).toList();
}
