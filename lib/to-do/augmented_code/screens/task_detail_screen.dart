import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../utils/date_formatter.dart';
import '../widgets/priority_badge.dart';
import 'task_form_screen.dart';

/// Screen for displaying the details of a task
class TaskDetailScreen extends StatelessWidget {
  final String taskId;
  
  /// Constructor for the task detail screen
  const TaskDetailScreen({
    super.key,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, _) {
        final taskIndex = taskProvider.tasks.indexWhere((t) => t.id == taskId);
        
        if (taskIndex == -1) {
          // Task not found, navigate back
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context);
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        final task = taskProvider.tasks[taskIndex];
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Task Details'),
            actions: [
              // Edit button
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Edit Task',
                onPressed: () => _navigateToEditTask(context, task),
              ),
              // Delete button
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Delete Task',
                onPressed: () => _confirmDelete(context, task, taskProvider),
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
                        taskProvider.toggleTaskCompletion(task.id);
                      },
                    ),
                    Text(
                      task.isCompleted ? 'Completed' : 'Not completed',
                      style: TextStyle(
                        fontSize: 16,
                        color: task.isCompleted ? Colors.green : Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Task title
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Priority section
                _buildDetailSection(
                  context,
                  'Priority',
                  Icons.flag,
                  child: PriorityBadge(
                    priority: task.priority,
                    showIcon: true,
                    showLabel: true,
                  ),
                ),
                
                // Due date section
                _buildDetailSection(
                  context,
                  'Due Date',
                  Icons.event,
                  text: task.dueDate != null
                      ? DateFormatter.formatDateWithTime(task.dueDate)
                      : 'No due date',
                  textColor: DateFormatter.isOverdue(task.dueDate)
                      ? Colors.red
                      : null,
                ),
                
                // Description section
                _buildDetailSection(
                  context,
                  'Description',
                  Icons.description,
                  text: task.description.isNotEmpty
                      ? task.description
                      : 'No description',
                  expandText: true,
                ),
                
                // Created date section
                _buildDetailSection(
                  context,
                  'Created',
                  Icons.access_time,
                  text: DateFormatter.formatDateWithTime(task.createdAt),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              taskProvider.toggleTaskCompletion(task.id);
            },
            tooltip: task.isCompleted ? 'Mark as incomplete' : 'Mark as complete',
            child: Icon(
              task.isCompleted ? Icons.close : Icons.check,
            ),
          ),
        );
      },
    );
  }
  
  /// Build a section for displaying task details
  Widget _buildDetailSection(
    BuildContext context,
    String title,
    IconData icon, {
    String? text,
    Widget? child,
    Color? textColor,
    bool expandText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: child ??
                Text(
                  text ?? '',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: textColor,
                  ),
                ),
          ),
        ],
      ),
    );
  }
  
  /// Navigate to the task form screen to edit a task
  void _navigateToEditTask(BuildContext context, Task task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(task: task),
      ),
    );
    
    if (result == true) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task updated successfully')),
      );
    }
  }
  
  /// Show a confirmation dialog for deleting a task
  void _confirmDelete(
    BuildContext context,
    Task task,
    TaskProvider taskProvider,
  ) {
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
          FilledButton(
            onPressed: () {
              taskProvider.deleteTask(task.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to list
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
