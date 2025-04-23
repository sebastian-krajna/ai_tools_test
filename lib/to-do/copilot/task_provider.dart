import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'task_model.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = true;
  String _sortBy = 'dueDate'; // Default sort by due date

  List<Task> get tasks => _getSortedTasks();
  bool get isLoading => _isLoading;
  String get sortBy => _sortBy;

  TaskProvider() {
    _initHive();
  }

  Future<void> _initHive() async {
    try {
      // Register adapters if not already registered
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(TaskAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(TaskPriorityAdapter());
      }

      await Hive.openBox<Task>('tasks');
      await loadTasks();
    } catch (e) {
      debugPrint('Error initializing Hive: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      final box = Hive.box<Task>('tasks');
      _tasks = box.values.toList();
    } catch (e) {
      debugPrint('Error loading tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(Task task) async {
    try {
      final box = Hive.box<Task>('tasks');
      await box.put(task.id, task);
      _tasks.add(task);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding task: $e');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      final box = Hive.box<Task>('tasks');
      await box.put(task.id, task);
      
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating task: $e');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final box = Hive.box<Task>('tasks');
      await box.delete(id);
      
      _tasks.removeWhere((task) => task.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting task: $e');
    }
  }

  Future<void> toggleTaskCompletion(String id) async {
    try {
      final index = _tasks.indexWhere((task) => task.id == id);
      if (index != -1) {
        final task = _tasks[index];
        final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
        
        await updateTask(updatedTask);
      }
    } catch (e) {
      debugPrint('Error toggling task completion: $e');
    }
  }

  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  List<Task> _getSortedTasks() {
    final sortedTasks = List<Task>.from(_tasks);
    
    switch (_sortBy) {
      case 'dueDate':
        sortedTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
      case 'priority':
        sortedTasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case 'completion':
        sortedTasks.sort((a, b) => a.isCompleted ? 1 : -1);
        break;
      case 'title':
        sortedTasks.sort((a, b) => a.title.compareTo(b.title));
        break;
    }
    
    return sortedTasks;
  }
}