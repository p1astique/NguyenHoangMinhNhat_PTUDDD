
class SinhVien {
  final int? id;
  final String name;
  String email;

  SinhVien({
    this.id,
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
    };
  }

  factory SinhVien.fromMap(Map<String, dynamic> map) {
    return SinhVien(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }
}
