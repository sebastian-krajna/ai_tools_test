import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modern_todo_app/models/task.dart';
import 'package:modern_todo_app/providers/task_provider.dart';

void main() {
  group('TaskProvider Tests', () {
    late TaskProvider taskProvider;

    setUp(() {
      // Initialize shared preferences for testing
      SharedPreferences.setMockInitialValues({});
      taskProvider = TaskProvider();
    });

    test('Add task adds to the list', () async {
      // Create a sample task
      final task = Task(
        title: 'Test Task',
        description: 'Test Description',
        priority: TaskPriority.high,
      );

      // Add task and verify
      await taskProvider.addTask(task);
      expect(taskProvider.tasks.length, 1);
      expect(taskProvider.tasks.first.title, 'Test Task');
      expect(taskProvider.tasks.first.priority, TaskPriority.high);
    });

    test('Update task modifies the existing task', () async {
      // Create a sample task
      final task = Task(
        title: 'Task to Update',
        description: 'Initial Description',
        priority: TaskPriority.low,
      );

      // Add task
      await taskProvider.addTask(task);
      expect(taskProvider.tasks.first.title, 'Task to Update');
      
      // Create updated version
      final updatedTask = task.copyWith(
        title: 'Updated Task',
        priority: TaskPriority.high,
      );
      
      // Update task
      await taskProvider.updateTask(updatedTask);
      
      // Verify update
      expect(taskProvider.tasks.length, 1);
      expect(taskProvider.tasks.first.title, 'Updated Task');
      expect(taskProvider.tasks.first.priority, TaskPriority.high);
      expect(taskProvider.tasks.first.description, 'Initial Description');
    });

    test('Delete task removes it from the list', () async {
      // Create and add sample tasks
      final task1 = Task(title: 'Task 1');
      final task2 = Task(title: 'Task 2');
      await taskProvider.addTask(task1);
      await taskProvider.addTask(task2);
      expect(taskProvider.tasks.length, 2);
      
      // Delete first task
      await taskProvider.deleteTask(task1.id);
      
      // Verify deletion
      expect(taskProvider.tasks.length, 1);
      expect(taskProvider.tasks.first.title, 'Task 2');
    });

    test('Toggle task completion changes completion status', () async {
      // Create and add a sample task
      final task = Task(title: 'Toggle Test Task');
      await taskProvider.addTask(task);
      
      // Verify initial state
      expect(taskProvider.tasks.first.isCompleted, false);
      
      // Toggle completion
      await taskProvider.toggleTaskCompletion(task.id);
      
      // Verify task is completed
      expect(taskProvider.tasks.first.isCompleted, true);
      
      // Toggle again
      await taskProvider.toggleTaskCompletion(task.id);
      
      // Verify task is not completed
      expect(taskProvider.tasks.first.isCompleted, false);
    });

    test('Sort tasks by priority works correctly', () async {
      // Create and add sample tasks with different priorities
      final lowPriorityTask = Task(
        title: 'Low Priority',
        priority: TaskPriority.low,
      );
      final mediumPriorityTask = Task(
        title: 'Medium Priority',
        priority: TaskPriority.medium,
      );
      final highPriorityTask = Task(
        title: 'High Priority',
        priority: TaskPriority.high,
      );
      
      await taskProvider.addTask(lowPriorityTask);
      await taskProvider.addTask(mediumPriorityTask);
      await taskProvider.addTask(highPriorityTask);
      
      // Sort by priority
      taskProvider.sortTasks(SortCriteria.priority);
      
      // Verify order: high, medium, low
      expect(taskProvider.tasks[0].priority, TaskPriority.high);
      expect(taskProvider.tasks[1].priority, TaskPriority.medium);
      expect(taskProvider.tasks[2].priority, TaskPriority.low);
    });

    test('Sort tasks by due date works correctly', () async {
      // Create and add sample tasks with different due dates
      final noDueDateTask = Task(
        title: 'No Due Date',
      );
      final futureDueDateTask = Task(
        title: 'Future Due Date',
        dueDate: DateTime.now().add(const Duration(days: 10)),
      );
      final pastDueDateTask = Task(
        title: 'Past Due Date',
        dueDate: DateTime.now().subtract(const Duration(days: 5)),
      );
      final soonerDueDateTask = Task(
        title: 'Sooner Due Date',
        dueDate: DateTime.now().add(const Duration(days: 2)),
      );
      
      await taskProvider.addTask(noDueDateTask);
      await taskProvider.addTask(futureDueDateTask);
      await taskProvider.addTask(pastDueDateTask);
      await taskProvider.addTask(soonerDueDateTask);
      
      // Sort by due date
      taskProvider.sortTasks(SortCriteria.dueDate);
      
      // Verify order: past, sooner, future, no due date
      expect(taskProvider.tasks[0].title, 'Past Due Date');
      expect(taskProvider.tasks[1].title, 'Sooner Due Date');
      expect(taskProvider.tasks[2].title, 'Future Due Date');
      expect(taskProvider.tasks[3].title, 'No Due Date');
    });
  });
}
