class SanPham {
  String _maSP = '';
  String _tenSP = '';
  double _donGia = 0;
  double _giamGia = 0;

  SanPham() {
    _maSP = 'SP000';
    _tenSP = 'Unknow';
    _donGia = 0;
    _giamGia = 0;
  }

  SanPham.fullPara(String masp, String tensp, double gia, double giam) {
    _maSP = masp;
    _tenSP = tensp;
    _donGia = gia;
    _giamGia = giam;
  }

  String get maSP => _maSP;
  set maSP(String value) {
    if (value.isNotEmpty) _maSP = value;
  }

  String get tenSP => _tenSP;
  set tenSP(String value) {
    if (value.isNotEmpty) _tenSP = value;
  }

  double get donGia => _donGia;
  set donGia(double value) {
    if (value > 0) _donGia = value;
  }

  double get giamGia => _giamGia;
  set giamGia(double value) {
    if (value >= 0) _giamGia = value;
  }

  double tinhThueNhapKhau() => 0.01 * _donGia;

  void showInfo() {
    print('Mã sản phẩm: $_maSP, tên: $_tenSP, giá bán: $_donGia, giảm giá: $_giamGia, thuế: ${tinhThueNhapKhau()}');
  }
}
