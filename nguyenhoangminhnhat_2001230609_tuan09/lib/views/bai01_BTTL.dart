
import 'package:flutter/material.dart';

import '../models/task.dart';
import '../controllers/task_controller.dart';

class Bai01BTTL extends StatefulWidget {
  final Task task;

  const Bai01BTTL({
    super.key,
    required this.task,
  });

  @override
  State<Bai01BTTL> createState() => _Bai01BTTLState();
}

class _Bai01BTTLState extends State<Bai01BTTL> {
  final TaskController _controller = TaskController();

  late bool isCompleted;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    isCompleted = widget.task.isCompleted;
  }

  Future<void> updateCompleted(bool? value) async {
    if (value == null || isSaving) return;

    setState(() => isSaving = true);

    try {
      final updatedTask = widget.task.copyWith(
        isCompleted: value,
      );

      await _controller.updateTask(updatedTask);

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể cập nhật trạng thái: $e'),
        ),
      );

      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        backgroundColor: Colors.lightBlue.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Title',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(widget.task.title),

            const SizedBox(height: 20),

            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(widget.task.description),

            const SizedBox(height: 20),

            Row(
              children: [
                const Text(
                  'Completed',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Checkbox(
                  value: isCompleted,
                  onChanged: isSaving ? null : updateCompleted,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
