
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';
import '../services/file_services.dart';

class Bai02BTHD extends StatefulWidget {
  const Bai02BTHD({super.key});

  @override
  State<Bai02BTHD> createState() => _Bai02BTHDState();
}

class _Bai02BTHDState extends State<Bai02BTHD> {
  final TextEditingController controller = TextEditingController();
  final FileService fileService = FileService();

  List<Todo> todos = [];
  DateTime? selectedTime;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await fileService.loadTodos();
    if (!mounted) return;
    setState(() => todos = data);
  }

  Future<void> addTodo() async {
    final title = controller.text.trim();

    if (title.isEmpty || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập công việc và chọn thời gian'),
        ),
      );
      return;
    }

    final todo = Todo(title: title, time: selectedTime!);
    final updatedTodos = [...todos, todo];

    try {
      await fileService.saveTodos(updatedTodos);
      if (!mounted) return;

      setState(() {
        todos = updatedTodos;
        selectedTime = null;
        controller.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu công việc thành công')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lưu thất bại: $e')),
      );
    }
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

  String formatTime(DateTime time) {
    return DateFormat('dd/MM/yyyy HH:mm').format(time);
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
        title: const Text('Todo App'),
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
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.blue,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedTime == null
                        ? 'Chưa chọn thời gian'
                        : formatTime(selectedTime!),
                  ),
                ),
                ElevatedButton(
                  onPressed: pickDateTime,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
                  ),
                  child: const Text('Chọn thời gian'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addTodo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Lưu'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  final bgColor = colors[index % colors.length];

                  return Card(
                    color: bgColor,
                    child: ListTile(
                      leading: const Icon(Icons.task),
                      title: Text(
                        todo.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(formatTime(todo.time)),
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
