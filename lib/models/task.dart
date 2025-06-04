class Task {
  final String id;
  final String title;
  final String description;
  final String userId;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.userId,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    String? userId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'userId': userId,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
      userId: map['userId'],
    );
  }
}
