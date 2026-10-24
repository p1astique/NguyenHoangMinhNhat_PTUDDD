import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/dien_thoai.dart';

class DienThoaiApi {
  // Windows/Web: localhost
  // Android Emulator: 10.0.2.2
  static const String baseUrl = 'http://10.0.2.2:5130/api/DienThoai';

  // Lấy danh sách điện thoại
  static Future<List<DienThoai>> layDanhSach() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((item) => DienThoai.fromJson(item)).toList();
    }

    throw Exception(
      'Không thể tải danh sách điện thoại: ${response.statusCode}',
    );
  }

  // Lấy chi tiết điện thoại theo mã
  static Future<DienThoai> layChiTiet(String maSP) async {
    final response = await http.get(
      Uri.parse('$baseUrl/${Uri.encodeComponent(maSP)}'),
    );

    if (response.statusCode == 200) {
      return DienThoai.fromJson(jsonDecode(response.body));
    }

    throw Exception(
      'Không thể tải chi tiết điện thoại: ${response.statusCode}',
    );
  }
}
