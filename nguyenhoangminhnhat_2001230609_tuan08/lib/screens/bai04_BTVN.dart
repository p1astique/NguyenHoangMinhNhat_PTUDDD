
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/homework_todo.dart';
import '../services/homework_todo_service.dart';
import '../services/notification_service.dart';

class Bai04BTVN extends StatefulWidget {
  const Bai04BTVN({super.key});

  @override
  State<Bai04BTVN> createState() => _Bai04BTVNState();
}

class _Bai04BTVNState extends State<Bai04BTVN> {
  final fileService = HomeworkTodoService();
  final notifications = NotificationService.instance;

  List<HomeworkTodo> todos = [];
  bool loading = true;
  bool busy = false;

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  Future<void> loadTodos() async {
    try {
      final data = await fileService.loadTodos();
      if (!mounted) return;
      setState(() {
        todos = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      showMessage('Không thể đọc danh sách: $e');
    }
  }

  void showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  String formatTime(DateTime? time) {
    if (time == null) return 'Chưa đặt lịch nhắc';
    return 'Nhắc lúc ${DateFormat('dd/MM/yyyy HH:mm').format(time)}';
  }

  int get completedCount =>
      todos.where((todo) => todo.isCompleted).length;

  Future<DateTime?> pickReminder(DateTime? current) async {
    final now = DateTime.now();
    final initial = current != null && current.isAfter(now)
        ? current
        : now;

    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(2100),
    );

    if (date == null || !mounted) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );

    if (time == null) return null;

    final result = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    if (!result.isAfter(DateTime.now())) {
      showMessage('Vui lòng chọn thời gian trong tương lai');
      return null;
    }

    return result;
  }

  Future<void> scheduleTask(HomeworkTodo todo) async {
    if (todo.reminderTime == null || todo.isCompleted) return;

    await notifications.requestPermissions();

    await notifications.scheduleTodoReminder(
      id: todo.id,
      title: todo.title,
      scheduledTime: todo.reminderTime!,
    );
  }

  Future<void> addTask() async {
    if (busy) return;

    final task = await Navigator.push<HomeworkTodo>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddHomeworkTodoScreen(),
      ),
    );

    if (task == null || !mounted) return;

    setState(() => busy = true);

    bool scheduled = false;

    try {
      if (task.reminderTime != null) {
        await scheduleTask(task);
        scheduled = true;
      }

      final updated = [...todos, task];
      await fileService.saveTodos(updated);

      if (!mounted) return;
      setState(() => todos = updated);
      showMessage('Đã lưu nhiệm vụ');
    } catch (e) {
      if (scheduled) {
        try {
          await notifications.cancelReminder(task.id);
        } catch (_) {}
      }
      showMessage('Không thể lưu nhiệm vụ: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> changeReminder(HomeworkTodo todo) async {
    if (busy || todo.isCompleted) return;

    final newTime = await pickReminder(todo.reminderTime);
    if (newTime == null || !mounted) return;

    setState(() => busy = true);

    final updatedTask = todo.copyWith(reminderTime: newTime);
    final updated = todos
        .map((item) => item.id == todo.id ? updatedTask : item)
        .toList();

    try {
      // Hủy lịch cũ trước khi đặt lịch mới.
      await notifications.cancelReminder(todo.id);
      await scheduleTask(updatedTask);

      await fileService.saveTodos(updated);

      if (!mounted) return;
      setState(() => todos = updated);
      showMessage('Đã cập nhật giờ nhắc');
    } catch (e) {
      // Khôi phục lịch cũ nếu có thể.
      try {
        await notifications.cancelReminder(todo.id);
        if (todo.reminderTime != null &&
            todo.reminderTime!.isAfter(DateTime.now())) {
          await scheduleTask(todo);
        }
      } catch (_) {}

      showMessage('Không thể cập nhật lịch: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> confirmComplete(HomeworkTodo todo) async {
    if (busy || todo.isCompleted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xác nhận hoàn thành'),
        content: Text(
          'Bạn có chắc đã hoàn thành nhiệm vụ "${todo.title}" không?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => busy = true);

    final completedTask = todo.copyWith(isCompleted: true);
    final updated = todos
        .map((item) => item.id == todo.id ? completedTask : item)
        .toList();

    try {
      // Lưu trạng thái hoàn thành.
      await fileService.saveTodos(updated);

      if (!mounted) return;
      setState(() => todos = updated);

      // Nhiệm vụ hoàn thành thì không cần nhắc nữa.
      try {
        await notifications.cancelReminder(todo.id);
      } catch (_) {}

      // Gửi thông báo tổng số nhiệm vụ đã hoàn thành.
      try {
        await notifications.requestPermissions();
        await notifications.notifyCompletedTasks(completedCount);
      } catch (e) {
        showMessage('Đã hoàn thành, nhưng không gửi được thông báo: $e');
      }

      showMessage('Đã hoàn thành nhiệm vụ');
    } catch (e) {
      showMessage('Không thể cập nhật nhiệm vụ: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhiệm vụ mỗi ngày'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                '$completedCount/${todos.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : todos.isEmpty
              ? const Center(
                  child: Text('Chưa có nhiệm vụ nào'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];

                    return Card(
                      color: todo.isCompleted
                          ? Colors.green.shade50
                          : Colors.grey.shade100,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: Checkbox(
                          value: todo.isCompleted,
                          onChanged: busy || todo.isCompleted
                              ? null
                              : (_) => confirmComplete(todo),
                        ),
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            decoration: todo.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: Text(
                          todo.isCompleted
                              ? 'Đã hoàn thành'
                              : formatTime(todo.reminderTime),
                        ),
                        trailing: IconButton(
                          tooltip: 'Thiết lập giờ nhắc',
                          icon: Icon(
                            todo.reminderTime == null
                                ? Icons.notifications_none
                                : Icons.notifications_active_outlined,
                          ),
                          onPressed: busy || todo.isCompleted
                              ? null
                              : () => changeReminder(todo),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: busy ? null : addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Màn hình thêm nhiệm vụ mới.
class AddHomeworkTodoScreen extends StatefulWidget {
  const AddHomeworkTodoScreen({super.key});

  @override
  State<AddHomeworkTodoScreen> createState() =>
      _AddHomeworkTodoScreenState();
}

class _AddHomeworkTodoScreenState
    extends State<AddHomeworkTodoScreen> {
  final titleController = TextEditingController();
  DateTime? reminderTime;

  String formatTime(DateTime time) {
    return DateFormat('dd/MM/yyyy HH:mm').format(time);
  }

  Future<void> pickTime() async {
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

    final selected = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    if (!selected.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Giờ nhắc phải ở tương lai'),
        ),
      );
      return;
    }

    setState(() => reminderTime = selected);
  }

  void saveTask() {
    final title = titleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập tên nhiệm vụ'),
        ),
      );
      return;
    }

    if (reminderTime != null &&
        !reminderTime!.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Giờ nhắc đã qua, vui lòng chọn lại'),
        ),
      );
      return;
    }

    final id = DateTime.now()
        .microsecondsSinceEpoch
        .remainder(1000000000) + 100000000;

    Navigator.pop(
      context,
      HomeworkTodo(
        id: id,
        title: title,
        reminderTime: reminderTime,
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm nhiệm vụ mới'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Tên nhiệm vụ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: pickTime,
              icon: const Icon(Icons.alarm),
              label: Text(
                reminderTime == null
                    ? 'Giờ nhắc'
                    : formatTime(reminderTime!),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: saveTask,
                child: const Text('Lưu nhiệm vụ'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
