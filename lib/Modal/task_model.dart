class Task {
  final String name;
  final String title;
  final String description;
  String groupvalue;
  bool isCompleted;
  final DateTime dateTime;
  final String? imageUrl;
  final String? audioUrl;
  final String? videoUrl;

  Task(
      {required this.name,
      required this.description,
      required this.title,
      required this.isCompleted,
      required this.groupvalue,
      required this.dateTime,
      required this.imageUrl,
      required this.audioUrl,
      required this.videoUrl});

  void isDone() {
    isCompleted = !isCompleted;
  }
}
