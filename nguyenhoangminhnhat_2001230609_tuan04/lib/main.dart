import 'package:flutter/material.dart';

import 'screens/Bai_Tap_Huong_Dan_1.dart';
import 'screens/Vi_Du.dart';
import 'screens/Bai_Tap_01.dart';
import 'screens/Bai_Tap_02.dart';
import 'screens/Bai_Tap_03.dart';
import 'screens/Bai_Tap_04.dart';
import 'screens/Bai_Tap_05.dart';
import 'screens/Bai_Tap_06.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bài tập Tuần 04',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> exercises = [
      {
        'title': 'Bài tập hướng dẫn 1',
        'subtitle': 'Thiết kế Layout với Row, Column và Container',
        'icon': Icons.dashboard_outlined,
        'page': const BaiTapHuongDan1(),
      },
      {
        'title': 'Ví dụ',
        'subtitle': 'Thiết kế giao diện với Stack và Positioned',
        'icon': Icons.layers_outlined,
        'page': const ViDu(),
      },
      {
        'title': 'Bài tập 01',
        'subtitle': 'Ứng dụng máy tính',
        'icon': Icons.calculate_outlined,
        'page': const BaiTap01(),
      },
      {
        'title': 'Bài tập 02',
        'subtitle': 'Giới thiệu cơ sở vật chất HUIT',
        'icon': Icons.school_outlined,
        'page': const BaiTap02(),
      },
      {
        'title': 'Bài tập 03',
        'subtitle': 'Trạng thái và cảm xúc trong ngày',
        'icon': Icons.emoji_emotions_outlined,
        'page': const BaiTap03(),
      },
      {
        'title': 'Bài tập 04',
        'subtitle': 'Giao diện ví điện tử',
        'icon': Icons.account_balance_wallet_outlined,
        'page': const BaiTap04(),
      },
      {
        'title': 'Bài tập 05',
        'subtitle': 'Đăng ký khám bệnh trực tuyến',
        'icon': Icons.local_hospital_outlined,
        'page': const BaiTap05(),
      },
      {
        'title': 'Bài tập 06',
        'subtitle': 'Ứng dụng nghe nhạc',
        'icon': Icons.headphones_outlined,
        'page': const BaiTap06(),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text(
          'Bài tập Tuần 04',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),

              leading: CircleAvatar(
                radius: 25,
                backgroundColor:
                    Colors.blue.withValues(alpha: 0.12),
                child: Icon(
                  exercise['icon'],
                  color: Colors.blue,
                ),
              ),

              title: Text(
                exercise['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  exercise['subtitle'],
                ),
              ),

              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        exercise['page'] as Widget,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}