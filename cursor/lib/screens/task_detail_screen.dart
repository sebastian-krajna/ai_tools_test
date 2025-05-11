import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'task_form_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({
    Key? key,
    required this.task,
  }) : super(key: key);

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return 'High';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red.shade100;
      case TaskPriority.medium:
        return Colors.orange.shade100;
      case TaskPriority.low:
        return Colors.green.shade100;
    }
  }

  Color _getPriorityTextColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red.shade800;
      case TaskPriority.medium:
        return Colors.orange.shade800;
      case TaskPriority.low:
        return Colors.green.shade800;
    }
  }

  bool _isOverdue(Task task) {
    final now = DateTime.now();
    return !task.isCompleted && 
           task.dueDate.isBefore(DateTime(now.year, now.month, now.day));
  }

  void _deleteTask(BuildContext context) {
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
              Navigator.pop(context); // Return to home screen
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskFormScreen(task: task),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteTask(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and completion checkbox
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Provider.of<TaskProvider>(context, listen: false)
                      .toggleTaskCompletion(task.id);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: task.isCompleted 
                        ? Theme.of(context).colorScheme.primary 
                        : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: task.isCompleted 
                          ? Theme.of(context).colorScheme.primary 
                          : Theme.of(context).colorScheme.outline,
                        width: 2,
                      ),
                    ),
                    width: 24,
                    height: 24,
                    child: task.isCompleted 
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      decoration: task.isCompleted 
                        ? TextDecoration.lineThrough 
                        : null,
                      color: task.isCompleted
                        ? Theme.of(context).colorScheme.outline
                        : null,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Priority
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: _getPriorityColor(task.priority),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.flag,
                    size: 18,
                    color: _getPriorityTextColor(task.priority),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_getPriorityText(task.priority)} Priority',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getPriorityTextColor(task.priority),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Due date
            _buildDetailItem(
              context,
              'Due Date',
              dateFormat.format(task.dueDate),
              Icons.calendar_today,
              _isOverdue(task) ? Colors.red : null,
            ),
            
            const SizedBox(height: 8),
            
            // Created date
            _buildDetailItem(
              context,
              'Created',
              dateFormat.format(task.createdAt),
              Icons.access_time,
            ),
            
            const SizedBox(height: 24),
            
            // Description
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                task.description,
                style: TextStyle(
                  fontSize: 16,
                  color: task.isCompleted
                    ? Theme.of(context).colorScheme.outline
                    : null,
                  decoration: task.isCompleted 
                    ? TextDecoration.lineThrough 
                    : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    [Color? color]
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: color ?? Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.outline,
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }
} 