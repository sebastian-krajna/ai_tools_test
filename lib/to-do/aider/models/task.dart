import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'task.g.dart';

/// Priority levels for tasks
@HiveType(typeId: 1)
enum Priority {
  @HiveField(0)
  low,
  
  @HiveField(1)
  medium,
  
  @HiveField(2)
  high
}

/// Task model representing a single to-do item
@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String title;
  
  @HiveField(2)
  String description;
  
  @HiveField(3)
  Priority priority;
  
  @HiveField(4)
  DateTime dueDate;
  
  @HiveField(5)
  bool isCompleted;
  
  @HiveField(6)
  DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.priority = Priority.medium,
    required this.dueDate,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Create a copy of this task with optional new values
  Task copyWith({
    String? id,
    String? title,
    String? description,
    Priority? priority,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Check if the task is overdue
  bool get isOverdue => !isCompleted && dueDate.isBefore(DateTime.now());
  
  /// Get a color representing the task's priority
  Color get priorityColor {
    switch (priority) {
      case Priority.low:
        return Colors.green;
      case Priority.medium:
        return Colors.orange;
      case Priority.high:
        return Colors.red;
    }
  }
  
  /// Get a human-readable string for the priority
  String get priorityText {
    switch (priority) {
      case Priority.low:
        return 'Low';
      case Priority.medium:
        return 'Medium';
      case Priority.high:
        return 'High';
    }
  }
}

// Note: Run 'flutter packages pub run build_runner build'
// to generate the task.g.dart file for Hive
