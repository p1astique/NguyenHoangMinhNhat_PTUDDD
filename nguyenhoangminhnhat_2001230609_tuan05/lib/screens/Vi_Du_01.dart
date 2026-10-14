import 'package:flutter/material.dart';

class ViDu01 extends StatefulWidget {
  const ViDu01({super.key});

  @override
  State<ViDu01> createState() => _ViDu01State();
}

class _ViDu01State extends State<ViDu01> {
  // Danh sách tiêu đề
  static const List<String> dsTieuDe = [
    'Công nghệ phần mềm',
    'Hệ thống thông tin',
    'Mạng máy tính',
    'An toàn thông tin',
  ];

  // Danh sách nội dung
  static const List<String> dsNoiDung = [
    'Phát triển các ứng dụng giải quyết các vấn đề thực tế',
    'Phát triển các kỹ thuật xử lý thông tin trong tổ chức',
    'Xử lý các vấn đề liên quan đến mạng máy tính',
    'Thiết kế và đảm bảo an toàn cho hệ thống máy tính',
  ];

  // Nội dung hiển thị trong Dialog
  static const List<String> dsNoiDungTB = [
    'CNPM',
    'HTTT',
    'MMT',
    'BMTT',
  ];

  // Icon tương ứng
  static const List<IconData> dsIcon = [
    Icons.home,
    Icons.business,
    Icons.school,
    Icons.security,
  ];

  // Hiển thị AlertDialog
  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static const TextStyle _textStyle = TextStyle(
    fontSize: 20,
    color: Colors.red,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListView Demo'),
        backgroundColor: const Color.fromARGB(
          255,
          239,
          168,
          4,
        ),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {},
        ),
      ),

      body: ListView.builder(
        itemCount: dsTieuDe.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Icon(dsIcon[index]),

            title: Text(
              dsTieuDe[index],
              style: _textStyle,
            ),

            subtitle: Text(
              dsNoiDung[index],
            ),

            trailing: const Icon(
              Icons.arrow_forward,
            ),

            onTap: () {
              _showDialog(
                'Thông báo',
                'Bạn chọn ${dsNoiDungTB[index]}',
              );
            },
          );
        },
      ),
    );
  }
}