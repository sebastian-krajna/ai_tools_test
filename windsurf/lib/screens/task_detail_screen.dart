import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../utils/date_formatter.dart';
import 'edit_task_screen.dart';

/// Screen for displaying detailed information about a specific task
class TaskDetailScreen extends StatelessWidget {
  final String taskId;

  const TaskDetailScreen({
    super.key,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final task = taskProvider.tasks.firstWhere((task) => task.id == taskId);
    final theme = Theme.of(context);
    
    // Determine priority color
    Color getPriorityColor() {
      switch (task.priority) {
        case TaskPriority.high:
          return Colors.red.shade700;
        case TaskPriority.medium:
          return Colors.orange.shade700;
        case TaskPriority.low:
          return Colors.green.shade700;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          // Edit button
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editTask(context, task),
          ),
          // Delete button
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context, task),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task title and completion checkbox
            Row(
              children: [
                Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    taskProvider.toggleTaskCompletion(task.id);
                  },
                ),
                Expanded(
                  child: Text(
                    task.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      color: task.isCompleted ? theme.disabledColor : null,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Priority section
            _buildInfoSection(
              context,
              'Priority',
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: getPriorityColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  task.priority.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: getPriorityColor(),
                  ),
                ),
              ),
            ),
            
            // Due date section
            _buildInfoSection(
              context,
              'Due Date',
              task.dueDate != null
                  ? Row(
                      children: [
                        Icon(
                          Icons.event,
                          size: 20,
                          color: DateFormatter.isOverdue(task.dueDate) && !task.isCompleted
                              ? Colors.red
                              : theme.hintColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormatter.formatDateWithTime(task.dueDate),
                          style: TextStyle(
                            color: DateFormatter.isOverdue(task.dueDate) && !task.isCompleted
                                ? Colors.red
                                : null,
                          ),
                        ),
                      ],
                    )
                  : const Text('No due date set'),
            ),
            
            // Creation date section
            _buildInfoSection(
              context,
              'Created',
              Text(DateFormatter.formatDateWithTime(task.createdAt)),
            ),
            
            const SizedBox(height: 24),
            
            // Description section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
                  ),
                  child: Text(
                    task.description.isNotEmpty ? task.description : 'No description',
                    style: TextStyle(
                      color: task.description.isNotEmpty
                          ? null
                          : theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // Button to toggle completion status
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          taskProvider.toggleTaskCompletion(task.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                task.isCompleted
                    ? 'Task marked as incomplete'
                    : 'Task marked as complete',
              ),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        icon: Icon(task.isCompleted ? Icons.refresh : Icons.check),
        label: Text(task.isCompleted ? 'Mark Incomplete' : 'Mark Complete'),
      ),
    );
  }

  // Helper method to build consistent info sections
  Widget _buildInfoSection(BuildContext context, String title, Widget content) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: content),
        ],
      ),
    );
  }

  // Navigate to edit task screen
  void _editTask(BuildContext context, Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(task: task),
      ),
    );
  }

  // Show confirmation dialog before deleting task
  void _confirmDelete(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Provider.of<TaskProvider>(context, listen: false)
                  .deleteTask(task.id);
              Navigator.pop(context); // Go back to task list
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
