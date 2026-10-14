import 'package:flutter/material.dart';

class BaiTap01 extends StatefulWidget {
  const BaiTap01({super.key});

  @override
  State<BaiTap01> createState() => _BaiTap01State();
}

class _BaiTap01State extends State<BaiTap01> {
  int _loaiDangChon = 0;
  int _chuyenNganhDangChon = 0;

  final List<Map<String, dynamic>> _dsLoai = [
    {
      'ten': 'Đồ án',
      'icon': Icons.assignment,
    },
    {
      'ten': 'KLKS',
      'icon': Icons.school,
    },
    {
      'ten': 'Luận văn',
      'icon': Icons.menu_book,
    },
    {
      'ten': 'Khác',
      'icon': Icons.more_horiz,
    },
  ];

  final List<String> _dsChuyenNganh = [
    'Công nghệ phần mềm',
    'Hệ thống thông tin',
    'Mạng máy tính',
    'An toàn thông tin',
  ];

  void _chonLoai(int index) {
    setState(() {
      _loaiDangChon = index;
    });
  }

  void _chonChuyenNganh(int index) {
    setState(() {
      _chuyenNganhDangChon = index;
    });
  }

  void _xacNhan() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thông báo'),
          content: Text(
            'Bạn đã chọn:\n\n'
            'Loại: ${_dsLoai[_loaiDangChon]['ten']}\n'
            'Chuyên ngành: ${_dsChuyenNganh[_chuyenNganhDangChon]}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          'Lựa chọn đề tài',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================
            // LOẠI ĐỀ TÀI
            // =========================

            const Text(
              'Loại đề tài',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                _dsLoai.length,
                (index) {
                  final bool selected =
                      _loaiDangChon == index;

                  return GestureDetector(
                    onTap: () => _chonLoai(index),

                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration:
                              const Duration(milliseconds: 200),
                          width: 65,
                          height: 65,

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected
                                ? Colors.orange
                                : Colors.grey.shade200,

                            border: Border.all(
                              color: selected
                                  ? Colors.deepOrange
                                  : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),

                          child: Icon(
                            _dsLoai[index]['icon'],
                            size: 30,
                            color: selected
                                ? Colors.white
                                : Colors.black54,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          _dsLoai[index]['ten'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: selected
                                ? Colors.orange
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 35),

            // =========================
            // CHUYÊN NGÀNH
            // =========================

            const Text(
              'Chuyên ngành',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                itemCount: _dsChuyenNganh.length,

                itemBuilder: (context, index) {
                  final bool selected =
                      _chuyenNganhDangChon == index;

                  return Card(
                    margin:
                        const EdgeInsets.only(bottom: 10),

                    color: selected
                        ? Colors.orange.shade50
                        : Colors.white,

                    child: ListTile(
                      onTap: () =>
                          _chonChuyenNganh(index),

                      leading: CircleAvatar(
                        backgroundColor: selected
                            ? Colors.orange
                            : Colors.grey.shade200,

                        child: Icon(
                          Icons.computer,
                          color: selected
                              ? Colors.white
                              : Colors.black54,
                        ),
                      ),

                      title: Text(
                        _dsChuyenNganh[index],
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: selected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),

                      trailing: Icon(
                        selected
                            ? Icons.check_circle
                            : Icons
                                .radio_button_unchecked,
                        color: selected
                            ? Colors.orange
                            : Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),

            // =========================
            // BUTTON
            // =========================

            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton(
                onPressed: _xacNhan,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),

                child: const Text(
                  'Xác nhận lựa chọn',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}