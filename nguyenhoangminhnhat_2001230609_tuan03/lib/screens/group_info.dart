import 'package:flutter/material.dart';

class GroupInfo extends StatelessWidget {
  const GroupInfo({super.key});

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
          'Thông tin nhóm',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mã nhóm: N01',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Tên nhóm: Nhóm Flutter',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Số lượng thành viên: 3',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'THÔNG TIN THÀNH VIÊN',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 20),

              _buildMember(
                'MSSV: 2001230609',
                'Họ tên: Nguyễn Hoàng Minh Nhật',
                'Vai trò: Nhóm trưởng',
              ),

              const SizedBox(height: 20),

              _buildMember(
                'MSSV: 2001230610',
                'Họ tên: Nguyễn Văn A',
                'Vai trò: Thành viên',
              ),

              const SizedBox(height: 20),

              _buildMember(
                'MSSV: 2001230611',
                'Họ tên: Trần Thị B',
                'Vai trò: Thành viên',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMember(
    String studentId,
    String name,
    String role,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            studentId,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.blue,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            role,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}