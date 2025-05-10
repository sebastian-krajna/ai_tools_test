import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import 'task_detail_screen.dart';
import '../widgets/priority_badge.dart';

/// Main screen displaying the list of tasks
class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<SortMethod>(
            icon: const Icon(Icons.sort),
            onSelected: (SortMethod method) {
              Provider.of<TaskProvider>(context, listen: false)
                  .setSortMethod(method);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: SortMethod.priority,
                child: Text('Sort by Priority'),
              ),
              const PopupMenuItem(
                value: SortMethod.dueDate,
                child: Text('Sort by Due Date'),
              ),
              const PopupMenuItem(
                value: SortMethod.completion,
                child: Text('Sort by Completion'),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final tasks = taskProvider.tasks;
          
          if (tasks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No tasks yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add a task using the + button below',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return _buildTaskItem(context, task);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToTaskDetail(context),
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Builds a single task item in the list
  Widget _buildTaskItem(BuildContext context, Task task) {
    final theme = Theme.of(context);
    final dueDateText = task.dueDate != null
        ? DateFormat('MMM d, yyyy').format(task.dueDate!)
        : 'No due date';

    return Slidable(
      key: ValueKey(task.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              Provider.of<TaskProvider>(context, listen: false)
                  .deleteTask(task.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task deleted')),
              );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: InkWell(
          onTap: () => _navigateToTaskDetail(context, task: task),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Checkbox for task completion
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Checkbox(
                    value: task.isCompleted,
                    onChanged: (bool? value) {
                      // Animate completion with a subtle effect
                      Provider.of<TaskProvider>(context, listen: false)
                          .toggleTaskCompletion(task.id);
                    },
                    activeColor: theme.colorScheme.primary,
                  ),
                ),
                // Task details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task.isCompleted
                                    ? Colors.grey
                                    : theme.textTheme.bodyLarge?.color,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          PriorityBadge(priority: task.priority),
                        ],
                      ),
                      if (task.description.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            task.description,
                            style: TextStyle(
                              color: task.isCompleted
                                  ? Colors.grey
                                  : theme.textTheme.bodyMedium?.color,
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: task.isCompleted
                                  ? Colors.grey
                                  : _getDueDateColor(context, task.dueDate),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              dueDateText,
                              style: TextStyle(
                                fontSize: 12,
                                color: task.isCompleted
                                    ? Colors.grey
                                    : _getDueDateColor(context, task.dueDate),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Returns a color based on the due date status
  Color _getDueDateColor(BuildContext context, DateTime? dueDate) {
    if (dueDate == null) {
      return Colors.grey;
    }
    
    final today = DateTime.now();
    final tomorrow = DateTime(today.year, today.month, today.day + 1);
    
    if (dueDate.isBefore(DateTime(today.year, today.month, today.day))) {
      // Overdue
      return Colors.red;
    } else if (dueDate.isBefore(tomorrow)) {
      // Due today
      return Colors.orange;
    } else {
      // Future date
      return Colors.green;
    }
  }

  /// Navigates to the task detail screen
  void _navigateToTaskDetail(BuildContext context, {Task? task}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(task: task),
      ),
    );
  }
}
