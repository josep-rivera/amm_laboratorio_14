class Task {
  const Task({
    this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    required this.createdAt,
  });

  final int? id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime createdAt;

  factory Task.fromMap(Map<String, dynamic> map) => Task(
        id: map['id'] as int?,
        title: map['title'] as String,
        description: map['description'] as String?,
        isCompleted: (map['is_completed'] as int) == 1,
        createdAt: DateTime.parse(map['created_at'] as String),
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'title': title,
        'description': description,
        'is_completed': isCompleted ? 1 : 0,
        'created_at': createdAt.toIso8601String(),
      };

  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
