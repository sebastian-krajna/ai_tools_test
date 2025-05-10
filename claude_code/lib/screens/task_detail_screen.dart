import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/screens/task_form_screen.dart';
import 'package:todo_app/utils/date_formatter.dart';
import 'package:todo_app/widgets/due_date_badge.dart';
import 'package:todo_app/widgets/priority_badge.dart';

/// Screen for displaying detailed task information
class TaskDetailScreen extends StatelessWidget {
  final String taskId;

  const TaskDetailScreen({
    super.key,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: () => _editTask(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete',
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, _) {
          final task = taskProvider.getTaskById(taskId);
          
          if (task == null) {
            return const Center(
              child: Text('Task not found'),
            );
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(context, task),
                const SizedBox(height: 24),
                _buildDetailsCard(context, task),
                const SizedBox(height: 16),
                if (task.description.isNotEmpty) ...[
                  _buildDescriptionCard(context, task),
                  const SizedBox(height: 16),
                ],
                _buildActionsCard(context, task),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build the task header section with title and completion status
  Widget _buildHeaderSection(BuildContext context, Task task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                task.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  color: task.isCompleted
                      ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
                      : null,
                ),
              ),
            ),
            Checkbox(
              value: task.isCompleted,
              onChanged: (value) {
                Provider.of<TaskProvider>(context, listen: false)
                    .toggleTaskCompletion(task.id);
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            PriorityBadge(priority: task.priority),
            const SizedBox(width: 8),
            if (task.dueDate != null)
              DueDateBadge(
                dueDate: task.dueDate,
                isCompleted: task.isCompleted,
              ),
          ],
        ),
      ],
    );
  }

  /// Build the task details card with metadata
  Widget _buildDetailsCard(BuildContext context, Task task) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Details',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(),
            _buildDetailRow(
              context,
              'Status',
              task.isCompleted ? 'Completed' : 'Active',
              task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
              task.isCompleted
                  ? Colors.green
                  : Theme.of(context).colorScheme.primary,
            ),
            _buildDetailRow(
              context,
              'Priority',
              task.priority.name,
              _getPriorityIcon(task.priority),
              _getPriorityColor(task.priority),
            ),
            if (task.dueDate != null) ...[
              _buildDetailRow(
                context,
                'Due Date',
                DateFormatter.formatDate(task.dueDate),
                Icons.calendar_today,
                task.isOverdue && !task.isCompleted
                    ? Colors.red
                    : Theme.of(context).colorScheme.primary,
              ),
              _buildDetailRow(
                context,
                'Due Time',
                DateFormatter.formatTime(task.dueDate),
                Icons.access_time,
                Theme.of(context).colorScheme.primary,
              ),
              if (!task.isCompleted)
                _buildDetailRow(
                  context,
                  'Time Remaining',
                  DateFormatter.getDaysRemainingText(task.dueDate),
                  task.isOverdue
                      ? Icons.warning_amber
                      : Icons.timelapse,
                  task.isOverdue
                      ? Colors.red
                      : Theme.of(context).colorScheme.primary,
                ),
            ],
            _buildDetailRow(
              context,
              'Created',
              DateFormatter.formatDateTime(task.createdAt),
              Icons.create,
              Theme.of(context).colorScheme.primary,
            ),
            _buildDetailRow(
              context,
              'Last Updated',
              DateFormatter.formatDateTime(task.updatedAt),
              Icons.update,
              Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  /// Build a single detail row with icon and text
  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build the description card
  Widget _buildDescriptionCard(BuildContext context, Task task) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(),
            Text(
              task.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                color: task.isCompleted
                    ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the actions card with buttons
  Widget _buildActionsCard(BuildContext context, Task task) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Provider.of<TaskProvider>(context, listen: false)
                        .toggleTaskCompletion(task.id);
                  },
                  icon: Icon(
                    task.isCompleted
                        ? Icons.refresh
                        : Icons.check_circle,
                  ),
                  label: Text(
                    task.isCompleted ? 'Mark Incomplete' : 'Mark Complete',
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _editTask(context),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Navigate to the edit task screen
  void _editTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(taskId: taskId),
      ),
    );
  }

  /// Show delete confirmation dialog
  Future<void> _confirmDelete(BuildContext context) async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final task = taskProvider.getTaskById(taskId);
    
    if (task == null) return;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    
    if (confirmed == true && context.mounted) {
      taskProvider.deleteTask(taskId);
      Navigator.pop(context);
    }
  }

  /// Get the icon for a priority level
  IconData _getPriorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Icons.keyboard_arrow_up;
      case TaskPriority.medium:
        return Icons.drag_handle;
      case TaskPriority.low:
        return Icons.keyboard_arrow_down;
    }
  }

  /// Get the color for a priority level
  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red.shade700;
      case TaskPriority.medium:
        return Colors.orange.shade700;
      case TaskPriority.low:
        return Colors.green.shade700;
    }
  }
}