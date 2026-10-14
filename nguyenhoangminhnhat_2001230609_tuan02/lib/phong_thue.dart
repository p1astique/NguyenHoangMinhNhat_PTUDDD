abstract class PhongThue {
  final String maPhong;
  final int soNguoi;
  final int soDien;
  final int soNuoc;

  PhongThue(this.maPhong, this.soNguoi, this.soDien, this.soNuoc);

  double tinhTienPhong();

  @override
  String toString() => '$maPhong\t$soNguoi\t$soDien\t$soNuoc\t${tinhTienPhong()}';
}

class PhongA extends PhongThue {
  final int soNguoiThan;

  PhongA(String maPhong, int soNguoi, int soDien, int soNuoc, this.soNguoiThan)
      : super(maPhong, soNguoi, soDien, soNuoc);

  @override
  double tinhTienPhong() => 1400.0 + 2 * soDien + 8 * soNuoc + 50 * soNguoiThan;
}

class PhongB extends PhongThue {
  final int giatUi;
  final int soMay;

  PhongB(String maPhong, int soNguoi, int soDien, int soNuoc, this.giatUi, this.soMay)
      : super(maPhong, soNguoi, soDien, soNuoc);

  @override
  double tinhTienPhong() => 2000 + 2 * soDien + 8 * soNuoc + giatUi * 5 + soMay * 100;
}

PhongThue phongFromLine(String line) {
  final parts = line.split('#').map((part) => part.trim()).toList();
  if (parts[0].startsWith('A') && parts.length == 5) {
    return PhongA(parts[0], int.parse(parts[1]), int.parse(parts[2]), int.parse(parts[3]), int.parse(parts[4]));
  }
  if (parts[0].startsWith('B') && parts.length == 6) {
    return PhongB(parts[0], int.parse(parts[1]), int.parse(parts[2]), int.parse(parts[3]), int.parse(parts[4]), int.parse(parts[5]));
  }
  throw const FormatException('Dòng phòng không hợp lệ');
}
