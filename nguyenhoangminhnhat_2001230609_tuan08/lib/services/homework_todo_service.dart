
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import '../models/homework_todo.dart';

class HomeworkTodoService {
  Future<File> get _file async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/homework_todos.json');
  }

  Future<List<HomeworkTodo>> loadTodos() async {
    final file = await _file;

    if (!await file.exists()) {
      return [];
    }

    final content = await file.readAsString();
    if (content.trim().isEmpty) return [];

    final decoded = jsonDecode(content) as List<dynamic>;

    return decoded
        .map(
          (item) => HomeworkTodo.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<void> saveTodos(List<HomeworkTodo> todos) async {
    final file = await _file;

    final content = jsonEncode(
      todos.map((todo) => todo.toJson()).toList(),
    );

    await file.writeAsString(content, flush: true);
  }
}
