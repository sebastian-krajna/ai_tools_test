import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/models/task.dart';

void main() {
  group('Task Model Tests', () {
    test('Task creation with default values', () {
      final task = Task(title: 'Test Task');
      
      expect(task.title, 'Test Task');
      expect(task.description, '');
      expect(task.priority, TaskPriority.medium);
      expect(task.dueDate, null);
      expect(task.isCompleted, false);
      expect(task.id.isNotEmpty, true);
    });
    
    test('Task creation with custom values', () {
      final dueDate = DateTime(2025, 5, 20);
      final task = Task(
        title: 'Custom Task',
        description: 'This is a custom task',
        priority: TaskPriority.high,
        dueDate: dueDate,
        isCompleted: true,
      );
      
      expect(task.title, 'Custom Task');
      expect(task.description, 'This is a custom task');
      expect(task.priority, TaskPriority.high);
      expect(task.dueDate, dueDate);
      expect(task.isCompleted, true);
    });
    
    test('Task copyWith method', () {
      final task = Task(title: 'Original Task');
      final copiedTask = task.copyWith(
        title: 'Updated Task',
        priority: TaskPriority.low,
      );
      
      // Original task should remain unchanged
      expect(task.title, 'Original Task');
      expect(task.priority, TaskPriority.medium);
      
      // Copied task should have updated values
      expect(copiedTask.title, 'Updated Task');
      expect(copiedTask.priority, TaskPriority.low);
      
      // Other properties should be copied
      expect(copiedTask.id, task.id);
      expect(copiedTask.description, task.description);
      expect(copiedTask.dueDate, task.dueDate);
      expect(copiedTask.isCompleted, task.isCompleted);
      expect(copiedTask.createdAt, task.createdAt);
    });
    
    test('Task to/from Map conversion', () {
      final dueDate = DateTime(2025, 5, 20);
      final createdAt = DateTime(2025, 5, 10);
      final task = Task(
        id: 'test-id-123',
        title: 'Map Task',
        description: 'Testing map conversion',
        priority: TaskPriority.high,
        dueDate: dueDate,
        isCompleted: true,
        createdAt: createdAt,
      );
      
      final map = task.toMap();
      expect(map['id'], 'test-id-123');
      expect(map['title'], 'Map Task');
      expect(map['description'], 'Testing map conversion');
      expect(map['priority'], TaskPriority.high.index);
      expect(map['dueDate'], dueDate.millisecondsSinceEpoch);
      expect(map['isCompleted'], true);
      expect(map['createdAt'], createdAt.millisecondsSinceEpoch);
      
      final recreatedTask = Task.fromMap(map);
      expect(recreatedTask.id, task.id);
      expect(recreatedTask.title, task.title);
      expect(recreatedTask.description, task.description);
      expect(recreatedTask.priority, task.priority);
      expect(recreatedTask.dueDate?.millisecondsSinceEpoch, 
             task.dueDate?.millisecondsSinceEpoch);
      expect(recreatedTask.isCompleted, task.isCompleted);
      expect(recreatedTask.createdAt.millisecondsSinceEpoch, 
             task.createdAt.millisecondsSinceEpoch);
    });
    
    test('TaskPriority name extension', () {
      expect(TaskPriority.low.name, 'Low');
      expect(TaskPriority.medium.name, 'Medium');
      expect(TaskPriority.high.name, 'High');
    });
  });
}