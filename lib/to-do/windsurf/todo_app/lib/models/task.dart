import 'package:uuid/uuid.dart';

/// Represents a task in the to-do list with all its properties
class Task {
  /// Unique identifier for the task
  final String id;
  
  /// Title of the task
  String title;
  
  /// Detailed description of the task
  String description;
  
  /// Priority level of the task (low, medium, high)
  TaskPriority priority;
  
  /// Due date for the task
  DateTime? dueDate;
  
  /// Whether the task has been completed
  bool isCompleted;
  
  /// Creates a new task with the given properties
  Task({
    String? id,
    required this.title,
    this.description = '',
    this.priority = TaskPriority.medium,
    this.dueDate,
    this.isCompleted = false,
  }) : id = id ?? const Uuid().v4();
  
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
    );
  }
  
  /// Converts a task to a map for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.index,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
    };
  }
  
  /// Creates a task from a map (used when retrieving from storage)
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      priority: TaskPriority.values[json['priority']],
      dueDate: json['dueDate'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['dueDate']) 
          : null,
      isCompleted: json['isCompleted'],
    );
  }
}

/// Represents the priority levels for a task
enum TaskPriority {
  low,
  medium,
  high,
}

/// Extension on TaskPriority to provide helper methods
extension TaskPriorityExtension on TaskPriority {
  /// Returns a user-friendly string representation of the priority
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
