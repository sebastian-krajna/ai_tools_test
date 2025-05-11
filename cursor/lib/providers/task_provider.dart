import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  late Box<Task> _taskBox;
  List<Task> _tasks = [];
  bool _isInitialized = false;

  // Getter for all tasks
  List<Task> get tasks => _tasks;
  
  // Getter for completed tasks
  List<Task> get completedTasks => _tasks.where((task) => task.isCompleted).toList();
  
  // Getter for incomplete tasks
  List<Task> get incompleteTasks => _tasks.where((task) => !task.isCompleted).toList();

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _taskBox = await Hive.openBox<Task>('tasks');
    _loadTasks();
    _isInitialized = true;
  }

  void _loadTasks() {
    _tasks = _taskBox.values.toList();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _taskBox.put(task.id, task);
    _loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await _taskBox.put(task.id, task);
    _loadTasks();
  }

  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
    _loadTasks();
  }

  Future<void> toggleTaskCompletion(String id) async {
    final task = _taskBox.get(id);
    if (task != null) {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await _taskBox.put(id, updatedTask);
      _loadTasks();
    }
  }

  List<Task> getSortedTasks(SortOption sortOption) {
    final taskList = List<Task>.from(_tasks);
    
    switch (sortOption) {
      case SortOption.priority:
        taskList.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case SortOption.dueDate:
        taskList.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
      case SortOption.completion:
        taskList.sort((a, b) => a.isCompleted == b.isCompleted 
          ? 0 
          : (a.isCompleted ? 1 : -1));
        break;
      case SortOption.creationDate:
        taskList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }
    
    return taskList;
  }
}

enum SortOption {
  priority,
  dueDate,
  completion,
  creationDate,
} 