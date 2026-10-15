
class Vocabulary {
  final String word;
  final String meaning;
  final int notificationId;
  final DateTime reminderTime;

  Vocabulary({
    required this.word,
    required this.meaning,
    required this.notificationId,
    required this.reminderTime,
  });

  Map<String, dynamic> toJson() => {
    'word': word,
    'meaning': meaning,
    'notificationId': notificationId,
    'reminderTime': reminderTime.toIso8601String(),
  };

  factory Vocabulary.fromJson(Map<String, dynamic> json) {
    return Vocabulary(
      word: json['word'] as String,
      meaning: json['meaning'] as String,
      notificationId: json['notificationId'] as int,
      reminderTime: DateTime.parse(json['reminderTime'] as String),
    );
  }
}
