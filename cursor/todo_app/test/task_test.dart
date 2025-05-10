import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/models/task.dart';

void main() {
  group('Task Model Tests', () {
    test('Task creation should set provided values', () {
      final now = DateTime.now();
      final dueDate = now.add(const Duration(days: 2));
      
      final task = Task(
        id: 'test-id',
        title: 'Test Task',
        description: 'Test Description',
        priority: TaskPriority.high,
        dueDate: dueDate,
        isCompleted: false,
      );
      
      expect(task.id, 'test-id');
      expect(task.title, 'Test Task');
      expect(task.description, 'Test Description');
      expect(task.priority, TaskPriority.high);
      expect(task.dueDate, dueDate);
      expect(task.isCompleted, false);
      expect(task.createdAt.day, now.day);
    });
    
    test('Task copyWith should create a new task with updated values', () {
      final dueDate = DateTime.now().add(const Duration(days: 1));
      final newDueDate = DateTime.now().add(const Duration(days: 2));
      
      final task = Task(
        id: 'test-id',
        title: 'Original Title',
        description: 'Original Description',
        priority: TaskPriority.low,
        dueDate: dueDate,
        isCompleted: false,
      );
      
      final updatedTask = task.copyWith(
        title: 'Updated Title',
        priority: TaskPriority.high,
        dueDate: newDueDate,
        isCompleted: true,
      );
      
      // Original task should remain unchanged
      expect(task.title, 'Original Title');
      expect(task.priority, TaskPriority.low);
      expect(task.dueDate, dueDate);
      expect(task.isCompleted, false);
      
      // New task should have updated values
      expect(updatedTask.id, 'test-id'); // ID should remain the same
      expect(updatedTask.title, 'Updated Title');
      expect(updatedTask.description, 'Original Description'); // Not updated
      expect(updatedTask.priority, TaskPriority.high);
      expect(updatedTask.dueDate, newDueDate);
      expect(updatedTask.isCompleted, true);
    });
    
    test('Task should generate new ID if not provided', () {
      final task1 = Task(
        title: 'Task 1',
        description: 'Description 1',
        priority: TaskPriority.medium,
        dueDate: DateTime.now(),
      );
      
      final task2 = Task(
        title: 'Task 2',
        description: 'Description 2',
        priority: TaskPriority.medium,
        dueDate: DateTime.now(),
      );
      
      expect(task1.id, isNotEmpty);
      expect(task2.id, isNotEmpty);
      expect(task1.id, isNot(equals(task2.id))); // IDs should be unique
    });
  });
} 