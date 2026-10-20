
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ChiTieuDatabase {
  ChiTieuDatabase._internal();

  static final ChiTieuDatabase instance =
      ChiTieuDatabase._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chitieu.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE chitieu (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            noiDung TEXT NOT NULL,
            soTien REAL NOT NULL,
            ghiChu TEXT NOT NULL
          )
        ''');
      },
    );

    return _database!;
  }
}
