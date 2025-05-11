import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

/// Priority levels for tasks
enum TaskPriority {
  low,
  medium,
  high,
}

/// Extension to get display name for task priority
extension TaskPriorityExtension on TaskPriority {
  String get name {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }
}

/// Task model representing a to-do item
@HiveType(typeId: 0)
class Task {
  /// Unique identifier for the task
  @HiveField(0)
  final String id;

  /// Title of the task
  @HiveField(1)
  String title;

  /// Optional description of the task
  @HiveField(2)
  String description;

  /// Priority level of the task
  @HiveField(3)
  TaskPriority priority;

  /// Due date for the task
  @HiveField(4)
  DateTime? dueDate;

  /// Whether the task is completed
  @HiveField(5)
  bool isCompleted;

  /// Creation date of the task
  @HiveField(6)
  final DateTime createdAt;

  /// Constructor for creating a new task
  Task({
    String? id,
    required this.title,
    this.description = '',
    this.priority = TaskPriority.medium,
    this.dueDate,
    this.isCompleted = false,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  /// Create a copy of this task with optional new values
  Task copyWith({
    String? title,
    String? description,
    TaskPriority? priority,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }
}
