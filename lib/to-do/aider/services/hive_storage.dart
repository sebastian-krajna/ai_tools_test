import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import 'storage_service.dart';

/// Hive implementation of the storage service
class HiveStorage implements StorageService {
  static const String _boxName = 'tasks';
  late Box<Task> _taskBox;
  
  @override
  Future<void> init() async {
    // Initialize Hive
    await Hive.initFlutter();
    
    // Register adapters if not already registered
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskAdapter());
    }
    
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(PriorityAdapter());
    }
    
    // Open the box
    _taskBox = await Hive.openBox<Task>(_boxName);
  }
  
  @override
  Future<List<Task>> getTasks() async {
    return _taskBox.values.toList();
  }
  
  @override
  Future<void> saveTasks(List<Task> tasks) async {
    await _taskBox.clear();
    await _taskBox.addAll(tasks);
  }
  
  @override
  Future<void> clearTasks() async {
    await _taskBox.clear();
  }
}
