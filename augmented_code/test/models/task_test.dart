import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/models/task.dart';

void main() {
  group('Task Model Tests', () {
    test('Task should be created with default values', () {
      final task = Task(title: 'Test Task');
      
      expect(task.title, 'Test Task');
      expect(task.description, '');
      expect(task.priority, TaskPriority.medium);
      expect(task.dueDate, null);
      expect(task.isCompleted, false);
      expect(task.id, isNotNull);
      expect(task.createdAt, isNotNull);
    });
    
    test('Task should be created with provided values', () {
      final dueDate = DateTime(2023, 12, 31);
      final createdAt = DateTime(2023, 1, 1);
      
      final task = Task(
        id: 'test-id',
        title: 'Test Task',
        description: 'Test Description',
        priority: TaskPriority.high,
        dueDate: dueDate,
        isCompleted: true,
        createdAt: createdAt,
      );
      
      expect(task.id, 'test-id');
      expect(task.title, 'Test Task');
      expect(task.description, 'Test Description');
      expect(task.priority, TaskPriority.high);
      expect(task.dueDate, dueDate);
      expect(task.isCompleted, true);
      expect(task.createdAt, createdAt);
    });
    
    test('copyWith should create a new task with updated values', () {
      final originalTask = Task(
        id: 'test-id',
        title: 'Original Title',
        description: 'Original Description',
        priority: TaskPriority.low,
        dueDate: DateTime(2023, 1, 1),
        isCompleted: false,
      );
      
      final updatedTask = originalTask.copyWith(
        title: 'Updated Title',
        priority: TaskPriority.high,
        isCompleted: true,
      );
      
      // Check that the ID and creation date remain the same
      expect(updatedTask.id, originalTask.id);
      expect(updatedTask.createdAt, originalTask.createdAt);
      
      // Check that specified values are updated
      expect(updatedTask.title, 'Updated Title');
      expect(updatedTask.priority, TaskPriority.high);
      expect(updatedTask.isCompleted, true);
      
      // Check that unspecified values remain the same
      expect(updatedTask.description, originalTask.description);
      expect(updatedTask.dueDate, originalTask.dueDate);
    });
  });
  
  group('TaskPriority Extension Tests', () {
    test('name should return correct display name for each priority', () {
      expect(TaskPriority.low.name, 'Low');
      expect(TaskPriority.medium.name, 'Medium');
      expect(TaskPriority.high.name, 'High');
    });
  });
}
