import '../../domain/models/task.dart';

class TaskModel {
  const TaskModel({
    this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.createdAt,
  });

  final int? id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime createdAt;

  factory TaskModel.fromMap(Map<String, dynamic> map) => TaskModel(
        id: map['id'] as int?,
        title: map['title'] as String,
        description: map['description'] as String?,
        isCompleted: (map['is_completed'] as int) == 1,
        createdAt: DateTime.parse(map['created_at'] as String),
      );

  factory TaskModel.fromDomain(Task task) => TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        isCompleted: task.isCompleted,
        createdAt: task.createdAt,
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'title': title,
        'description': description,
        'is_completed': isCompleted ? 1 : 0,
        'created_at': createdAt.toIso8601String(),
      };

  Task toDomain() => Task(
        id: id,
        title: title,
        description: description,
        isCompleted: isCompleted,
        createdAt: createdAt,
      );
}
