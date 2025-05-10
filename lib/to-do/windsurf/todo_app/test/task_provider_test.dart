import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/providers/task_provider.dart';

void main() {
  group('TaskProvider Tests', () {
    late TaskProvider taskProvider;

    setUp(() {
      taskProvider = TaskProvider();
    });

    test('Adding a task increases task count', () {
      // Arrange
      final initialCount = taskProvider.tasks.length;
      final task = Task(title: 'Test Task');

      // Act
      taskProvider.addTask(task);

      // Assert
      expect(taskProvider.tasks.length, initialCount + 1);
    });

    test('Updating a task preserves task count', () {
      // Arrange
      final task = Task(title: 'Test Task');
      taskProvider.addTask(task);
      final initialCount = taskProvider.tasks.length;
      final updatedTask = task.copyWith(title: 'Updated Task');

      // Act
      taskProvider.updateTask(task.id, updatedTask);

      // Assert
      expect(taskProvider.tasks.length, initialCount);
      expect(taskProvider.tasks.firstWhere((t) => t.id == task.id).title, 'Updated Task');
    });

    test('Deleting a task decreases task count', () {
      // Arrange
      final task = Task(title: 'Test Task');
      taskProvider.addTask(task);
      final initialCount = taskProvider.tasks.length;

      // Act
      taskProvider.deleteTask(task.id);

      // Assert
      expect(taskProvider.tasks.length, initialCount - 1);
      expect(taskProvider.tasks.where((t) => t.id == task.id).isEmpty, true);
    });

    test('Toggling task completion changes isCompleted value', () {
      // Arrange
      final task = Task(title: 'Test Task', isCompleted: false);
      taskProvider.addTask(task);

      // Act
      taskProvider.toggleTaskCompletion(task.id);

      // Assert
      expect(taskProvider.tasks.firstWhere((t) => t.id == task.id).isCompleted, true);
    });

    test('Sorting by priority works correctly', () {
      // Arrange
      final lowTask = Task(title: 'Low Priority', priority: TaskPriority.low);
      final mediumTask = Task(title: 'Medium Priority', priority: TaskPriority.medium);
      final highTask = Task(title: 'High Priority', priority: TaskPriority.high);
      
      taskProvider.addTask(lowTask);
      taskProvider.addTask(mediumTask);
      taskProvider.addTask(highTask);
      
      // Act
      taskProvider.setSortMethod(SortMethod.priority);
      
      // Assert
      final sortedTasks = taskProvider.tasks;
      expect(sortedTasks[0].priority, TaskPriority.high);
      expect(sortedTasks[1].priority, TaskPriority.medium);
      expect(sortedTasks[2].priority, TaskPriority.low);
    });
  });
}
