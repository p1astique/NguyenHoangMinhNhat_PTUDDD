import 'package:flutter/material.dart';

import 'screens/bai01_BTHD.dart';
import 'screens/bai02_BTHD.dart';
import 'screens/bai04_BTTL.dart';
import 'screens/bai_BTVN.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bài 07 - Multimedia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 07 - Multimedia'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Bài 01 - BTHD'),
              subtitle: const Text('Hiển thị bản đồ và vị trí hiện tại'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Bai01BTHD()),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.route),
              title: const Text('Bài 02 - BTHD'),
              subtitle: const Text('Nhập hai điểm và tìm đường đi'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Bai02BTHD()),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.travel_explore),
              title: const Text('Bài 04 - BTTL'),
              subtitle: const Text('Tìm đường và tìm địa điểm xung quanh'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Bai04BTTL()),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.home_work),
              title: const Text('Bài tập về nhà - Bài 07'),
              subtitle: const Text(
                'Tìm địa chỉ, chọn phương tiện và lưu tuyến đường',
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BaiBTVN()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
