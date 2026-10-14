import 'package:flutter/material.dart';

import 'screens/student_info.dart';
import 'screens/lecturer_info.dart';
import 'screens/project_info.dart';
import 'screens/product_info.dart';
import 'screens/group_info.dart';
import 'screens/major_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bài tập Flutter tuần 3',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 5,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text(
          'Bài tập Flutter - Tuần 3',
          style: TextStyle(
            color: Colors.white,
          ),
        ),

        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,

          tabs: const [
            Tab(
              icon: Icon(Icons.person),
              text: 'Bài 01',
            ),
            Tab(
              icon: Icon(Icons.assignment),
              text: 'Bài 02',
            ),
            Tab(
              icon: Icon(Icons.shopping_cart),
              text: 'Bài 03',
            ),
            Tab(
              icon: Icon(Icons.group),
              text: 'Bài 04',
            ),
            Tab(
              icon: Icon(Icons.school),
              text: 'Bài 05',
            ),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: const [
          Exercise01(),
          ProjectInfo(),
          ProductInfo(),
          GroupInfo(),
          MajorInfo(),
        ],
      ),
    );
  }
}

class Exercise01 extends StatelessWidget {
  const Exercise01({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: const [
          Material(
            color: Colors.blue,
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(
                  text: 'Sinh viên',
                  icon: Icon(Icons.person),
                ),
                Tab(
                  text: 'Giảng viên',
                  icon: Icon(Icons.school),
                ),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              children: [
                StudentInfo(),
                LecturerInfo(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}