
class HomeworkTodo {
  final int id;
  final String title;
  final DateTime? reminderTime;
  final bool isCompleted;

  const HomeworkTodo({
    required this.id,
    required this.title,
    this.reminderTime,
    this.isCompleted = false,
  });

  HomeworkTodo copyWith({
    String? title,
    DateTime? reminderTime,
    bool? isCompleted,
  }) {
    return HomeworkTodo(
      id: id,
      title: title ?? this.title,
      reminderTime: reminderTime ?? this.reminderTime,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'reminderTime': reminderTime?.toIso8601String(),
        'isCompleted': isCompleted,
      };

  factory HomeworkTodo.fromJson(Map<String, dynamic> json) {
    return HomeworkTodo(
      id: json['id'] as int,
      title: json['title'] as String,
      reminderTime: json['reminderTime'] == null
          ? null
          : DateTime.parse(json['reminderTime'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}
