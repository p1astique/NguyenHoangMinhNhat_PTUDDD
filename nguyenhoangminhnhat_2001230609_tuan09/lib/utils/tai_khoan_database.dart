
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaiKhoanDatabase {
  TaiKhoanDatabase._internal();

  static final TaiKhoanDatabase instance =
      TaiKhoanDatabase._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'taikhoan.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE taikhoan (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT NOT NULL UNIQUE,
            passwordHash TEXT NOT NULL,
            salt TEXT NOT NULL
          )
        ''');
      },
    );

    return _database!;
  }
}
