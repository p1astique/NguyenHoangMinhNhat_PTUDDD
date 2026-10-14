class Nhanvien {
  String _maNV = '';
  String _tenNV = '';
  double _heSoLuong = 0.0;
  String _phongBan = '';
  double _soNgayLV = 0.0;
  static double LCB = 2340;

  Nhanvien() {
    _maNV = 'NV000';
    _tenNV = 'Nguyễn Văn A';
    _heSoLuong = 2.34;
    _phongBan = 'Tổ chức';
    _soNgayLV = 22;
  }

  Nhanvien.fullPara(String manv, String tennv, double hsl, String pb, double songaylv) {
    _maNV = manv;
    _tenNV = tennv;
    _heSoLuong = hsl;
    _phongBan = pb;
    _soNgayLV = songaylv;
  }

  String xepLoai() {
    if (_soNgayLV > 25) return 'A';
    if (_soNgayLV > 22) return 'B';
    return 'C';
  }

  double tinhLuong() {
    final xLoai = xepLoai();
    var hsThiDua = 0.5;
    if (xLoai == 'A') hsThiDua = 1;
    if (xLoai == 'B') hsThiDua = 0.75;
    return LCB * _heSoLuong * hsThiDua;
  }

  @override
  String toString() => '$_maNV\t$_tenNV\t$_heSoLuong\t$_phongBan\t$_soNgayLV\t${xepLoai()}\t${tinhLuong()}';
}

class CanBo extends Nhanvien {
  String _chucVu = '';
  double _hsChucVu = 0;

  CanBo() : super() {
    _chucVu = 'Unknow';
    _hsChucVu = 0;
  }

  CanBo.fullPara(String manv, String tennv, double hsl, String pb, double songaylv, String chucvu, double hscv)
      : super.fullPara(manv, tennv, hsl, pb, songaylv) {
    _chucVu = chucvu;
    _hsChucVu = hscv;
  }

  @override
  String toString() => '${super.toString()}\t$_chucVu\t$_hsChucVu';

  @override
  double tinhLuong() => super.tinhLuong() + _hsChucVu * 1100;
}
