import 'package:flutter/material.dart';

class ProjectInfo extends StatelessWidget {
  const ProjectInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        leading: const Icon(
          Icons.home,
          color: Colors.white,
        ),
        title: const Text(
          'Thông tin đề tài đồ án',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Center(
              child: Icon(
                Icons.assignment,
                size: 100,
                color: Colors.blue,
              ),
            ),

            SizedBox(height: 30),

            Text(
              'Mã đề tài: DT001',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),

            SizedBox(height: 15),

            Text(
              'Tên đề tài: Xây dựng ứng dụng quản lý dịch vụ ăn uống',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),

            SizedBox(height: 15),

            Text(
              'Số lượng sinh viên tối đa: 3',
              style: TextStyle(
                fontSize: 20,
                color: Colors.green,
              ),
            ),

            SizedBox(height: 15),

            Text(
              'Chuyên ngành: Kỹ thuật phần mềm',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue,
              ),
            ),

            SizedBox(height: 15),

            Text(
              'Giảng viên hướng dẫn: Nguyễn Văn B',
              style: TextStyle(
                fontSize: 20,
                color: Colors.orange,
              ),
            ),

            SizedBox(height: 15),

            Text(
              'Yêu cầu đề tài:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),

            SizedBox(height: 8),

            Text(
              '- Xây dựng giao diện ứng dụng.\n'
              '- Quản lý dữ liệu người dùng.\n'
              '- Quản lý thông tin đơn hàng.\n'
              '- Hoàn thiện chức năng theo yêu cầu đề tài.',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}