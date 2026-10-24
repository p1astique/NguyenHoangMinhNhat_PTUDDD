class DienThoai {
  final String maSP;
  final String tenSP;
  final String hangSanXuat;
  final double gia;
  final String? moTa;
  final String? hinhAnh;

  DienThoai({
    required this.maSP,
    required this.tenSP,
    required this.hangSanXuat,
    required this.gia,
    this.moTa,
    this.hinhAnh,
  });

  factory DienThoai.fromJson(Map<String, dynamic> json) {
    return DienThoai(
      maSP: json['maSP'] as String,
      tenSP: json['tenSP'] as String,
      hangSanXuat: json['hangSanXuat'] as String,
      gia: (json['gia'] as num).toDouble(),
      moTa: json['moTa'] as String?,
      hinhAnh: json['hinhAnh'] as String?,
    );
  }

  String get anhSanPham {
    switch (maSP) {
      case 'DT001':
        return 'assets/images/iphone_15_pro_max.png';
      case 'DT002':
        return 'assets/images/iphone_15.png';
      case 'DT003':
        return 'assets/images/oppo_reno_10_pro_plus.png';
      case 'DT004':
        return 'assets/images/oppo_reno_11f.png';
      case 'DT005':
        return 'assets/images/samsung_s24_plus.png';
      case 'DT006':
        return 'assets/images/xiaomi_14.png';
      default:
        return '';
    }
  }
}
