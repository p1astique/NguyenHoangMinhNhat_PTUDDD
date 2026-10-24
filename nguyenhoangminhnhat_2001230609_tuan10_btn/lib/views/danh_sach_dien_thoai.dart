import 'package:flutter/material.dart';

import '../models/dien_thoai.dart';
import '../services/dien_thoai_api.dart';
import 'chi_tiet_dien_thoai.dart';

class DanhSachDienThoaiPage extends StatefulWidget {
  const DanhSachDienThoaiPage({super.key});

  @override
  State<DanhSachDienThoaiPage> createState() => _DanhSachDienThoaiPageState();
}

class _DanhSachDienThoaiPageState extends State<DanhSachDienThoaiPage> {
  late Future<List<DienThoai>> danhSachFuture;

  @override
  void initState() {
    super.initState();
    taiDuLieu();
  }

  void taiDuLieu() {
    danhSachFuture = DienThoaiApi.layDanhSach();
  }

  String dinhDangGia(double gia) {
    final text = gia.toStringAsFixed(0);
    return text.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách điện thoại'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(taiDuLieu);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<DienThoai>>(
        future: danhSachFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Lỗi tải dữ liệu:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final danhSach = snapshot.data ?? [];

          if (danhSach.isEmpty) {
            return const Center(child: Text('Chưa có điện thoại nào'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: danhSach.length,
            itemBuilder: (context, index) {
              final dt = danhSach[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),

                  leading: SizedBox(
                    width: 70,
                    height: 70,
                    child: dt.anhSanPham.isNotEmpty
                        ? Image.asset(
                            dt.anhSanPham,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.broken_image_outlined,
                                size: 45,
                                color: Colors.grey,
                              );
                            },
                          )
                        : const Icon(Icons.smartphone, size: 45),
                  ),

                  title: Text(
                    dt.tenSP,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dt.hangSanXuat),
                      const SizedBox(height: 5),
                      Text(
                        '${dinhDangGia(dt.gia)} đ',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChiTietDienThoaiPage(maSP: dt.maSP),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
