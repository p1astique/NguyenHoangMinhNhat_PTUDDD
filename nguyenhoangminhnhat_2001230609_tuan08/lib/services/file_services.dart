
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/todo.dart';

class FileService {
  Future<File> get _file async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/todo.txt');
  }

  Future<void> saveTodos(List<Todo> todos) async {
    final file = await _file;
    final data = todos.map((todo) => todo.toFileString()).join('\n');
    await file.writeAsString(data);
  }

  Future<List<Todo>> loadTodos() async {
    try {
      final file = await _file;
      if (!await file.exists()) return [];

      final content = await file.readAsString();
      return content
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .map(Todo.fromString)
          .toList();
    } catch (e) {
      return [];
    }
  }
}
