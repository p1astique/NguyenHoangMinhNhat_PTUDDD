import 'package:flutter/material.dart';

import '../controllers/task_controller.dart';
import '../models/task.dart';

import 'bai01_BTTL.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TaskController _taskController = TaskController();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  List<Task> _tasks = [];
  bool _loading = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    try {
      final tasks = await _taskController.fetchTasks();

      if (!mounted) return;
      setState(() {
        _tasks = tasks;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _showMessage('Lỗi tải danh sách: $e');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _addTask() async {
    if (_busy) return;

    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isEmpty) {
      _showMessage('Vui lòng nhập Title');
      return;
    }

    setState(() => _busy = true);

    try {
      final task = Task(title: title, description: description);

      await _taskController.insertTask(task);

      titleController.clear();
      descriptionController.clear();

      await _fetchTasks();
      _showMessage('Đã thêm công việc');
    } catch (e) {
      _showMessage('Không thể thêm công việc: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deleteLastTask() async {
    if (_busy || _tasks.isEmpty) return;

    setState(() => _busy = true);

    try {
      final lastTask = _tasks.last;

      await _taskController.deleteTask(lastTask.id!);
      await _fetchTasks();

      _showMessage('Đã xóa công việc cuối danh sách');
    } catch (e) {
      _showMessage('Không thể xóa công việc: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _editTask(Task task) async {
    final titleInput = TextEditingController(text: task.title);
    final descriptionInput = TextEditingController(text: task.description);

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Chỉnh sửa công việc'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleInput,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionInput,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext, {
                'title': titleInput.text.trim(),
                'description': descriptionInput.text.trim(),
              });
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );

    // Chỉ giải phóng controller sau khi dialog đóng.
    // Không dùng chúng nữa sau bước này.
    if (!mounted || result == null) return;

    if (result['title']!.isEmpty) {
      _showMessage('Title không được để trống');
      return;
    }

    setState(() => _busy = true);

    try {
      final updated = task.copyWith(
        title: result['title'],
        description: result['description'],
      );

      await _taskController.updateTask(updated);
      await _fetchTasks();

      _showMessage('Đã cập nhật công việc');
    } catch (e) {
      _showMessage('Không thể cập nhật: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
        backgroundColor: Colors.lightBlue.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _busy ? null : _addTask,
                    child: const Text('Add Task'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _busy || _tasks.isEmpty ? null : _deleteLastTask,
                    child: const Text('Delete Task'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _tasks.isEmpty
                  ? const Center(child: Text('Chưa có công việc nào'))
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];

                        return Card(
                          color: task.isCompleted
                              ? Colors.green.shade100
                              : Colors.white,
                          child: ListTile(
                            title: Text(task.title),
                            subtitle: Text(task.description),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: _busy ? null : () => _editTask(task),
                            ),
                            onTap: () async {
                              final updated = await Navigator.push<bool>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Bai01BTTL(task: task),
                                ),
                              );

                              if (updated == true) {
                                await _fetchTasks();
                              }
                            },
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
