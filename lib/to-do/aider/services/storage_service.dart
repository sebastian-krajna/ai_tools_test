import '../models/task.dart';

/// Interface for storage implementations
abstract class StorageService {
  /// Initialize the storage service
  Future<void> init();
  
  /// Get all tasks from storage
  Future<List<Task>> getTasks();
  
  /// Save all tasks to storage
  Future<void> saveTasks(List<Task> tasks);
  
  /// Clear all tasks from storage
  Future<void> clearTasks();
}
