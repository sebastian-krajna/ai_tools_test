// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/repositories/task_repository.dart';
import 'package:todo_app/screens/task_list_screen.dart';

// Mock TaskRepository for testing
class MockTaskRepository extends TaskRepository {
  final List<Task> _tasks = [];

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
}

void main() {
  testWidgets('App should render task list screen', (WidgetTester tester) async {
    // Create a mock repository and provider
    final mockRepository = MockTaskRepository();
    final taskProvider = TaskProvider(mockRepository);
    await taskProvider.init();

    // Build our app and trigger a frame
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<TaskProvider>.value(
          value: taskProvider,
          child: const TaskListScreen(),
        ),
      ),
    );

    // Verify that the app title is displayed
    expect(find.text('My Tasks'), findsOneWidget);

    // Verify that the empty state is shown
    expect(find.text('No tasks yet'), findsOneWidget);
    expect(find.text('Add your first task to get started'), findsOneWidget);
  });
}
