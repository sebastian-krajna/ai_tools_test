import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../utils/date_formatter.dart';
import 'task_form_screen.dart';

/// Screen for displaying task details
class TaskDetailsScreen extends StatelessWidget {
  final String taskId;

  const TaskDetailsScreen({
    Key? key,
    required this.taskId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final task = taskProvider.getTaskById(taskId);
        
        if (task == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Task Details'),
            ),
            body: const Center(
              child: Text('Task not found'),
            ),
          );
        }
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Task Details'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _navigateToEditTask(context, task),
                tooltip: 'Edit task',
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteTask(context, task),
                tooltip: 'Delete task',
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Task completion status
                Row(
                  children: [
                    Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) {
                        if (value != null) {
                          taskProvider.toggleTaskCompletion(task.id);
                        }
                      },
                    ),
                    Text(
                      task.isCompleted ? 'Completed' : 'Not completed',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Task title
                Text(
                  'Title',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                
                const SizedBox(height: 24),
                
                // Task description
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task.description.isEmpty
                      ? 'No description'
                      : task.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                
                const SizedBox(height: 24),
                
                // Task priority
                Text(
                  'Priority',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.getPriorityColor(task.priority),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      task.priority.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Due date
                Text(
                  'Due Date',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: task.dueDate != null && DateFormatter.isOverdue(task.dueDate)
                          ? Colors.red
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      task.dueDate != null
                          ? DateFormatter.formatDateWithTime(task.dueDate)
                          : 'No due date',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: task.dueDate != null && DateFormatter.isOverdue(task.dueDate)
                            ? Colors.red
                            : null,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Created date
                Text(
                  'Created',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormatter.formatDateWithTime(task.createdAt),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToEditTask(BuildContext context, Task task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(task: task),
      ),
    );
    
    if (result == true) {
      // Return to the task list screen
      if (context.mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  void _deleteTask(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false)
                  .deleteTask(task.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, true); // Return to task list
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
