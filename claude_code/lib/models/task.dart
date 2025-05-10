import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

/// Priority levels for tasks
enum TaskPriority {
  low,
  medium,
  high,
}

/// Task model representing a single to-do item
@HiveType(typeId: 0)
class Task {
  /// Unique identifier for the task
  @HiveField(0)
  final String id;

  /// Task title
  @HiveField(1)
  String title;

  /// Optional detailed description
  @HiveField(2)
  String description;

  /// Priority level of the task
  @HiveField(3)
  TaskPriority priority;

  /// Due date for the task (can be null if no due date)
  @HiveField(4)
  DateTime? dueDate;

  /// Completion status of the task
  @HiveField(5)
  bool isCompleted;

  /// Creation timestamp
  @HiveField(6)
  final DateTime createdAt;

  /// Last update timestamp
  @HiveField(7)
  DateTime updatedAt;

  /// Constructor for creating a new task
  Task({
    String? id,
    required this.title,
    this.description = '',
    this.priority = TaskPriority.medium,
    this.dueDate,
    this.isCompleted = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Create a copy of the task with updated fields
  Task copyWith({
    String? title,
    String? description,
    TaskPriority? priority,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Toggle completion status of the task
  Task toggleCompleted() {
    return copyWith(
      isCompleted: !isCompleted,
      updatedAt: DateTime.now(),
    );
  }

  /// Helper to check if task is overdue
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return dueDate!.isBefore(DateTime.now());
  }

  /// Helper to check if task is due today
  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year &&
        dueDate!.month == now.month &&
        dueDate!.day == now.day;
  }

  /// Helper to check if task is due soon (within 2 days)
  bool get isDueSoon {
    if (dueDate == null || isCompleted) return false;
    final now = DateTime.now();
    final difference = dueDate!.difference(now).inDays;
    return difference >= 0 && difference <= 2 && !isDueToday;
  }
}

/// Extension to convert TaskPriority to/from string
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

  static TaskPriority fromString(String value) {
    switch (value.toLowerCase()) {
      case 'low':
        return TaskPriority.low;
      case 'medium':
        return TaskPriority.medium;
      case 'high':
        return TaskPriority.high;
      default:
        return TaskPriority.medium;
    }
  }
}