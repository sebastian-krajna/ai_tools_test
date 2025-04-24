import 'package:flutter_test/flutter_test.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../services/storage_service.dart';

// Mock implementation of StorageService for testing
class MockStorageService extends StorageService {
  final List<Task> _tasks = [];
  
  @override
  List<Task> getAllTasks() {
    return _tasks;
  }
  
  @override
  Future<void> saveTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    } else {
      _tasks.add(task);
    }
  }
  
  @override
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
  }
  
  @override
  Future<void> clearAllTasks() async {
    _tasks.clear();
  }
  
  @override
  Future<void> init() async {
    // No initialization needed for the mock
  }
}

void main() {
  late MockStorageService mockStorageService;
  late TaskProvider taskProvider;
  
  setUp(() {
    mockStorageService = MockStorageService();
    taskProvider = TaskProvider(mockStorageService);
  });
  
  group('TaskProvider', () {
    test('should add a task', () async {
      // Initial state
      expect(taskProvider.tasks.length, 0);
      
      // Add a task
      final task = Task(title: 'Test Task');
      await taskProvider.addTask(task);
      
      // Verify task was added
      expect(taskProvider.tasks.length, 1);
      expect(taskProvider.tasks[0].title, 'Test Task');
    });
    
    test('should update a task', () async {
      // Add a task
      final task = Task(title: 'Original Title');
      await taskProvider.addTask(task);
      
      // Update the task
      final updatedTask = task.copyWith(title: 'Updated Title');
      await taskProvider.updateTask(updatedTask);
      
      // Verify task was updated
      expect(taskProvider.tasks.length, 1);
      expect(taskProvider.tasks[0].title, 'Updated Title');
    });
    
    test('should delete a task', () async {
      // Add a task
      final task = Task(title: 'Task to Delete');
      await taskProvider.addTask(task);
      
      // Verify task was added
      expect(taskProvider.tasks.length, 1);
      
      // Delete the task
      await taskProvider.deleteTask(task.id);
      
      // Verify task was deleted
      expect(taskProvider.tasks.length, 0);
    });
    
    test('should toggle task completion', () async {
      // Add a task (initially not completed)
      final task = Task(title: 'Toggle Task');
      await taskProvider.addTask(task);
      
      // Verify initial state
      expect(taskProvider.tasks[0].isCompleted, false);
      
      // Toggle completion
      await taskProvider.toggleTaskCompletion(task.id);
      
      // Verify task is now completed
      expect(taskProvider.tasks[0].isCompleted, true);
      
      // Toggle again
      await taskProvider.toggleTaskCompletion(task.id);
      
      // Verify task is now not completed
      expect(taskProvider.tasks[0].isCompleted, false);
    });
    
    test('should sort tasks by priority', () async {
      // Add tasks with different priorities
      final task1 = Task(title: 'High Priority', priority: TaskPriority.high);
      final task2 = Task(title: 'Medium Priority', priority: TaskPriority.medium);
      final task3 = Task(title: 'Low Priority', priority: TaskPriority.low);
      
      await taskProvider.addTask(task2); // Add in random order
      await taskProvider.addTask(task3);
      await taskProvider.addTask(task1);
      
      // Set sort option to priority (ascending)
      taskProvider.setSortOption(TaskSortOption.priority, ascending: true);
      
      // Verify tasks are sorted by priority (low to high)
      expect(taskProvider.tasks[0].priority, TaskPriority.low);
      expect(taskProvider.tasks[1].priority, TaskPriority.medium);
      expect(taskProvider.tasks[2].priority, TaskPriority.high);
      
      // Change sort direction to descending
      taskProvider.setSortOption(TaskSortOption.priority, ascending: false);
      
      // Verify tasks are sorted by priority (high to low)
      expect(taskProvider.tasks[0].priority, TaskPriority.high);
      expect(taskProvider.tasks[1].priority, TaskPriority.medium);
      expect(taskProvider.tasks[2].priority, TaskPriority.low);
    });
  });
}
