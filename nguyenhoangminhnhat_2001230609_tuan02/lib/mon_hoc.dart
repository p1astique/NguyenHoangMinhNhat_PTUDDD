abstract class MonHoc {
  final String maMH;
  final String tenMH;
  final int soTC;

  MonHoc(this.maMH, this.tenMH, this.soTC);

  double tinhDTB();

  String diemChu() {
    final diem = tinhDTB();
    if (diem >= 8.5) return 'A';
    if (diem >= 7) return 'B';
    if (diem >= 5.5) return 'C';
    if (diem >= 4) return 'D';
    return 'F';
  }

  @override
  String toString() => '$maMH\t$tenMH\t$soTC\t${tinhDTB().toStringAsFixed(2)}\t${diemChu()}';
}

class LyThuyet extends MonHoc {
  final double diemTieuLuan;
  final double diemCuoiKy;

  LyThuyet(super.maMH, super.tenMH, super.soTC, this.diemTieuLuan, this.diemCuoiKy);

  @override
  double tinhDTB() => diemTieuLuan * 0.3 + diemCuoiKy * 0.7;
}

class ThucHanh extends MonHoc {
  final List<double> diemKiemTra;

  ThucHanh(super.maMH, super.tenMH, super.soTC, this.diemKiemTra);

  @override
  double tinhDTB() => diemKiemTra.reduce((a, b) => a + b) / diemKiemTra.length;
}

class DoAn extends MonHoc {
  final double diemGVHD;
  final double diemGVPB;

  DoAn(super.maMH, super.tenMH, super.soTC, this.diemGVHD, this.diemGVPB);

  @override
  double tinhDTB() => (diemGVHD + diemGVPB) / 2;
}
