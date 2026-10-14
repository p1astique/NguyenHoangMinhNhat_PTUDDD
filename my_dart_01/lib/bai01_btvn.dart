import 'dart:io';
import 'dart:math';

void main() {
  // --- BƯỚC KHỞI TẠO DANH SÁCH NGẪU NHIÊN ---
  Random random = Random();
  stdout.write("Nhập số lượng phần tử của danh sách muốn tạo: ");
  int n = int.tryParse(stdin.readLineSync() ?? '0') ?? 10; // Mặc định 10 phần tử nếu không nhập

  List<int> danhSach = [];
  for (int i = 0; i < n; i++) {
    // Random.nextInt(96) tạo số từ 0 đến 95. Cộng thêm 5 sẽ ra khoảng 5 đến 100
    danhSach.add(random.nextInt(96) + 5);
  }

  // a. Xuất danh sách
  print("\na. Danh sách vừa tạo: $danhSach");

  // b. Tính tổng
  int tong = 0;
  for (int num in danhSach) {
    tong += num;
  }
  print("b. Tổng các phần tử: $tong");

  // c. Tính trung bình cộng các số lẻ
  int tongLe = 0;
  int demLe = 0;
  for (int num in danhSach) {
    if (num % 2 != 0) {
      tongLe += num;
      demLe++;
    }
  }
  if (demLe > 0) {
    print("c. Trung bình cộng các số lẻ: ${tongLe / demLe}");
  } else {
    print("c. Danh sách không có số lẻ.");
  }

  // d. Kiểm tra danh sách đối xứng
  bool doiXung = true;
  for (int i = 0; i < danhSach.length ~/ 2; i++) {
    if (danhSach[i] != danhSach[danhSach.length - 1 - i]) {
      doiXung = false;
      break;
    }
  }
  print("d. Danh sách này ${doiXung ? 'CÓ' : 'KHÔNG'} đối xứng.");

  // e. Kiểm tra danh sách tăng dần
  bool tangDan = true;
  for (int i = 0; i < danhSach.length - 1; i++) {
    if (danhSach[i] > danhSach[i + 1]) { // Chỉ cần 1 phần tử đứng trước lớn hơn phần tử đứng sau là gãy
      tangDan = false;
      break;
    }
  }
  print("e. Danh sách này ${tangDan ? 'CÓ' : 'KHÔNG'} sắp xếp tăng dần.");

  // f. Tìm phần tử lớn nhất
  int maxVal = danhSach[0];
  for (int num in danhSach) {
    if (num > maxVal) {
      maxVal = num;
    }
  }
  print("f. Phần tử lớn nhất: $maxVal");

  // g. Tìm số chẵn lớn nhất
  int? maxChan; // Dùng int? vì có thể mảng không có số chẵn nào
  for (int num in danhSach) {
    if (num % 2 == 0) {
      if (maxChan == null || num > maxChan) {
        maxChan = num;
      }
    }
  }
  if (maxChan != null) {
    print("g. Số chẵn lớn nhất: $maxChan");
  } else {
    print("g. Danh sách không có số chẵn.");
  }

  // h. Tìm và xóa giá trị
  stdout.write("\nh. Nhập một giá trị cần tìm và xóa: ");
  int? giaTriTim = int.tryParse(stdin.readLineSync() ?? '');

  if (giaTriTim != null) {
    if (danhSach.contains(giaTriTim)) {
      // Hàm removeWhere giúp xóa TẤT CẢ các phần tử thỏa mãn điều kiện
      danhSach.removeWhere((element) => element == giaTriTim);
      print("-> Đã xóa tất cả các số $giaTriTim khỏi danh sách.");
      print("-> Danh sách cập nhật: $danhSach");
    } else {
      print("-> Không tìm thấy.");
    }
  } else {
    print("-> Giá trị nhập không hợp lệ.");
  }
}