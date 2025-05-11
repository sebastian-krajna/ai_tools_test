import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

enum TaskPriority {
  low,
  medium,
  high,
}

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  TaskPriority priority;

  @HiveField(4)
  DateTime dueDate;

  @HiveField(5)
  bool isCompleted;

  @HiveField(6)
  DateTime createdAt;

  Task({
    String? id,
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
    this.isCompleted = false,
  }) : 
    id = id ?? const Uuid().v4(),
    createdAt = DateTime.now();

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
} 