import 'dart:io';

import '../lib/hoa_don.dart';
import '../lib/mon_hoc.dart';
import '../lib/nhan_vien.dart';
import '../lib/phong_thue.dart';
import '../lib/san_pham.dart';

Future<List<SanPham>> readSanPhamFile(String fileName) async {
  final arrs = <SanPham>[];
  try {
    final lines = await File(fileName).readAsLines();
    for (final line in lines) {
      final parts = line.split('#');
      if (parts.length == 4) {
        arrs.add(SanPham.fullPara(
          parts[0].trim(),
          parts[1].trim(),
          double.parse(parts[2].trim()),
          double.parse(parts[3].trim()),
        ));
      }
    }
  } catch (e) {
    print('Lỗi khi đọc file: $e');
  }
  return arrs;
}

Future<List<PhongThue>> readPhongFile(String fileName) async {
  final danhSach = <PhongThue>[];
  for (final line in await File(fileName).readAsLines()) {
    if (line.trim().isNotEmpty) danhSach.add(phongFromLine(line));
  }
  return danhSach;
}

Future<List<MonHoc>> readMonHocFile(String fileName) async {
  final danhSach = <MonHoc>[];
  for (final line in await File(fileName).readAsLines()) {
    final parts = line.split('#');
    if (parts.length < 5) continue;
    final ma = parts[0].trim();
    final ten = parts[1].trim();
    final soTC = int.parse(parts[2]);
    final loai = parts[3].trim();
    final diem = parts.sublist(4).map((value) => double.parse(value)).toList();
    if (loai == 'LT' && diem.length == 2) {
      danhSach.add(LyThuyet(ma, ten, soTC, diem[0], diem[1]));
    } else if (loai == 'TH' && diem.length == 3) {
      danhSach.add(ThucHanh(ma, ten, soTC, diem));
    } else if (loai == 'DA' && diem.length == 2) {
      danhSach.add(DoAn(ma, ten, soTC, diem[0], diem[1]));
    }
  }
  return danhSach;
}

void printList<T>(Iterable<T> items) {
  for (final item in items) print(item);
}

Future<void> baiHuongDan() async {
  print('\n===== BÀI TẬP HƯỚNG DẪN =====');
  final sp = SanPham();
  sp.showInfo();
  final sp1 = SanPham.fullPara('SP001', 'Bánh gạo Nhật', 25000, 0);
  final sp2 = SanPham.fullPara('SP002', 'Trà ô long', 75000, 0);
  final sp3 = SanPham.fullPara('SP003', 'Mứt xoài sấy', 45000, 0);
  print('Danh sách sản phẩm là:');
  for (final item in [sp1, sp2, sp3]) item.showInfo();
  print('\nDanh sách nhân viên và cán bộ:');
  final lstNhanVien = <Nhanvien>[
    Nhanvien.fullPara('NV001', 'Nguyễn Trần Tuấn', 2.34, 'Tổ chức', 23),
    CanBo.fullPara('NV002', 'Trần Văn Bình', 2.34, 'Tổ chức', 26, 'Trưởng phòng', 2.0),
    Nhanvien.fullPara('NV003', 'Nguyễn Nam', 2.34, 'Nhân sự', 27),
  ];
  printList(lstNhanVien);
  print('Danh sách nhân viên và cán bộ xếp loại A:');
  printList(lstNhanVien.where((a) => a.xepLoai() == 'A'));
  print('Tổng lương: ${lstNhanVien.fold<double>(0, (sum, nv) => sum + nv.tinhLuong())}');
  lstNhanVien.sort((x, y) => x.tinhLuong().compareTo(y.tinhLuong()));
  print('Danh sách sau khi sắp xếp tăng dần theo lương:');
  printList(lstNhanVien);
  final ds = await readSanPhamFile('lib/sanpham.txt');
  print('Đọc dữ liệu từ file:');
  for (final item in ds) item.showInfo();
}

Future<void> baiTuLamPhong() async {
  print('\n===== BÀI TẬP TỰ LÀM 1: PHÒNG THUÊ =====');
  final danhSach = await readPhongFile('lib/phongthue.txt');
  print('Danh sách phòng thuê:');
  printList(danhSach);
  print('Phòng có số người thuê lớn hơn 2:');
  printList(danhSach.where((phong) => phong.soNguoi > 2));
  print('Tổng tiền phòng: ${danhSach.fold<double>(0, (sum, phong) => sum + phong.tinhTienPhong())}');
  danhSach.sort((a, b) => b.soDien.compareTo(a.soDien));
  print('Danh sách giảm dần theo số điện:');
  printList(danhSach);
  print('Danh sách phòng loại A:');
  printList(danhSach.whereType<PhongA>());
}

Future<void> baiTuLamMonHoc() async {
  print('\n===== BÀI TẬP TỰ LÀM 2: MÔN HỌC =====');
  final danhSach = await readMonHocFile('lib/monhoc.txt');
  print('Danh sách môn học:');
  printList(danhSach);
  final daTangTheoTen = danhSach.every((a) => danhSach.indexOf(a) == 0 || danhSach[danhSach.indexOf(a) - 1].tenMH.compareTo(a.tenMH) <= 0);
  print('Danh sách đã tăng dần theo tên: $daTangTheoTen');
  danhSach.sort((a, b) => a.soTC.compareTo(b.soTC));
  print('Danh sách tăng dần theo số tín chỉ:');
  printList(danhSach);
  final maxTC = danhSach.map((mon) => mon.soTC).reduce((a, b) => a > b ? a : b);
  print('Môn học có số tín chỉ cao nhất:');
  printList(danhSach.where((mon) => mon.soTC == maxTC));
  const tenCanTim = 'Lập trình Dart';
  final timThay = danhSach.where((mon) => mon.tenMH == tenCanTim).toList();
  print(timThay.isEmpty ? 'Không tìm thấy môn $tenCanTim' : 'Môn $tenCanTim: ${timThay.first}');
  print('Số tín chỉ trung bình: ${danhSach.fold<double>(0, (sum, mon) => sum + mon.soTC) / danhSach.length}');
}

void baiVeNha() {
  print('\n===== BÀI TẬP VỀ NHÀ: HÓA ĐƠN =====');
  final quanLy = QuanLyHoaDon();
  quanLy.them(KhachHangCaNhan('KH0001', 'Nguyễn Văn An', 3, 10000000, 8));
  quanLy.them(DaiLyCap1('KH0002', 'Đại lý Minh Phát', 5, 8000000, 7));
  quanLy.them(KhachHangCongTy('KH0003', 'Công ty ABC', 10, 7000000, 2000));
  print('Danh sách hóa đơn:');
  printList(quanLy.danhSach);
  print('Tổng thành tiền: ${quanLy.tongThanhTien()}');
  print('Tổng tiền trợ giá: ${quanLy.tongTroGia()}');
  print('Khách hàng mua nhiều nhất: ${quanLy.khachMuaNhieuNhat()}');
  print('Tổng chiết khấu khách hàng công ty: ${quanLy.tongChietKhauCongTy()}');
  quanLy.sapXep();
  print('Danh sách tăng dần theo số lượng, cùng số lượng thì giảm dần thành tiền:');
  printList(quanLy.danhSach);
  const maCanTim = 'KH0002';
  final ketQua = quanLy.timTheoMa(maCanTim);
  if (ketQua.isEmpty) {
    print('Khách hàng lạ');
  } else {
    print('Hóa đơn của $maCanTim:');
    printList(ketQua);
  }
}

Future<void> main() async {
  await baiHuongDan();
  await baiTuLamPhong();
  await baiTuLamMonHoc();
  baiVeNha();
}
