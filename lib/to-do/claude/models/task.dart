import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'task.g.dart';

/// Priority levels for tasks
@HiveType(typeId: 1)
enum TaskPriority {
  @HiveField(0)
  low,
  
  @HiveField(1)
  medium,
  
  @HiveField(2)
  high
}

/// Extension to provide helpful methods for TaskPriority enum
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
  
  String get emoji {
    switch (this) {
      case TaskPriority.low:
        return '🟢';
      case TaskPriority.medium:
        return '🟡';
      case TaskPriority.high:
        return '🔴';
    }
  }
}

/// Task model representing a single to-do item
@HiveType(typeId: 0)
class Task {
  /// Unique identifier for the task
  @HiveField(0)
  final String id;
  
  /// Title of the task
  @HiveField(1)
  final String title;
  
  /// Optional detailed description of the task
  @HiveField(2)
  final String description;
  
  /// Priority level of the task
  @HiveField(3)
  final TaskPriority priority;
  
  /// Optional due date for the task
  @HiveField(4)
  final DateTime? dueDate;
  
  /// Whether the task is marked as completed
  @HiveField(5)
  final bool isCompleted;
  
  /// When the task was created
  @HiveField(6)
  final DateTime createdAt;
  
  /// Constructor for creating a new Task
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
  
  /// Format the due date in a user-friendly way or return null if no due date
  String? get formattedDueDate {
    if (dueDate == null) return null;
    return DateFormat.yMMMd().format(dueDate!);
  }
  
  /// Check if the task is overdue (due date is in the past and not completed)
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    final now = DateTime.now();
    return dueDate!.isBefore(now);
  }
  
  /// Check if the task is due soon (due within the next day and not completed)
  bool get isDueSoon {
    if (dueDate == null || isCompleted) return false;
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    return dueDate!.isAfter(now) && dueDate!.isBefore(tomorrow);
  }
}