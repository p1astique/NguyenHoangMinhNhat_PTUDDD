
import '../models/chi_tieu.dart';
import '../utils/chi_tieu_database.dart';

class ChiTieuController {
  final ChiTieuDatabase _helper = ChiTieuDatabase.instance;

  Future<int> insert(ChiTieu chiTieu) async {
    final db = await _helper.database;
    return db.insert('chitieu', chiTieu.toMap());
  }

  Future<List<ChiTieu>> getAll() async {
    final db = await _helper.database;

    final maps = await db.query(
      'chitieu',
      orderBy: 'id DESC',
    );

    return maps.map(ChiTieu.fromMap).toList();
  }

  Future<int> update(ChiTieu chiTieu) async {
    if (chiTieu.id == null) {
      throw ArgumentError('Khoản chi chưa có ID');
    }

    final db = await _helper.database;

    return db.update(
      'chitieu',
      chiTieu.toMap(),
      where: 'id = ?',
      whereArgs: [chiTieu.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _helper.database;

    return db.delete(
      'chitieu',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
