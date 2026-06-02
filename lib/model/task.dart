class Task {
  final String id;
  String title;
  bool isCompleted;
  DateTime? reminder;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.reminder,
  });
}
