
import '../models/task.dart';
import '../utils/database_helper.dart';

class TaskController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Thêm công việc.
  Future<int> insertTask(Task task) async {
    final db = await _dbHelper.database;
    return db.insert('tasks', task.toMap());
  }

  // Cập nhật công việc.
  Future<int> updateTask(Task task) async {
    if (task.id == null) {
      throw ArgumentError('Task ID không được null');
    }

    final db = await _dbHelper.database;

    return db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Xóa công việc theo ID.
  Future<int> deleteTask(int id) async {
    final db = await _dbHelper.database;

    return db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Kiểm tra tên công việc đã tồn tại.
  Future<bool> isTaskExist(String title) async {
    final db = await _dbHelper.database;

    final result = await db.query(
      'tasks',
      where: 'title = ?',
      whereArgs: [title],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  // Tìm kiếm theo tiêu đề hoặc mô tả.
  Future<List<Task>> searchTasks(String query) async {
    final db = await _dbHelper.database;

    final maps = await db.query(
      'tasks',
      where: 'title LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'id ASC',
    );

    return maps.map(Task.fromMap).toList();
  }

  // Lấy toàn bộ danh sách công việc.
  Future<List<Task>> fetchTasks() async {
    final db = await _dbHelper.database;

    final maps = await db.query(
      'tasks',
      orderBy: 'id ASC',
    );

    return maps.map(Task.fromMap).toList();
  }
}
