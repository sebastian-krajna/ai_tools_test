import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';

/// Service responsible for interacting with local storage using Hive
class StorageService {
  static const String _tasksBoxName = 'tasks';
  
  /// Initialize Hive and open necessary boxes
  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(_tasksBoxName);
  }
  
  /// Get all stored tasks
  Future<List<Task>> getTasks() async {
    final box = Hive.box<Map>(_tasksBoxName);
    return box.values
        .map((taskMap) => Task.fromMap(Map<String, dynamic>.from(taskMap)))
        .toList();
  }
  
  /// Save a task to storage
  Future<void> saveTask(Task task) async {
    final box = Hive.box<Map>(_tasksBoxName);
    await box.put(task.id, task.toMap());
  }
  
  /// Delete a task from storage
  Future<void> deleteTask(String id) async {
    final box = Hive.box<Map>(_tasksBoxName);
    await box.delete(id);
  }
  
  /// Update a task in storage
  Future<void> updateTask(Task task) async {
    await saveTask(task);
  }
  
  /// Get a single task by id
  Future<Task?> getTask(String id) async {
    final box = Hive.box<Map>(_tasksBoxName);
    final taskMap = box.get(id);
    if (taskMap == null) return null;
    return Task.fromMap(Map<String, dynamic>.from(taskMap));
  }

  /// Clear all tasks from storage
  Future<void> clearTasks() async {
    final box = Hive.box<Map>(_tasksBoxName);
    await box.clear();
  }
}