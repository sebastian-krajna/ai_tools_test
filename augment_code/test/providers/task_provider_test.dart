import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/repositories/task_repository.dart';

// Mock TaskRepository for testing
class MockTaskRepository extends TaskRepository {
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
  Future<void> addTask(Task task) async {
    _tasks.add(task);
  }

  @override
  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
  }

  @override
  Future<void> toggleTaskCompletion(String id, bool isCompleted) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(isCompleted: isCompleted);
    }
  }

  // Helper method to set tasks for testing
  void setTasks(List<Task> tasks) {
    _tasks = List.from(tasks);
  }
}

void main() {
  late MockTaskRepository mockRepository;
  late TaskProvider taskProvider;

  setUp(() {
    mockRepository = MockTaskRepository();
    taskProvider = TaskProvider(mockRepository);
  });

  group('TaskProvider Tests', () {
    test('loadTasks should load tasks from repository', () async {
      // Arrange
      final tasks = [
        Task(id: '1', title: 'Task 1'),
        Task(id: '2', title: 'Task 2'),
      ];
      mockRepository.setTasks(tasks);

      // Act
      await taskProvider.loadTasks();

      // Assert
      expect(taskProvider.tasks.length, 2);
      expect(taskProvider.tasks[0].id, '1');
      expect(taskProvider.tasks[1].id, '2');
    });

    test('addTask should add a task to repository', () async {
      // Arrange
      final task = Task(id: '1', title: 'New Task');

      // Act
      await taskProvider.addTask(task);

      // Assert
      expect(mockRepository.getAllTasks().length, 1);
      expect(mockRepository.getAllTasks()[0].title, 'New Task');
    });

    test('updateTask should update a task in repository', () async {
      // Arrange
      final task = Task(id: '1', title: 'Original Task');
      mockRepository.setTasks([task]);

      final updatedTask = task.copyWith(title: 'Updated Task');

      // Act
      await taskProvider.updateTask(updatedTask);

      // Assert
      expect(mockRepository.getAllTasks()[0].title, 'Updated Task');
    });

    test('deleteTask should remove a task from repository', () async {
      // Arrange
      final tasks = [
        Task(id: '1', title: 'Task 1'),
        Task(id: '2', title: 'Task 2'),
      ];
      mockRepository.setTasks(tasks);

      // Act
      await taskProvider.deleteTask('1');

      // Assert
      expect(mockRepository.getAllTasks().length, 1);
      expect(mockRepository.getAllTasks()[0].id, '2');
    });

    test('toggleTaskCompletion should toggle task completion status', () async {
      // Arrange
      final task = Task(id: '1', title: 'Task', isCompleted: false);
      mockRepository.setTasks([task]);
      await taskProvider.loadTasks(); // Load tasks first

      // Act
      await taskProvider.toggleTaskCompletion('1');

      // Assert
      expect(mockRepository.getAllTasks()[0].isCompleted, true);

      // Toggle back
      await taskProvider.toggleTaskCompletion('1');
      expect(mockRepository.getAllTasks()[0].isCompleted, false);
    });

    test('getTaskById should return the correct task', () async {
      // Arrange
      final tasks = [
        Task(id: '1', title: 'Task 1'),
        Task(id: '2', title: 'Task 2'),
      ];
      mockRepository.setTasks(tasks);
      await taskProvider.loadTasks();

      // Act
      final task = taskProvider.getTaskById('2');

      // Assert
      expect(task, isNotNull);
      expect(task!.id, '2');
      expect(task.title, 'Task 2');
    });

    test('sorting by priority should work correctly', () async {
      // Arrange
      final tasks = [
        Task(id: '1', title: 'Task 1', priority: TaskPriority.low),
        Task(id: '2', title: 'Task 2', priority: TaskPriority.high),
        Task(id: '3', title: 'Task 3', priority: TaskPriority.medium),
      ];
      mockRepository.setTasks(tasks);
      await taskProvider.loadTasks();

      // Act
      taskProvider.sortOption = TaskSortOption.priority;

      // Assert - should be sorted high to low
      expect(taskProvider.tasks[0].id, '2'); // High
      expect(taskProvider.tasks[1].id, '3'); // Medium
      expect(taskProvider.tasks[2].id, '1'); // Low
    });
  });
}
