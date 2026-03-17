class TaskItem {
  TaskItem({
    required this.title,
    required this.category,
    required this.deadline,
    this.isCompleted = false,
    String? id,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  final String id;
  String title;
  String category;
  DateTime deadline;
  bool isCompleted;
}

class UserProfile {
  UserProfile({
    required this.name,
    required this.email,
    this.avatarSeed = 0,
  });

  String name;
  String email;
  int avatarSeed;
}
