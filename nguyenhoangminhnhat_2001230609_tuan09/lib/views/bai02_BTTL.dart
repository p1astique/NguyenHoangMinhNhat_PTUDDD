import 'package:flutter/material.dart';

import '../controllers/sinh_vien_controller.dart';
import '../models/sinh_vien.dart';

class Bai02BTTL extends StatefulWidget {
  const Bai02BTTL({super.key});

  @override
  State<Bai02BTTL> createState() => _Bai02BTTLState();
}

class _Bai02BTTLState extends State<Bai02BTTL> {
  final controller = SinhVienController();
  final searchController = TextEditingController();

  List<SinhVien> students = [];
  bool loading = true;
  bool busy = false;
  int _searchGeneration = 0;

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  Future<void> loadStudents() async {
    final generation = ++_searchGeneration;
    try {
      final result = await controller.search(searchController.text.trim());

      if (!mounted || generation != _searchGeneration) return;
      setState(() {
        students = result;
        loading = false;
      });
    } catch (e) {
      if (!mounted || generation != _searchGeneration) return;
      setState(() => loading = false);
      showMessage('Không thể tải sinh viên: $e');
    }
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<Map<String, String>?> showStudentDialog({SinhVien? student}) {
    return showDialog<Map<String, String>>(
      context: context,
      builder: (_) => _StudentFormDialog(student: student),
    );
  }

  Future<void> addStudent() async {
    if (busy) return;

    final data = await showStudentDialog();
    if (data == null || !mounted) return;

    final name = data['name']?.trim() ?? '';
    final email = data['email']?.trim() ?? '';
    if (name.isEmpty || email.isEmpty) {
      showMessage('Vui lòng nhập đầy đủ tên và email');
      return;
    }

    setState(() => busy = true);
    try {
      await controller.insert(SinhVien(name: name, email: email));
      await loadStudents();
      showMessage('Đã thêm sinh viên');
    } catch (e) {
      showMessage('Không thể thêm sinh viên: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> editStudent(SinhVien student) async {
    final data = await showStudentDialog(student: student);
    if (data == null || !mounted) return;

    if (data['name']!.isEmpty || data['email']!.isEmpty) {
      showMessage('Vui lòng nhập đầy đủ tên và email');
      return;
    }

    setState(() => busy = true);

    try {
      await controller.update(
        SinhVien(id: student.id, name: data['name']!, email: data['email']!),
      );

      await loadStudents();
      showMessage('Đã cập nhật sinh viên');
    } catch (e) {
      showMessage('Không thể cập nhật sinh viên: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> deleteStudent(SinhVien student) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xóa sinh viên'),
        content: Text('Em có chắc muốn xóa "${student.name}" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => busy = true);

    try {
      await controller.delete(student.id!);
      await loadStudents();
      showMessage('Đã xóa sinh viên');
    } catch (e) {
      showMessage('Không thể xóa sinh viên: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý sinh viên'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: (_) => loadStudents(),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm sinh viên...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    loadStudents();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : students.isEmpty
                ? const Center(child: Text('Không có sinh viên nào'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];

                      return Card(
                        color: Colors.blueGrey.shade100,
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(student.name),
                          subtitle: Text(student.email),
                          onTap: busy ? null : () => editStudent(student),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: busy
                                ? null
                                : () => deleteStudent(student),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: busy ? null : addStudent,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _StudentFormDialog extends StatefulWidget {
  final SinhVien? student;

  const _StudentFormDialog({this.student});

  @override
  State<_StudentFormDialog> createState() => _StudentFormDialogState();
}

class _StudentFormDialogState extends State<_StudentFormDialog> {
  late final TextEditingController nameInput;
  late final TextEditingController emailInput;

  @override
  void initState() {
    super.initState();

    nameInput = TextEditingController(text: widget.student?.name ?? '');

    emailInput = TextEditingController(text: widget.student?.email ?? '');
  }

  @override
  void dispose() {
    nameInput.dispose();
    emailInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.student == null
            ? 'Thêm Sinh Viên'
            : 'Thông tin chi tiết của sinh viên',
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameInput,
              decoration: const InputDecoration(labelText: 'Tên sinh viên'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailInput,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'name': nameInput.text.trim(),
              'email': emailInput.text.trim(),
            });
          },
          child: Text(widget.student == null ? 'Lưu' : 'Cập nhật'),
        ),
      ],
    );
  }
}
