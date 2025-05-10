import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/services/storage_service.dart';

class MockStorageService implements StorageService {
  List<Task> _tasks = [];
  
  @override
  Future<void> init() async {
    // No-op for testing
  }
  
  @override
  List<Task> getAllTasks() {
    return _tasks;
  }
  
  @override
  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<void> saveTask(Task task) async {
    // Remove existing task with the same ID if it exists
    _tasks.removeWhere((t) => t.id == task.id);
    // Add the new task
    _tasks.add(task);
  }
  
  @override
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
  }
  
  @override
  Future<void> deleteAllTasks() async {
    _tasks = [];
  }
  
  @override
  Future<void> dispose() async {
    // No-op for testing
  }
}

void main() {
  group('TaskProvider', () {
    late MockStorageService mockStorageService;
    late TaskProvider taskProvider;
    
    setUp(() {
      mockStorageService = MockStorageService();
      taskProvider = TaskProvider(mockStorageService);
    });
    
    test('initial state should be empty', () {
      expect(taskProvider.tasks, isEmpty);
    });
    
    test('addTask should add a task to storage and update tasks list', () async {
      final task = Task(title: 'Test Task');
      
      await taskProvider.addTask(task);
      
      expect(taskProvider.tasks.length, 1);
      expect(taskProvider.tasks.first.title, 'Test Task');
    });
    
    test('updateTask should update an existing task', () async {
      // Add a task
      final task = Task(title: 'Original Task');
      await taskProvider.addTask(task);
      
      // Update the task
      final updatedTask = task.copyWith(title: 'Updated Task');
      await taskProvider.updateTask(updatedTask);
      
      // Verify the task was updated
      expect(taskProvider.tasks.length, 1);
      expect(taskProvider.tasks.first.title, 'Updated Task');
    });
    
    test('toggleTaskCompletion should toggle the completed state', () async {
      // Add a task
      final task = Task(title: 'Test Task');
      await taskProvider.addTask(task);
      
      // Toggle completion
      await taskProvider.toggleTaskCompletion(task.id);
      
      // Verify the task is now completed
      expect(taskProvider.tasks.first.isCompleted, true);
      
      // Toggle again
      await taskProvider.toggleTaskCompletion(task.id);
      
      // Verify the task is now uncompleted
      expect(taskProvider.tasks.first.isCompleted, false);
    });
    
    test('deleteTask should remove a task', () async {
      // Add a task
      final task = Task(title: 'Test Task');
      await taskProvider.addTask(task);
      
      // Verify the task was added
      expect(taskProvider.tasks.length, 1);
      
      // Delete the task
      await taskProvider.deleteTask(task.id);
      
      // Verify the task was removed
      expect(taskProvider.tasks, isEmpty);
    });
    
    test('getTaskById should return the correct task', () async {
      // Add two tasks
      final task1 = Task(title: 'Task 1');
      final task2 = Task(title: 'Task 2');
      
      await taskProvider.addTask(task1);
      await taskProvider.addTask(task2);
      
      // Get task by ID
      final retrievedTask = taskProvider.getTaskById(task1.id);
      
      // Verify the correct task was retrieved
      expect(retrievedTask, isNotNull);
      expect(retrievedTask!.title, 'Task 1');
    });
    
    test('setSort should update the sort option', () {
      // Default sort is TaskSort.createdAt
      expect(taskProvider.currentSort, TaskSort.createdAt);
      
      // Change sort to priority
      taskProvider.setSort(TaskSort.priority);
      
      // Verify sort was updated
      expect(taskProvider.currentSort, TaskSort.priority);
    });
    
    test('setFilter should update the filter option', () {
      // Default filter is TaskFilter.all
      expect(taskProvider.currentFilter, TaskFilter.all);
      
      // Change filter to completed
      taskProvider.setFilter(TaskFilter.completed);
      
      // Verify filter was updated
      expect(taskProvider.currentFilter, TaskFilter.completed);
    });
    
    test('tasks should be filtered according to currentFilter', () async {
      // Add completed and active tasks
      final completedTask = Task(
        title: 'Completed Task',
        isCompleted: true,
      );
      
      final activeTask = Task(
        title: 'Active Task',
        isCompleted: false,
      );
      
      await taskProvider.addTask(completedTask);
      await taskProvider.addTask(activeTask);
      
      // With filter set to all, both tasks should be returned
      expect(taskProvider.tasks.length, 2);
      
      // Set filter to completed
      taskProvider.setFilter(TaskFilter.completed);
      
      // Only completed tasks should be returned
      expect(taskProvider.tasks.length, 1);
      expect(taskProvider.tasks.first.title, 'Completed Task');
      
      // Set filter to active
      taskProvider.setFilter(TaskFilter.active);
      
      // Only active tasks should be returned
      expect(taskProvider.tasks.length, 1);
      expect(taskProvider.tasks.first.title, 'Active Task');
    });
    
    test('tasks should be sorted according to currentSort', () async {
      // Add tasks with various properties
      final highPriorityTask = Task(
        title: 'High Priority',
        priority: TaskPriority.high,
      );
      
      final mediumPriorityTask = Task(
        title: 'Medium Priority',
        priority: TaskPriority.medium,
      );
      
      final lowPriorityTask = Task(
        title: 'Low Priority',
        priority: TaskPriority.low,
      );
      
      await taskProvider.addTask(lowPriorityTask);
      await taskProvider.addTask(highPriorityTask);
      await taskProvider.addTask(mediumPriorityTask);
      
      // Sort by priority (default is descending)
      taskProvider.setSort(TaskSort.priority);
      
      // Tasks should be sorted in descending priority order
      expect(taskProvider.tasks[0].priority, TaskPriority.high);
      expect(taskProvider.tasks[1].priority, TaskPriority.medium);
      expect(taskProvider.tasks[2].priority, TaskPriority.low);
      
      // Toggle sort direction
      taskProvider.setSort(TaskSort.priority);
      
      // Tasks should now be sorted in ascending priority order
      expect(taskProvider.tasks[0].priority, TaskPriority.low);
      expect(taskProvider.tasks[1].priority, TaskPriority.medium);
      expect(taskProvider.tasks[2].priority, TaskPriority.high);
    });
  });
}