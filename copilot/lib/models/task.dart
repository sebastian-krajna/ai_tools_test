import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

// Enum for task priority levels
enum TaskPriority {
  low,
  medium,
  high,
}

// Extension for TaskPriority to get human-readable string
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

// Task model representing a to-do item
class Task {
  final String id;
  String title;
  String description;
  TaskPriority priority;
  DateTime? dueDate;
  bool isCompleted;
  DateTime createdAt;

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

  // Creates a copy of the current task with optional parameter overrides
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

  // Convert Task to Map for Hive storage
  Map<String, dynamic> toMap() {
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

  // Create Task from Map for Hive storage retrieval
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      priority: TaskPriority.values[map['priority']],
      dueDate: map['dueDate'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['dueDate']) 
          : null,
      isCompleted: map['isCompleted'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }
}