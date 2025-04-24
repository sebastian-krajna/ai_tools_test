import 'package:ai_tools_test/to-do/augmented_code/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_list_item.dart';
import '../widgets/sort_options.dart';
import '../widgets/empty_state.dart';
import 'task_form_screen.dart';
import 'task_detail_screen.dart';

/// Screen for displaying the list of tasks
class TaskListScreen extends StatefulWidget {
  /// Constructor for the task list screen
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  bool _showCompletedTasks = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          // Toggle for showing/hiding completed tasks
          IconButton(
            icon: Icon(
              _showCompletedTasks
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
            tooltip: _showCompletedTasks
                ? 'Hide completed tasks'
                : 'Show completed tasks',
            onPressed: () {
              setState(() {
                _showCompletedTasks = !_showCompletedTasks;
              });
            },
          ),
          // Theme toggle
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Toggle theme',
            onPressed: () {
              final themeProvider = Provider.of<ThemeProvider>(
                context,
                listen: false,
              );
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Sort options
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, _) {
                return SortOptions(
                  currentSortOption: taskProvider.sortOption,
                  sortAscending: taskProvider.sortAscending,
                  onSortOptionChanged: (option) {
                    taskProvider.setSortOption(option);
                  },
                  onSortDirectionChanged: () {
                    taskProvider.setSortOption(
                      taskProvider.sortOption,
                      ascending: !taskProvider.sortAscending,
                    );
                  },
                );
              },
            ),
          ),
          // Task list
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, _) {
                final tasks = _showCompletedTasks
                    ? taskProvider.tasks
                    : taskProvider.getFilteredTasks(isCompleted: false);
                
                if (tasks.isEmpty) {
                  return EmptyState(
                    message: 'No tasks yet. Tap the + button to add a new task.',
                    icon: Icons.task_alt,
                    onActionPressed: () => _navigateToAddTask(context),
                    actionLabel: 'Add Task',
                  );
                }
                
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskListItem(
                      task: task,
                      onTap: () => _navigateToTaskDetail(context, task),
                      onCompletionToggle: (value) {
                        taskProvider.toggleTaskCompletion(task.id);
                      },
                      onDelete: () {
                        taskProvider.deleteTask(task.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Task deleted'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                taskProvider.addTask(task);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTask(context),
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
  
  /// Navigate to the task form screen to add a new task
  void _navigateToAddTask(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TaskFormScreen(),
      ),
    );
    
    if (result == true) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task added successfully')),
      );
    }
  }
  
  /// Navigate to the task detail screen
  void _navigateToTaskDetail(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(taskId: task.id),
      ),
    );
  }
}
