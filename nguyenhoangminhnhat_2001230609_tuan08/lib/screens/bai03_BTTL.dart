
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/todo.dart';
import '../services/file_services.dart';
import '../services/notification_service.dart';

class Bai03BTTL extends StatefulWidget {
  const Bai03BTTL({super.key});

  @override
  State<Bai03BTTL> createState() => _Bai03BTTLState();
}

class _Bai03BTTLState extends State<Bai03BTTL> {
  final TextEditingController controller = TextEditingController();
  final FileService fileService = FileService();
  final NotificationService notificationService =
      NotificationService.instance;

  List<Todo> todos = [];
  DateTime? selectedTime;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await fileService.loadTodos();

    if (!mounted) return;
    setState(() {
      todos = data;
    });
  }

  String formatTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  Future<void> pickDateTime() async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(2100),
    );

    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null || !mounted) return;

    setState(() {
      selectedTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> addTodo() async {
    if (isSaving) return;

    final title = controller.text.trim();
    final time = selectedTime;

    if (title.isEmpty || time == null) {
      showMessage('Vui lòng nhập công việc và chọn thời gian');
      return;
    }

    if (!time.isAfter(DateTime.now())) {
      showMessage('Vui lòng chọn thời gian trong tương lai');
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      // Xin quyền gửi thông báo và đặt lịch chính xác.
      await notificationService.requestPermissions();

      // Tạo ID riêng cho thông báo.
      final notificationId = DateTime.now()
          .microsecondsSinceEpoch
          .remainder(2147483647);

      // Đặt lịch nhắc công việc.
      await notificationService.scheduleTodoReminder(
        id: notificationId,
        title: title,
        scheduledTime: time,
      );

      // Lưu công việc vào file todo.txt.
      final todo = Todo(title: title, time: time);
      final updatedTodos = [...todos, todo];

      try {
        await fileService.saveTodos(updatedTodos);
      } catch (_) {
        // Nếu lưu file thất bại, hủy lịch vừa tạo.
        await notificationService.cancelReminder(
          notificationId,
        );
        rethrow;
      }

      if (!mounted) return;

      setState(() {
        todos = updatedTodos;
        controller.clear();
        selectedTime = null;
      });

      // Thông báo ngay sau khi lưu thành công.
      try {
        await notificationService.notifyTodoSaved(
          id: notificationId == 2147483646
              ? 2147483645
              : notificationId + 1,
          title: title,
        );
        showMessage('Đã lưu và đặt lịch nhắc công việc');
      } catch (_) {
        showMessage(
          'Đã lưu và đặt lịch, nhưng không hiển thị được thông báo xác nhận',
        );
      }
    } catch (e) {
      if (!mounted) return;
      showMessage('Không thể đặt lịch hoặc lưu công việc: $e');
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.red.shade100,
      Colors.green.shade100,
      Colors.blue.shade100,
      Colors.yellow.shade100,
      Colors.purple.shade100,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App - Notification'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Tên công việc',
                hintText: 'Nhập công việc cần thực hiện',
                prefixIcon: const Icon(Icons.edit_note),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedTime == null
                        ? 'Chưa chọn thời gian'
                        : formatTime(selectedTime!),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: pickDateTime,
                  icon: const Icon(Icons.calendar_month),
                  label: const Text('Chọn thời gian'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isSaving ? null : addTodo,
                icon: const Icon(Icons.save),
                label: Text(isSaving ? 'Đang lưu...' : 'Lưu'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: todos.isEmpty
                  ? const Center(
                      child: Text('Chưa có công việc nào'),
                    )
                  : ListView.builder(
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final todo = todos[index];

                        return Card(
                          color: colors[index % colors.length],
                          child: ListTile(
                            leading: const Icon(
                              Icons.notifications_active,
                              color: Colors.blue,
                            ),
                            title: Text(
                              todo.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              formatTime(todo.time),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
  
}
