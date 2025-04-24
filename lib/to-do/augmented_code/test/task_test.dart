import 'package:flutter_test/flutter_test.dart';
import '../models/task.dart';

void main() {
  group('Task', () {
    test('should create a task with default values', () {
      final task = Task(title: 'Test Task');
      
      expect(task.title, 'Test Task');
      expect(task.description, '');
      expect(task.priority, TaskPriority.medium);
      expect(task.dueDate, null);
      expect(task.isCompleted, false);
      expect(task.id, isNotNull);
      expect(task.createdAt, isNotNull);
    });
    
    test('should create a task with custom values', () {
      final dueDate = DateTime(2023, 12, 31);
      final task = Task(
        title: 'Custom Task',
        description: 'This is a test task',
        priority: TaskPriority.high,
        dueDate: dueDate,
        isCompleted: true,
      );
      
      expect(task.title, 'Custom Task');
      expect(task.description, 'This is a test task');
      expect(task.priority, TaskPriority.high);
      expect(task.dueDate, dueDate);
      expect(task.isCompleted, true);
    });
    
    test('should create a copy with updated values', () {
      final originalTask = Task(
        title: 'Original Task',
        description: 'Original description',
        priority: TaskPriority.low,
      );
      
      final updatedTask = originalTask.copyWith(
        title: 'Updated Task',
        priority: TaskPriority.high,
        isCompleted: true,
      );
      
      // Original task should remain unchanged
      expect(originalTask.title, 'Original Task');
      expect(originalTask.priority, TaskPriority.low);
      expect(originalTask.isCompleted, false);
      
      // Updated task should have new values
      expect(updatedTask.id, originalTask.id); // ID should be the same
      expect(updatedTask.title, 'Updated Task');
      expect(updatedTask.description, 'Original description'); // Unchanged
      expect(updatedTask.priority, TaskPriority.high);
      expect(updatedTask.isCompleted, true);
    });
  });
  
  group('TaskPriorityExtension', () {
    test('should return correct name for each priority level', () {
      expect(TaskPriority.low.name, 'Low');
      expect(TaskPriority.medium.name, 'Medium');
      expect(TaskPriority.high.name, 'High');
    });
  });
}
