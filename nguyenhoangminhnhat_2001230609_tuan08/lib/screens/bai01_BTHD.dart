
import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class Bai01BTHD extends StatefulWidget {
  const Bai01BTHD({super.key});

  @override
  State<Bai01BTHD> createState() => _Bai01BTHDState();
}

class _Bai01BTHDState extends State<Bai01BTHD> {
  final service = NotificationService.instance;

  Future<void> execute(Future<void> Function() action, String message) async {
    try {
      await service.requestPermissions();
      await action();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tạo thông báo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 01 - Notification'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () => execute(
                  service.remindStudyNow,
                  'Đã gửi thông báo nhắc học ngoại ngữ',
                ),
                child: const Text('Gửi thông báo nhắc học Ngoại ngữ'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => execute(
                  () => service.scheduleReminder(
                    id: 101,
                    delay: const Duration(minutes: 2),
                    title: 'Uống nước',
                    body: 'Đến giờ uống nước rồi!',
                    channelId: 'drink_water_channel',
                  ),
                  'Đã hẹn nhắc uống nước sau 2 phút',
                ),
                child: const Text('Nhắc uống nước sau 2 phút'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => execute(
                  () => service.scheduleReminder(
                    id: 102,
                    delay: const Duration(minutes: 10),
                    title: 'Học ngoại ngữ',
                    body: 'Đến giờ ôn tập từ vựng rồi!',
                    channelId: 'study_reminder_channel',
                  ),
                  'Đã hẹn nhắc học ngoại ngữ sau 10 phút',
                ),
                child: const Text('Hẹn nhắc học Ngoại ngữ sau 10 phút'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
