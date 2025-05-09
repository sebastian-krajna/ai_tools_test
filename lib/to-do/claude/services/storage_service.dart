import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import '../utils/constants.dart';

/// Service to handle storage operations for the tasks
class StorageService {
  late Box<Task> _tasksBox;
  
  /// Initialize Hive storage and open boxes
  Future<void> init() async {
    // Initialize Hive and register adapters
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(TaskPriorityAdapter());
    
    // Open the tasks box
    _tasksBox = await Hive.openBox<Task>(AppConstants.tasksBoxName);
  }
  
  /// Get all tasks from storage
  List<Task> getAllTasks() {
    return _tasksBox.values.toList();
  }
  
  /// Add a new task to storage
  Future<void> addTask(Task task) async {
    await _tasksBox.put(task.id, task);
  }
  
  /// Update existing task
  Future<void> updateTask(Task task) async {
    await _tasksBox.put(task.id, task);
  }
  
  /// Delete a task from storage
  Future<void> deleteTask(String taskId) async {
    await _tasksBox.delete(taskId);
  }
  
  /// Get a task by ID
  Task? getTask(String taskId) {
    return _tasksBox.get(taskId);
  }
  
  /// Delete all tasks
  Future<void> deleteAllTasks() async {
    await _tasksBox.clear();
  }
  
  /// Close the storage when the app is terminated
  Future<void> close() async {
    await _tasksBox.close();
  }
}