import 'package:flutter/material.dart';

import '../models/dien_thoai.dart';
import '../services/dien_thoai_api.dart';

class ChiTietDienThoaiPage extends StatelessWidget {
  final String maSP;

  const ChiTietDienThoaiPage({super.key, required this.maSP});

  String dinhDangGia(double gia) {
    return gia
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết điện thoại'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<DienThoai>(
        future: DienThoaiApi.layChiTiet(maSP),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          final dt = snapshot.data;

          if (dt == null) {
            return const Center(child: Text('Không tìm thấy điện thoại'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    height: 250,
                    width: 250,
                    child: dt.anhSanPham.isNotEmpty
                        ? Image.asset(
                            dt.anhSanPham,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.broken_image_outlined,
                                size: 100,
                                color: Colors.grey,
                              );
                            },
                          )
                        : const Icon(
                            Icons.smartphone,
                            size: 150,
                            color: Colors.blue,
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  dt.tenSP,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${dinhDangGia(dt.gia)} đ',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(height: 32),
                Text(
                  'Mã sản phẩm: ${dt.maSP}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 12),
                Text(
                  'Hãng sản xuất: ${dt.hangSanXuat}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Mô tả sản phẩm',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  dt.moTa?.isNotEmpty == true
                      ? dt.moTa!
                      : 'Chưa có mô tả sản phẩm.',
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
