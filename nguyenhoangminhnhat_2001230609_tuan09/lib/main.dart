import 'package:flutter/material.dart';

import 'views/task_screen.dart';
import 'views/bai02_BTTL.dart';
import 'views/bai01_BTVN.dart';
import 'views/bai02_BTVN.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tuần 09 - SQLite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
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
        title: const Text('Tuần 09 - SQLite'),
        backgroundColor: Colors.lightBlue.shade100,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: const Text('Bài 01 - BTTL'),
              subtitle: const Text('Quản lý và cập nhật trạng thái công việc'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TaskScreen()),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Bài 02 - BTTL'),
              subtitle: const Text('Quản lý sinh viên'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Bai02BTTL()),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.account_balance_wallet_outlined),
              title: const Text('Bài 01 - BTVN'),
              subtitle: const Text('Quản lý chi tiêu cá nhân'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Bai01BTVN()),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Bài 02 - BTVN'),
              subtitle: const Text('Đăng nhập và đăng ký tài khoản'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Bai02BTVN()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
