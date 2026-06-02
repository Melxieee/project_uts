class Task {
  int? id;
  String title;
  bool isCompleted;
  DateTime? reminder;

  Task({
    this.id,
    required this.title,
    this.isCompleted = false,
    this.reminder,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    if (id != null) {
      map['id'] = id;
    }

    map['title'] = title;
    map['isCompleted'] = isCompleted ? 1 : 0;
    map['reminder'] = reminder?.toIso8601String();

    return map;
  }

  Task.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'] ?? '',
        isCompleted = map['isCompleted'] == 1,
        reminder = map['reminder'] != null ? DateTime.tryParse(map['reminder']) : null;
}
