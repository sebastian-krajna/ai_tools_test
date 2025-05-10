import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/models/task.dart';

void main() {
  group('Task', () {
    test('should create with required fields', () {
      final task = Task(title: 'Test Task');
      
      expect(task.title, 'Test Task');
      expect(task.description, '');
      expect(task.priority, TaskPriority.medium);
      expect(task.dueDate, null);
      expect(task.isCompleted, false);
      expect(task.id, isNotEmpty);
    });
    
    test('should create with all fields', () {
      final dueDate = DateTime(2023, 12, 31);
      final createdAt = DateTime(2023, 1, 1);
      final updatedAt = DateTime(2023, 1, 2);
      
      final task = Task(
        id: 'test-id',
        title: 'Test Task',
        description: 'Test Description',
        priority: TaskPriority.high,
        dueDate: dueDate,
        isCompleted: true,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      
      expect(task.id, 'test-id');
      expect(task.title, 'Test Task');
      expect(task.description, 'Test Description');
      expect(task.priority, TaskPriority.high);
      expect(task.dueDate, dueDate);
      expect(task.isCompleted, true);
      expect(task.createdAt, createdAt);
      expect(task.updatedAt, updatedAt);
    });
    
    test('copyWith should create a new task with updated fields', () {
      final task = Task(
        id: 'test-id',
        title: 'Original Title',
        description: 'Original Description',
        priority: TaskPriority.low,
      );
      
      final updatedTask = task.copyWith(
        title: 'Updated Title',
        priority: TaskPriority.high,
      );
      
      // Check original is unchanged
      expect(task.title, 'Original Title');
      expect(task.priority, TaskPriority.low);
      
      // Check updated has new values
      expect(updatedTask.id, 'test-id');
      expect(updatedTask.title, 'Updated Title');
      expect(updatedTask.description, 'Original Description');
      expect(updatedTask.priority, TaskPriority.high);
    });
    
    test('toggleCompleted should toggle isCompleted status', () {
      final task = Task(title: 'Test Task');
      expect(task.isCompleted, false);
      
      final completedTask = task.toggleCompleted();
      expect(completedTask.isCompleted, true);
      
      final uncompletedTask = completedTask.toggleCompleted();
      expect(uncompletedTask.isCompleted, false);
    });
    
    test('isOverdue should be true when due date is in the past', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final task = Task(
        title: 'Test Task',
        dueDate: yesterday,
      );
      
      expect(task.isOverdue, true);
    });
    
    test('isOverdue should be false when due date is in the future', () {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final task = Task(
        title: 'Test Task',
        dueDate: tomorrow,
      );
      
      expect(task.isOverdue, false);
    });
    
    test('isOverdue should be false when task is completed', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final task = Task(
        title: 'Test Task',
        dueDate: yesterday,
        isCompleted: true,
      );
      
      expect(task.isOverdue, false);
    });
    
    test('isDueToday should be true when due date is today', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day, 23, 59);
      final task = Task(
        title: 'Test Task',
        dueDate: today,
      );
      
      expect(task.isDueToday, true);
    });
    
    test('isDueSoon should be true when due date is within 2 days', () {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final task = Task(
        title: 'Test Task',
        dueDate: tomorrow,
      );
      
      expect(task.isDueSoon, true);
    });
  });
}