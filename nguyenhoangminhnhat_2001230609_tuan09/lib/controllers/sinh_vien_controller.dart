
import '../models/sinh_vien.dart';
import '../utils/sinh_vien_database.dart';

class SinhVienController {
  final SinhVienDatabase _helper = SinhVienDatabase.instance;

  Future<int> insert(SinhVien sinhVien) async {
    final db = await _helper.database;
    return db.insert('sinhvien', sinhVien.toMap());
  }

  Future<List<SinhVien>> getAll() async {
    final db = await _helper.database;

    final maps = await db.query(
      'sinhvien',
      orderBy: 'id DESC',
    );

    return maps.map(SinhVien.fromMap).toList();
  }

  Future<List<SinhVien>> search(String keyword) async {
    final db = await _helper.database;

    final maps = await db.query(
      'sinhvien',
      where: 'name LIKE ?',
      whereArgs: ['%$keyword%'],
      orderBy: 'id DESC',
    );

    return maps.map(SinhVien.fromMap).toList();
  }

  Future<int> update(SinhVien sinhVien) async {
    if (sinhVien.id == null) {
      throw ArgumentError('Sinh viên chưa có ID');
    }

    final db = await _helper.database;

    return db.update(
      'sinhvien',
      sinhVien.toMap(),
      where: 'id = ?',
      whereArgs: [sinhVien.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _helper.database;

    return db.delete(
      'sinhvien',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
