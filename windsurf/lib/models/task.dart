import 'package:uuid/uuid.dart';

/// Priority levels for tasks
enum TaskPriority {
  low,
  medium,
  high,
}

/// Extension to provide user-friendly names for priority levels
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

/// Model class representing a task in the to-do list
class Task {
  /// Unique identifier for the task
  final String id;
  
  /// Title of the task
  String title;
  
  /// Detailed description of the task
  String description;
  
  /// Priority level of the task
  TaskPriority priority;
  
  /// Due date for the task (can be null if no deadline)
  DateTime? dueDate;
  
  /// Whether the task has been completed
  bool isCompleted;
  
  /// Date when the task was created
  final DateTime createdAt;

  /// Constructor with required fields and optional parameters
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

  /// Creates a copy of this task with the given fields replaced with new values
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

  /// Convert task to a JSON map for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.index,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  /// Create a task from a JSON map
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      priority: TaskPriority.values[json['priority'] as int],
      dueDate: json['dueDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['dueDate'] as int)
          : null,
      isCompleted: json['isCompleted'] as bool,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
    );
  }
}
