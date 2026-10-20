
import 'package:flutter/material.dart';

import '../controllers/chi_tieu_controller.dart';
import '../models/chi_tieu.dart';

class Bai01BTVN extends StatefulWidget {
  const Bai01BTVN({super.key});

  @override
  State<Bai01BTVN> createState() => _Bai01BTVNState();
}

class _Bai01BTVNState extends State<Bai01BTVN> {
  final ChiTieuController controller = ChiTieuController();

  List<ChiTieu> danhSach = [];
  bool loading = true;
  bool busy = false;

  double get tongChiTieu {
    return danhSach.fold(
      0,
      (tong, item) => tong + item.soTien,
    );
  }

  String dinhDangTien(double soTien) {
    final value = soTien.toStringAsFixed(0);
    final result = value.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
    return '$result đ';
  }

  @override
  void initState() {
    super.initState();
    taiDanhSach();
  }

  Future<void> taiDanhSach() async {
    try {
      final data = await controller.getAll();

      if (!mounted) return;
      setState(() {
        danhSach = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      thongBao('Lỗi tải dữ liệu: $e');
    }
  }

  void thongBao(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<Map<String, String>?> moForm({
    ChiTieu? chiTieu,
  }) async {
    return showDialog<Map<String, String>>(
      context: context,
      builder: (_) => _ChiTieuDialog(chiTieu: chiTieu),
    );
  }

  Future<void> themChiTieu() async {
    if (busy) return;

    final data = await moForm();
    if (data == null || !mounted) return;

    final noiDung = data['noiDung']?.trim() ?? '';
    final soTien = double.tryParse(
      data['soTien']?.trim() ?? '',
    );
    final ghiChu = data['ghiChu']?.trim() ?? '';

    if (noiDung.isEmpty || soTien == null || soTien <= 0) {
      thongBao('Vui lòng nhập nội dung và số tiền hợp lệ');
      return;
    }

    setState(() => busy = true);

    try {
      await controller.insert(
        ChiTieu(
          noiDung: noiDung,
          soTien: soTien,
          ghiChu: ghiChu,
        ),
      );

      await taiDanhSach();
      thongBao('Đã thêm khoản chi');
    } catch (e) {
      thongBao('Không thể thêm khoản chi: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> suaChiTieu(ChiTieu chiTieu) async {
    if (busy) return;

    final data = await moForm(chiTieu: chiTieu);
    if (data == null || !mounted) return;

    final noiDung = data['noiDung']?.trim() ?? '';
    final soTien = double.tryParse(
      data['soTien']?.trim() ?? '',
    );
    final ghiChu = data['ghiChu']?.trim() ?? '';

    if (noiDung.isEmpty || soTien == null || soTien <= 0) {
      thongBao('Vui lòng nhập nội dung và số tiền hợp lệ');
      return;
    }

    setState(() => busy = true);

    try {
      await controller.update(
        ChiTieu(
          id: chiTieu.id,
          noiDung: noiDung,
          soTien: soTien,
          ghiChu: ghiChu,
        ),
      );

      await taiDanhSach();
      thongBao('Đã cập nhật khoản chi');
    } catch (e) {
      thongBao('Không thể cập nhật khoản chi: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> xoaChiTieu(ChiTieu chiTieu) async {
    if (busy) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xóa khoản chi'),
        content: Text(
          'Bạn có chắc muốn xóa "${chiTieu.noiDung}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => busy = true);

    try {
      await controller.delete(chiTieu.id!);
      await taiDanhSach();
      thongBao('Đã xóa khoản chi');
    } catch (e) {
      thongBao('Không thể xóa khoản chi: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý chi tiêu cá nhân'),
        backgroundColor: Colors.teal.shade100,
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            color: Colors.teal.shade50,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TỔNG CHI TIÊU',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dinhDangTien(tongChiTieu),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('${danhSach.length} khoản chi'),
                ],
              ),
            ),
          ),
          Expanded(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : danhSach.isEmpty
                    ? const Center(
                        child: Text('Chưa có khoản chi nào'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        itemCount: danhSach.length,
                        itemBuilder: (context, index) {
                          final item = danhSach[index];

                          return Card(
                            child: ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.payments_outlined),
                              ),
                              title: Text(item.noiDung),
                              subtitle: Text(
                                item.ghiChu.isEmpty
                                    ? 'Không có ghi chú'
                                    : item.ghiChu,
                              ),
                              onTap: busy
                                  ? null
                                  : () => suaChiTieu(item),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    dinhDangTien(item.soTien),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed: busy
                                        ? null
                                        : () => xoaChiTieu(item),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: busy ? null : themChiTieu,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ChiTieuDialog extends StatefulWidget {
  final ChiTieu? chiTieu;

  const _ChiTieuDialog({this.chiTieu});

  @override
  State<_ChiTieuDialog> createState() => _ChiTieuDialogState();
}

class _ChiTieuDialogState extends State<_ChiTieuDialog> {
  late final TextEditingController noiDungInput;
  late final TextEditingController soTienInput;
  late final TextEditingController ghiChuInput;

  @override
  void initState() {
    super.initState();

    noiDungInput = TextEditingController(
      text: widget.chiTieu?.noiDung ?? '',
    );

    soTienInput = TextEditingController(
      text: widget.chiTieu?.soTien.toStringAsFixed(0) ?? '',
    );

    ghiChuInput = TextEditingController(
      text: widget.chiTieu?.ghiChu ?? '',
    );
  }

  @override
  void dispose() {
    noiDungInput.dispose();
    soTienInput.dispose();
    ghiChuInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.chiTieu == null
            ? 'Thêm khoản chi'
            : 'Chỉnh sửa khoản chi',
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: noiDungInput,
              decoration: const InputDecoration(
                labelText: 'Nội dung chi tiêu',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: soTienInput,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Số tiền (VNĐ)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ghiChuInput,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Ghi chú',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'noiDung': noiDungInput.text,
              'soTien': soTienInput.text,
              'ghiChu': ghiChuInput.text,
            });
          },
          child: Text(
            widget.chiTieu == null ? 'Lưu' : 'Cập nhật',
          ),
        ),
      ],
    );
  }
}
