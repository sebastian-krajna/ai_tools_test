import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';

/// Service responsible for handling data persistence using Hive
class StorageService {
  static const String _tasksBoxName = 'tasks';
  late Box<Task> _tasksBox;

  /// Initialize Hive and open the tasks box
  Future<void> init() async {
    await Hive.initFlutter();
    
    // Register the Task adapter
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(TaskPriorityAdapter());
    
    // Open the tasks box
    _tasksBox = await Hive.openBox<Task>(_tasksBoxName);
  }

  /// Get all tasks from storage
  List<Task> getAllTasks() {
    return _tasksBox.values.toList();
  }

  /// Save a task to storage
  Future<void> saveTask(Task task) async {
    await _tasksBox.put(task.id, task);
  }

  /// Delete a task from storage
  Future<void> deleteTask(String id) async {
    await _tasksBox.delete(id);
  }

  /// Clear all tasks from storage
  Future<void> clearAllTasks() async {
    await _tasksBox.clear();
  }
}

/// Adapter for TaskPriority enum to be used with Hive
class TaskPriorityAdapter extends TypeAdapter<TaskPriority> {
  @override
  final int typeId = 1;

  @override
  TaskPriority read(BinaryReader reader) {
    return TaskPriority.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, TaskPriority obj) {
    writer.writeInt(obj.index);
  }
}

/// Adapter for Task class to be used with Hive
class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    
    return Task(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      priority: fields[3] as TaskPriority,
      dueDate: fields[4] as DateTime?,
      isCompleted: fields[5] as bool,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.priority)
      ..writeByte(4)
      ..write(obj.dueDate)
      ..writeByte(5)
      ..write(obj.isCompleted)
      ..writeByte(6)
      ..write(obj.createdAt);
  }
}
