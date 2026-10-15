import 'package:flutter/material.dart';

import 'screens/bai01_BTHD.dart';
import 'services/notification_service.dart';
import 'screens/bai02_BTHD.dart';
import 'screens/bai03_BTTL.dart';
import 'screens/bai04_BTTL.dart';
import 'screens/bai04_BTVN.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bài 08 - Notification và File',
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
      appBar: AppBar(title: const Text('Bài 08 - Notification và File')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.notifications_active),
              title: const Text('Bài 01 - BTHD'),
              subtitle: const Text('Thông báo và hẹn giờ nhắc nhở'),
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
              leading: const Icon(Icons.task_alt),
              title: const Text('Bài 02 - BTHD'),
              subtitle: const Text('Todo List - Lưu công việc vào file'),
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
              leading: const Icon(
                Icons.notifications_active,
                color: Colors.deepOrange,
              ),
              title: const Text('Bài 03 - BTTL'),
              subtitle: const Text('Todo List kết hợp thông báo nhắc việc'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Bai03BTTL()),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.menu_book, color: Colors.deepPurple),
              title: const Text('Bài 04 - BTTL'),
              subtitle: const Text('Ứng dụng hỗ trợ học tập từ vựng'),
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
              leading: const Icon(
                Icons.assignment_turned_in,
                color: Colors.teal,
              ),
              title: const Text('Bài 04 - BTVN'),
              subtitle: const Text('Todo List - Nhắc việc và hoàn thành'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Bai04BTVN()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
