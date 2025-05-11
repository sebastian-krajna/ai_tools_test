import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/services/storage_service.dart';

// Mock implementation of StorageService for testing
class MockStorageService implements StorageService {
  List<Task> _tasks = [];
  
  @override
  Future<void> init() async {}
  
  @override
  Future<List<Task>> getTasks() async {
    return _tasks;
  }
  
  @override
  Future<void> saveTask(Task task) async {
    _tasks.add(task);
  }
  
  @override
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
  }
  
  @override
  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }
  }
  
  @override
  Future<Task?> getTask(String id) async {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (_) {
      return null;
    }
  }
  
  @override
  Future<void> clearTasks() async {
    _tasks = [];
  }
  
  // Helper method for tests to pre-populate tasks
  void setTasks(List<Task> tasks) {
    _tasks = tasks;
  }
}

void main() {
  group('TaskProvider Tests', () {
    late MockStorageService mockStorageService;
    late TaskProvider taskProvider;
    
    setUp(() {
      mockStorageService = MockStorageService();
      taskProvider = TaskProvider(mockStorageService);
    });
    
    test('Initial state', () {
      expect(taskProvider.tasks, isEmpty);
      expect(taskProvider.sortOption, TaskSortOption.creationDate);
      expect(taskProvider.sortAscending, false);
    });
    
    test('Load tasks', () async {
      // Setup pre-existing tasks
      final task1 = Task(title: 'Task 1');
      final task2 = Task(title: 'Task 2');
      mockStorageService.setTasks([task1, task2]);
      
      // Load tasks
      await taskProvider.loadTasks();
      
      // Verify tasks are loaded
      expect(taskProvider.tasks.length, 2);
      expect(taskProvider.tasks[0].title, 'Task 1');
      expect(taskProvider.tasks[1].title, 'Task 2');
    });
    
    test('Add task', () async {
      // Add a task
      final task = Task(title: 'New Task');
      await taskProvider.addTask(task);
      
      // Verify task is added to provider and storage
      expect(taskProvider.tasks.length, 1);
      expect(taskProvider.tasks[0].title, 'New Task');
      
      final storedTasks = await mockStorageService.getTasks();
      expect(storedTasks.length, 1);
      expect(storedTasks[0].title, 'New Task');
    });
    
    test('Update task', () async {
      // Add a task
      final task = Task(title: 'Original Title');
      await taskProvider.addTask(task);
      
      // Update the task
      final updatedTask = task.copyWith(
        title: 'Updated Title',
        description: 'New description',
      );
      await taskProvider.updateTask(updatedTask);
      
      // Verify task is updated in provider and storage
      expect(taskProvider.tasks.length, 1);
      expect(taskProvider.tasks[0].title, 'Updated Title');
      expect(taskProvider.tasks[0].description, 'New description');
      
      final storedTasks = await mockStorageService.getTasks();
      expect(storedTasks.length, 1);
      expect(storedTasks[0].title, 'Updated Title');
      expect(storedTasks[0].description, 'New description');
    });
    
    test('Delete task', () async {
      // Add a task
      final task = Task(title: 'Task to Delete');
      await taskProvider.addTask(task);
      expect(taskProvider.tasks.length, 1);
      
      // Delete the task
      await taskProvider.deleteTask(task.id);
      
      // Verify task is deleted from provider and storage
      expect(taskProvider.tasks, isEmpty);
      
      final storedTasks = await mockStorageService.getTasks();
      expect(storedTasks, isEmpty);
    });
    
    test('Toggle task completion', () async {
      // Add a task
      final task = Task(title: 'Task to Toggle');
      await taskProvider.addTask(task);
      expect(taskProvider.tasks[0].isCompleted, false);
      
      // Toggle completion
      await taskProvider.toggleTaskCompletion(task.id);
      
      // Verify task is toggled in provider and storage
      expect(taskProvider.tasks[0].isCompleted, true);
      
      final storedTask = await mockStorageService.getTask(task.id);
      expect(storedTask?.isCompleted, true);
      
      // Toggle back
      await taskProvider.toggleTaskCompletion(task.id);
      expect(taskProvider.tasks[0].isCompleted, false);
    });
    
    group('Sorting Tests', () {
      late Task highPriorityTask;
      late Task mediumPriorityTask;
      late Task lowPriorityTask;
      late Task dueSoonTask;
      late Task dueLaterTask;
      late Task completedTask;
      
      setUp(() async {
        // Clear previous tasks
        await mockStorageService.clearTasks();
        taskProvider = TaskProvider(mockStorageService);
        
        final now = DateTime.now();
        
        // Create test tasks with different properties
        highPriorityTask = Task(
          title: 'High Priority',
          priority: TaskPriority.high,
          dueDate: now.add(const Duration(days: 5)),
          createdAt: now.subtract(const Duration(days: 1)),
        );
        
        mediumPriorityTask = Task(
          title: 'Medium Priority',
          priority: TaskPriority.medium,
          dueDate: now.add(const Duration(days: 3)),
          createdAt: now.subtract(const Duration(days: 2)),
        );
        
        lowPriorityTask = Task(
          title: 'Low Priority',
          priority: TaskPriority.low,
          dueDate: now.add(const Duration(days: 10)),
          createdAt: now.subtract(const Duration(days: 3)),
        );
        
        dueSoonTask = Task(
          title: 'Due Soon',
          priority: TaskPriority.medium,
          dueDate: now.add(const Duration(days: 1)),
          createdAt: now.subtract(const Duration(days: 4)),
        );
        
        dueLaterTask = Task(
          title: 'Due Later',
          priority: TaskPriority.medium,
          dueDate: now.add(const Duration(days: 15)),
          createdAt: now.subtract(const Duration(days: 5)),
        );
        
        completedTask = Task(
          title: 'Completed Task',
          priority: TaskPriority.medium,
          isCompleted: true,
          createdAt: now.subtract(const Duration(days: 6)),
        );
        
        // Add tasks to provider
        mockStorageService.setTasks([
          highPriorityTask,
          mediumPriorityTask,
          lowPriorityTask,
          dueSoonTask,
          dueLaterTask,
          completedTask,
        ]);
        
        await taskProvider.loadTasks();
      });
      
      test('Sort by priority', () {
        // Sort by priority (high to low)
        taskProvider.setSortOption(TaskSortOption.priority, ascending: false);
        expect(taskProvider.sortedTasks[0].title, 'High Priority');
        expect(taskProvider.sortedTasks[5].title, 'Low Priority');
        
        // Sort by priority (low to high)
        taskProvider.setSortOption(TaskSortOption.priority, ascending: true);
        expect(taskProvider.sortedTasks[0].title, 'Low Priority');
        expect(taskProvider.sortedTasks[5].title, 'High Priority');
      });
      
      test('Sort by due date', () {
        // Sort by due date (earliest first)
        taskProvider.setSortOption(TaskSortOption.dueDate, ascending: true);
        var sortedTasks = taskProvider.sortedTasks;
        // Tasks with due dates should come before tasks without due dates
        expect(sortedTasks.first.title, 'Due Soon');
        // Tasks without due dates (like completedTask) come last in ascending order
        
        // Sort by due date (latest first)
        taskProvider.setSortOption(TaskSortOption.dueDate, ascending: false);
        sortedTasks = taskProvider.sortedTasks;
        
        // Tasks without due dates (like completedTask) come first in descending order
        expect(sortedTasks.where((t) => t.dueDate != null).first.title, 'Due Later');
      });
      
      test('Sort by completion status', () {
        // Sort by completion status (incomplete first)
        taskProvider.setSortOption(TaskSortOption.completionStatus, ascending: true);
        expect(taskProvider.sortedTasks[0].isCompleted, false);
        expect(taskProvider.sortedTasks[5].isCompleted, true);
        
        // Sort by completion status (completed first)
        taskProvider.setSortOption(TaskSortOption.completionStatus, ascending: false);
        expect(taskProvider.sortedTasks[0].isCompleted, true);
        expect(taskProvider.sortedTasks[1].isCompleted, false);
      });
      
      test('Sort by creation date', () {
        // Sort by creation date (oldest first)
        taskProvider.setSortOption(TaskSortOption.creationDate, ascending: true);
        expect(taskProvider.sortedTasks[0].title, 'Completed Task');
        
        // Sort by creation date (newest first)
        taskProvider.setSortOption(TaskSortOption.creationDate, ascending: false);
        expect(taskProvider.sortedTasks[0].title, 'High Priority');
      });
    });
  });
}