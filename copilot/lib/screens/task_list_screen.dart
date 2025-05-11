import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_item.dart';
import 'task_form_screen.dart';

/// Screen that displays the list of tasks with sorting options
class TaskListScreen extends StatelessWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.sortedTasks;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        centerTitle: false,
        actions: [
          // Sort menu
          PopupMenuButton<TaskSortOption>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort tasks',
            onSelected: (TaskSortOption value) {
              taskProvider.setSortOption(value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: TaskSortOption.priority,
                child: Row(
                  children: [
                    Icon(Icons.flag),
                    SizedBox(width: 8),
                    Text('Priority'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: TaskSortOption.dueDate,
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 8),
                    Text('Due date'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: TaskSortOption.completionStatus,
                child: Row(
                  children: [
                    Icon(Icons.check_circle),
                    SizedBox(width: 8),
                    Text('Completion status'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: TaskSortOption.creationDate,
                child: Row(
                  children: [
                    Icon(Icons.access_time),
                    SizedBox(width: 8),
                    Text('Creation date'),
                  ],
                ),
              ),
            ],
          ),
          // Direction toggle
          IconButton(
            icon: Icon(
              taskProvider.sortAscending
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
            ),
            tooltip: taskProvider.sortAscending
                ? 'Sort ascending'
                : 'Sort descending',
            onPressed: () {
              taskProvider.setSortOption(taskProvider.sortOption);
            },
          ),
        ],
      ),
      body: tasks.isEmpty
          ? _buildEmptyState(context)
          : AnimatedList(
              key: GlobalKey(),
              initialItemCount: tasks.length,
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemBuilder: (context, index, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: TaskItem(task: tasks[index]),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const TaskFormScreen(),
              fullscreenDialog: true,
            ),
          );
          if (result == true) {
            // Task was added
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Task added successfully'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks yet',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first task by tapping the button below',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}