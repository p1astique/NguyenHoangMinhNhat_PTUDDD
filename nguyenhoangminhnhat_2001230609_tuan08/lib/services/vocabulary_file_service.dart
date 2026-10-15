
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/vocabulary.dart';

class VocabularyFileService {
  Future<File> get _file async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/vocabulary.json');
  }

  Future<List<Vocabulary>> load() async {
    final file = await _file;
    if (!await file.exists()) return [];

    final content = await file.readAsString();
    if (content.trim().isEmpty) return [];

    final data = jsonDecode(content) as List<dynamic>;
    return data
        .map((item) => Vocabulary.fromJson(
              Map<String, dynamic>.from(item as Map),
            ))
        .toList();
  }

  Future<void> save(List<Vocabulary> words) async {
    final file = await _file;
    await file.writeAsString(
      jsonEncode(words.map((word) => word.toJson()).toList()),
    );
  }
}
