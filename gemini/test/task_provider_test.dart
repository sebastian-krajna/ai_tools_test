import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/providers/task_provider.dart';

void main() {
  group('TaskProvider', () {
    test('addTask should add a task to the list', () async {
      final provider = TaskProvider();
      final newTask = Task(id: '', title: 'Test Task');

      await provider.addTask(newTask);

      expect(provider.tasks.length, 1);
      expect(provider.tasks.first.title, 'Test Task');
    });

    test('toggleTaskCompletion should toggle the completion status of a task', () async {
      final provider = TaskProvider();
      final initialTask = Task(id: '1', title: 'Test Task');
      await provider.addTask(initialTask);

      await provider.toggleTaskCompletion('1');
      expect(provider.tasks.first.isCompleted, true);

      await provider.toggleTaskCompletion('1');
      expect(provider.tasks.first.isCompleted, false);
    });

    // Add more tests for other functionalities like deleteTask, updateTask, sortTasks, etc.
    // Consider mocking the StorageService to isolate the provider logic.
  });
}