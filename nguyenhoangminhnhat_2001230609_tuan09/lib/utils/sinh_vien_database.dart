
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SinhVienDatabase {
  SinhVienDatabase._internal();

  static final SinhVienDatabase instance =
      SinhVienDatabase._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'sinhvien.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE sinhvien (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL
          )
        ''');
      },
    );

    return _database!;
  }
}
