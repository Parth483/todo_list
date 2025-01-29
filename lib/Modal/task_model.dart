class Task {
  final String name;
  final String title;
  final String description;
  String groupvalue;
  bool isCompleted;
  final DateTime dateTime;

  Task(
      {required this.name,
      required this.description,
      required this.title,
      required this.isCompleted,
      required this.groupvalue,
      required this.dateTime});

  void isDone() {
    isCompleted = !isCompleted;
  }
}
