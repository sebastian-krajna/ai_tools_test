import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/services/storage_service.dart';

// Generate mock class
@GenerateMocks([StorageService])
import 'task_provider_test.mocks.dart';

void main() {
  late TaskProvider taskProvider;
  late MockStorageService mockStorageService;

  setUp(() {
    mockStorageService = MockStorageService();
    when(mockStorageService.loadTasks()).thenAnswer((_) async => []);
    // We'll need to inject this mock into the provider
    // This is a simplified test setup
  });

  test('Adding a task increases task count', () async {
    // Arrange
    taskProvider = TaskProvider();
    
    // Act
    await taskProvider.addTask(
      'Test Task',
      'Test Description',
      TaskPriority.medium,
      DateTime.now(),
    );
    
    // Assert
    expect(taskProvider.tasks.length, 1);
    expect(taskProvider.tasks[0].title, 'Test Task');
  });

  test('Toggling task completion changes isCompleted status', () async {
    // Arrange
    taskProvider = TaskProvider();
    await taskProvider.addTask(
      'Test Task',
      'Test Description',
      TaskPriority.medium,
      DateTime.now(),
    );
    final taskId = taskProvider.tasks[0].id;
    
    // Act
    await taskProvider.toggleTaskCompletion(taskId);
    
    // Assert
    expect(taskProvider.tasks[0].isCompleted, true);
    
    // Toggle back
    await taskProvider.toggleTaskCompletion(taskId);
    expect(taskProvider.tasks[0].isCompleted, false);
  });

  test('Deleting a task removes it from the list', () async {
    // Arrange
    taskProvider = TaskProvider();
    await taskProvider.addTask(
      'Test Task',
      'Test Description',
      TaskPriority.medium,
      DateTime.now(),
    );
    final taskId = taskProvider.tasks[0].id;
    
    // Act
    await taskProvider.deleteTask(taskId);
    
    // Assert
    expect(taskProvider.tasks.length, 0);
  });
}
