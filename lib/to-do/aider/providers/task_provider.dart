import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';

/// Provider class that manages the task list and operations
class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  final _uuid = const Uuid();
  
  // Current sorting method
  SortMethod _sortMethod = SortMethod.dueDate;
  
  // Getters
  List<Task> get tasks => _sortTasks(_tasks);
  List<Task> get completedTasks => _tasks.where((task) => task.isCompleted).toList();
  List<Task> get pendingTasks => _tasks.where((task) => !task.isCompleted).toList();
  SortMethod get sortMethod => _sortMethod;
  
  // Constructor loads tasks from storage
  TaskProvider() {
    _loadTasks();
  }
  
  /// Load tasks from Hive storage
  Future<void> _loadTasks() async {
    try {
      final box = Hive.box<Task>('tasks');
      _tasks = box.values.toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading tasks: $e');
      // Initialize with empty list if there's an error
      _tasks = [];
    }
  }
  
  /// Save tasks to Hive storage
  Future<void> _saveTasks() async {
    try {
      final box = Hive.box<Task>('tasks');
      await box.clear();
      await box.addAll(_tasks);
    } catch (e) {
      debugPrint('Error saving tasks: $e');
    }
  }
  
  /// Add a new task
  Future<void> addTask(String title, String description, Priority priority, DateTime dueDate) async {
    final task = Task(
      id: _uuid.v4(),
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate,
    );
    
    _tasks.add(task);
    await _saveTasks();
    notifyListeners();
  }
  
  /// Update an existing task
  Future<void> updateTask(Task updatedTask) async {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      await _saveTasks();
      notifyListeners();
    }
  }
  
  /// Delete a task
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
    await _saveTasks();
    notifyListeners();
  }
  
  /// Toggle task completion status
  Future<void> toggleTaskCompletion(String id) async {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
      await _saveTasks();
      notifyListeners();
    }
  }
  
  /// Get a task by ID
  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Set the sorting method
  void setSortMethod(SortMethod method) {
    _sortMethod = method;
    notifyListeners();
  }
  
  /// Sort tasks based on the current sort method
  List<Task> _sortTasks(List<Task> taskList) {
    final List<Task> sortedList = List.from(taskList);
    
    switch (_sortMethod) {
      case SortMethod.dueDate:
        sortedList.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
      case SortMethod.priority:
        sortedList.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case SortMethod.title:
        sortedList.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortMethod.status:
        sortedList.sort((a, b) => a.isCompleted == b.isCompleted 
            ? 0 
            : (a.isCompleted ? 1 : -1));
        break;
    }
    
    return sortedList;
  }
}

/// Enum for different sorting methods
enum SortMethod {
  dueDate,
  priority,
  title,
  status,
}
