import 'package:hive/hive.dart';
import '../models/task.dart';

/// Repository for managing task data operations
class TaskRepository {
  static const String _boxName = 'tasks';
  late Box<Task> _taskBox;

  /// Initialize the repository
  Future<void> init() async {
    // Register the Task adapter
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskAdapter());
      Hive.registerAdapter(TaskPriorityAdapter());
    }
    
    // Open the task box
    _taskBox = await Hive.openBox<Task>(_boxName);
  }

  /// Get all tasks
  List<Task> getAllTasks() {
    return _taskBox.values.toList();
  }

  /// Get a task by ID
  Task? getTaskById(String id) {
    return _taskBox.values.firstWhere(
      (task) => task.id == id,
      orElse: () => throw Exception('Task not found'),
    );
  }

  /// Add a new task
  Future<void> addTask(Task task) async {
    await _taskBox.put(task.id, task);
  }

  /// Update an existing task
  Future<void> updateTask(Task task) async {
    await _taskBox.put(task.id, task);
  }

  /// Delete a task
  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
  }

  /// Mark a task as completed or not completed
  Future<void> toggleTaskCompletion(String id, bool isCompleted) async {
    final task = getTaskById(id);
    if (task != null) {
      final updatedTask = task.copyWith(isCompleted: isCompleted);
      await updateTask(updatedTask);
    }
  }

  /// Close the Hive box
  Future<void> close() async {
    await _taskBox.close();
  }
}

/// Adapter for TaskPriority enum
class TaskPriorityAdapter extends TypeAdapter<TaskPriority> {
  @override
  final int typeId = 1;

  @override
  TaskPriority read(BinaryReader reader) {
    return TaskPriority.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, TaskPriority obj) {
    writer.writeInt(obj.index);
  }
}
