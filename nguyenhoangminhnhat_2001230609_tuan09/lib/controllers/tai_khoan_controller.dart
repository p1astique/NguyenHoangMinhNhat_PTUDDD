
import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:sqflite/sqflite.dart';

import '../models/tai_khoan.dart';
import '../utils/tai_khoan_database.dart';

class TaiKhoanController {
  final TaiKhoanDatabase _helper = TaiKhoanDatabase.instance;

  final Pbkdf2 _pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 100000,
    bits: 256,
  );

  String _generateSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(
      16,
      (_) => random.nextInt(256),
    );

    return base64Encode(bytes);
  }

  Future<String> _hashPassword(
    String password,
    String salt,
  ) async {
    final key = await _pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: base64Decode(salt),
    );

    final bytes = await key.extractBytes();
    return base64Encode(bytes);
  }

  Future<TaiKhoan?> _findByEmail(String email) async {
    final db = await _helper.database;

    final result = await db.query(
      'taikhoan',
      where: 'email = ?',
      whereArgs: [email.toLowerCase().trim()],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return TaiKhoan.fromMap(result.first);
  }

  // Đăng ký tài khoản.
  Future<String> register(
    String email,
    String password,
  ) async {
    final normalizedEmail = email.toLowerCase().trim();

    if (normalizedEmail.isEmpty || password.isEmpty) {
      return 'Vui lòng nhập email và mật khẩu';
    }

    if (!RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    ).hasMatch(normalizedEmail)) {
      return 'Email không hợp lệ';
    }

    if (password.length < 8) {
      return 'Mật khẩu phải có ít nhất 8 ký tự';
    }

    final existing = await _findByEmail(normalizedEmail);

    if (existing != null) {
      return 'Email này đã được đăng ký';
    }

    final salt = _generateSalt();
    final passwordHash = await _hashPassword(password, salt);

    final account = TaiKhoan(
      email: normalizedEmail,
      passwordHash: passwordHash,
      salt: salt,
    );

    final db = await _helper.database;

    try {
      await db.insert('taikhoan', account.toMap());
      return 'Đăng ký thành công';
    } on DatabaseException {
      return 'Không thể đăng ký. Email có thể đã tồn tại';
    }
  }

  // Đăng nhập tài khoản.
  Future<bool> login(
    String email,
    String password,
  ) async {
    final account = await _findByEmail(email);

    if (account == null) return false;

    final enteredHash = await _hashPassword(
      password,
      account.salt,
    );

    // So sánh toàn bộ dữ liệu băm.
    final a = base64Decode(enteredHash);
    final b = base64Decode(account.passwordHash);

    if (a.length != b.length) return false;

    var difference = 0;
    for (var i = 0; i < a.length; i++) {
      difference |= a[i] ^ b[i];
    }

    return difference == 0;
  }
}
