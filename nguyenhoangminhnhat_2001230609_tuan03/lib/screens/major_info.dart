import 'package:flutter/material.dart';

class MajorInfo extends StatelessWidget {
  const MajorInfo({super.key});

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
          'Giới thiệu ngành học',
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
              const Center(
                child: Icon(
                  Icons.computer,
                  size: 100,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'NGÀNH CÔNG NGHỆ THÔNG TIN',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Ngành Công nghệ Thông tin đào tạo kiến thức và kỹ năng '
                'liên quan đến phần mềm, hệ thống máy tính, cơ sở dữ liệu, '
                'mạng máy tính và các ứng dụng công nghệ.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 30),

              const Divider(),

              const SizedBox(height: 20),

              const Text(
                'NGÀNH AN TOÀN THÔNG TIN',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Ngành An toàn Thông tin tập trung vào việc bảo vệ dữ liệu, '
                'hệ thống thông tin và mạng máy tính trước các nguy cơ '
                'mất an toàn và tấn công mạng.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 30),

              const Center(
                child: Text(
                  'Khoa Công nghệ Thông tin\n'
                  'Trường Đại học Công Thương TP.HCM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}