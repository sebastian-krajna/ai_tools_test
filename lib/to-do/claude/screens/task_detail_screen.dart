import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../utils/constants.dart';
import '../widgets/priority_badge.dart';
import 'task_form_screen.dart';

/// Screen to display task details and provide options to edit or delete
class TaskDetailScreen extends StatelessWidget {
  final String taskId;
  
  /// Constructor for TaskDetailScreen
  const TaskDetailScreen({
    super.key,
    required this.taskId,
  });
  
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, _) {
        final task = taskProvider.getTask(taskId);
        
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
              // Task completion toggle
              IconButton(
                icon: Icon(task.isCompleted
                    ? Icons.check_circle
                    : Icons.check_circle_outline),
                onPressed: () => taskProvider.toggleTaskCompletion(task.id),
                tooltip: task.isCompleted
                    ? 'Mark as incomplete'
                    : 'Mark as complete',
              ),
              // Edit button
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _navigateToEditTask(context, task),
                tooltip: 'Edit task',
              ),
              // Delete button
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _confirmDeleteTask(context, taskProvider, task),
                tooltip: 'Delete task',
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status badge for completed tasks
                if (task.isCompleted) ...[
                  _buildStatusBadge(
                    context,
                    'Completed',
                    Icons.check_circle,
                    Colors.green,
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Title section
                const Text(
                  'Title',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    color: task.isCompleted
                        ? Colors.grey
                        : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Priority section
                const Text(
                  'Priority',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                PriorityBadge(priority: task.priority),
                const SizedBox(height: 16),
                
                // Due date section
                if (task.dueDate != null) ...[
                  const Text(
                    'Due Date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDueDateInfo(context, task),
                  const SizedBox(height: 16),
                ],
                
                // Description section
                const Text(
                  'Description',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    task.description.isNotEmpty
                        ? task.description
                        : 'No description',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: task.description.isEmpty
                          ? FontStyle.italic
                          : FontStyle.normal,
                      color: task.description.isEmpty
                          ? Colors.grey
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Created date info
                Text(
                  'Created on ${DateFormat.yMMMMd().format(task.createdAt)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  /// Build a status badge for task states
  Widget _buildStatusBadge(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build due date info with overdue status
  Widget _buildDueDateInfo(BuildContext context, Task task) {
    final dueDate = task.dueDate!;
    final isOverdue = task.isOverdue;
    final isDueSoon = task.isDueSoon;
    
    Color textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    String statusText = '';
    Color statusColor = Colors.grey;
    
    if (isOverdue) {
      statusText = 'Overdue';
      statusColor = Colors.red;
      textColor = Colors.red;
    } else if (isDueSoon) {
      statusText = 'Due soon';
      statusColor = Colors.orange;
    } else if (task.isCompleted) {
      statusText = 'Completed';
      statusColor = Colors.green;
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
        border: Border.all(
          color: statusText.isNotEmpty
              ? statusColor.withOpacity(0.5)
              : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.event,
                color: textColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat.yMMMMd().format(dueDate),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          if (statusText.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  /// Navigate to edit task screen
  void _navigateToEditTask(BuildContext context, Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(task: task),
      ),
    );
  }
  
  /// Confirm task deletion
  void _confirmDeleteTask(
    BuildContext context,
    TaskProvider taskProvider,
    Task task,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text(
          'Are you sure you want to delete "${task.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              taskProvider.deleteTask(task.id);
              Navigator.of(context).pop(); // Pop detail screen
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}