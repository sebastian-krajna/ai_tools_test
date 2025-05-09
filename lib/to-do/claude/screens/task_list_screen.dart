import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
import '../models/task.dart';
import '../widgets/task_list_item.dart';
import '../widgets/empty_state.dart';
import '../widgets/sort_options.dart';
import 'task_form_screen.dart';
import 'task_detail_screen.dart';

/// Main screen that displays the list of tasks
class TaskListScreen extends StatefulWidget {
  /// Constructor for TaskListScreen
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
        title: const Text('My Tasks'),
        actions: [
          // Sort button
          Consumer<TaskProvider>(
            builder: (context, taskProvider, _) {
              return SortOptions(
                currentSortCriteria: taskProvider.sortCriteria,
                sortAscending: taskProvider.sortAscending,
                onSortChanged: taskProvider.setSortCriteria,
              );
            },
          ),
          
          // Theme toggle
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: themeProvider.toggleTheme,
                tooltip: 'Toggle theme',
              );
            },
          ),
          
          // Filter menu
          PopupMenuButton(
            tooltip: 'Filter options',
            icon: const Icon(Icons.filter_list),
            itemBuilder: (context) => [
              CheckedPopupMenuItem(
                value: 'show_completed',
                checked: _showCompletedTasks,
                child: const Text('Show completed tasks'),
              ),
              const PopupMenuItem(
                value: 'clear_completed',
                child: Text('Clear completed tasks'),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Text('Clear all tasks'),
              ),
            ],
            onSelected: (value) => _handleMenuAction(value as String),
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, _) {
          if (taskProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (taskProvider.error != null) {
            return Center(
              child: Text(
                'Error: ${taskProvider.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          
          final tasks = _showCompletedTasks
              ? taskProvider.tasks
              : taskProvider.incompleteTasks;
          
          if (tasks.isEmpty) {
            return EmptyState(
              message: 'No tasks yet.\nTap the + button to create a new task.',
              icon: Icons.task_alt,
              actionLabel: 'Add Task',
              onActionPressed: () => _navigateToTaskForm(context),
            );
          }
          
          return RefreshIndicator(
            onRefresh: taskProvider.loadTasks,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskListItem(
                  task: task,
                  onTap: () => _navigateToTaskDetail(context, task),
                  onCompletionToggle: (isCompleted) {
                    _animateTaskCompletion(taskProvider, task);
                  },
                  onDelete: () => taskProvider.deleteTask(task.id),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToTaskForm(context),
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
  
  /// Navigate to the task form screen to create a new task
  void _navigateToTaskForm(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TaskFormScreen()),
    );
    
    if (result == true) {
      _showSnackBar('Task added successfully');
    }
  }
  
  /// Navigate to the task detail screen
  void _navigateToTaskDetail(BuildContext context, Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(taskId: task.id),
      ),
    );
  }
  
  /// Animate task completion with a subtle bouncing effect
  void _animateTaskCompletion(TaskProvider provider, Task task) {
    provider.toggleTaskCompletion(task.id);
    
    if (!task.isCompleted) {
      // Small success notification when completing a task
      _showSnackBar('Task completed! 🎉');
    }
  }
  
  /// Show a snack bar with a message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  /// Handle menu actions from the filter menu
  void _handleMenuAction(String action) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    
    switch (action) {
      case 'show_completed':
        setState(() {
          _showCompletedTasks = !_showCompletedTasks;
        });
        break;
      case 'clear_completed':
        _confirmClearAction(
          context,
          'Clear completed tasks?',
          'This will remove all completed tasks from your list.',
          () {
            // Remove all completed tasks
            final completedTasks = taskProvider.completedTasks;
            for (final task in completedTasks) {
              taskProvider.deleteTask(task.id);
            }
            _showSnackBar('Completed tasks cleared');
          },
        );
        break;
      case 'clear_all':
        _confirmClearAction(
          context,
          'Clear all tasks?',
          'This will remove all tasks from your list. This action cannot be undone.',
          () {
            taskProvider.clearAllTasks();
            _showSnackBar('All tasks cleared');
          },
        );
        break;
    }
  }
  
  /// Show a confirmation dialog for destructive actions
  void _confirmClearAction(
    BuildContext context,
    String title,
    String message,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}