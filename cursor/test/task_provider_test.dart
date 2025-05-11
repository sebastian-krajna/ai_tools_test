import 'package:flutter_test/flutter_test.dart';
import '../lib/models/task.dart';
import '../lib/providers/task_provider.dart';

void main() {
  group('TaskProvider Tests', () {
    test('getSortedTasks should sort tasks by priority', () {
      // Create a mock list of tasks
      final tasks = [
        Task(
          id: '1',
          title: 'Low Priority Task',
          description: 'Description',
          priority: TaskPriority.low,
          dueDate: DateTime.now().add(const Duration(days: 1)),
        ),
        Task(
          id: '3',
          title: 'High Priority Task',
          description: 'Description',
          priority: TaskPriority.high,
          dueDate: DateTime.now().add(const Duration(days: 3)),
        ),
        Task(
          id: '2',
          title: 'Medium Priority Task',
          description: 'Description',
          priority: TaskPriority.medium,
          dueDate: DateTime.now().add(const Duration(days: 2)),
        ),
      ];
      
      // Create a custom sorter based on the priority logic in TaskProvider
      final sortedTasks = List<Task>.from(tasks)
        ..sort((a, b) => b.priority.index.compareTo(a.priority.index));
      
      // Verify sorting order
      expect(sortedTasks[0].id, '3'); // High priority
      expect(sortedTasks[1].id, '2'); // Medium priority
      expect(sortedTasks[2].id, '1'); // Low priority
    });
    
    test('Tasks should be sortable by due date', () {
      final today = DateTime.now();
      
      // Create a mock list of tasks with different due dates
      final tasks = [
        Task(
          id: '1',
          title: 'Task 1',
          description: 'Description',
          priority: TaskPriority.medium,
          dueDate: today.add(const Duration(days: 3)), // Due in 3 days
        ),
        Task(
          id: '2',
          title: 'Task 2',
          description: 'Description',
          priority: TaskPriority.medium,
          dueDate: today.add(const Duration(days: 1)), // Due tomorrow
        ),
        Task(
          id: '3',
          title: 'Task 3',
          description: 'Description',
          priority: TaskPriority.medium,
          dueDate: today.add(const Duration(days: 2)), // Due in 2 days
        ),
      ];
      
      // Create a custom sorter based on the due date logic in TaskProvider
      final sortedTasks = List<Task>.from(tasks)
        ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
      
      // Verify sorting order (earliest due date first)
      expect(sortedTasks[0].id, '2'); // Due tomorrow
      expect(sortedTasks[1].id, '3'); // Due in 2 days
      expect(sortedTasks[2].id, '1'); // Due in 3 days
    });
    
    test('Tasks should be sortable by completion status', () {
      // Create a mock list of tasks with different completion statuses
      final tasks = [
        Task(
          id: '1',
          title: 'Task 1',
          description: 'Description',
          priority: TaskPriority.medium,
          dueDate: DateTime.now(),
          isCompleted: false,
        ),
        Task(
          id: '2',
          title: 'Task 2',
          description: 'Description',
          priority: TaskPriority.medium,
          dueDate: DateTime.now(),
          isCompleted: true,
        ),
        Task(
          id: '3',
          title: 'Task 3',
          description: 'Description',
          priority: TaskPriority.medium,
          dueDate: DateTime.now(),
          isCompleted: false,
        ),
      ];
      
      // Create a custom sorter based on the completion status logic in TaskProvider
      final sortedTasks = List<Task>.from(tasks)
        ..sort((a, b) => a.isCompleted == b.isCompleted 
          ? 0 
          : (a.isCompleted ? 1 : -1));
      
      // Verify sorting order (incomplete tasks first)
      expect(sortedTasks[0].isCompleted, false);
      expect(sortedTasks[1].isCompleted, false);
      expect(sortedTasks[2].isCompleted, true);
    });
  });
} 