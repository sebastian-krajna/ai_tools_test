import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/task_priority_adapter.dart';

/// Service responsible for handling task storage using Hive
class StorageService {
  static const String _tasksBoxName = 'tasks';
  late Box<Task> _tasksBox;
  
  /// Initialize Hive and open the tasks box
  Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskAdapter());
    }
    
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TaskPriorityAdapter());
    }
    
    // Open tasks box
    _tasksBox = await Hive.openBox<Task>(_tasksBoxName);
  }
  
  /// Get all tasks
  List<Task> getAllTasks() {
    return _tasksBox.values.toList();
  }
  
  /// Get task by ID
  Task? getTaskById(String id) {
    return _tasksBox.values.firstWhere(
      (task) => task.id == id,
      orElse: () => throw Exception('Task not found'),
    );
  }
  
  /// Save a task (create or update)
  Future<void> saveTask(Task task) async {
    try {
      await _tasksBox.put(task.id, task);
    } catch (e) {
      throw Exception('Failed to save task: $e');
    }
  }
  
  /// Delete a task by ID
  Future<void> deleteTask(String id) async {
    try {
      // Find the key associated with this task ID
      final taskKey = _tasksBox.keys.firstWhere(
        (key) => _tasksBox.get(key)?.id == id,
        orElse: () => throw Exception('Task not found'),
      );
      
      await _tasksBox.delete(taskKey);
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }
  
  /// Delete all tasks
  Future<void> deleteAllTasks() async {
    await _tasksBox.clear();
  }
  
  /// Close the Hive box
  Future<void> dispose() async {
    await _tasksBox.close();
  }
}