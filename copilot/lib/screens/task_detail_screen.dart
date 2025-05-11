import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../utils/app_theme.dart';
import '../utils/date_formatter.dart';
import 'task_form_screen.dart';

/// Screen for viewing task details
class TaskDetailScreen extends StatefulWidget {
  final Task task;
  
  const TaskDetailScreen({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Task _task;
  
  @override
  void initState() {
    super.initState();
    _task = widget.task;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOverdue = DateFormatter.isOverdue(_task.dueDate) && !_task.isCompleted;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Task',
            onPressed: _editTask,
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
                Text(
                  'Status:',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(width: 16),
                FilledButton.tonal(
                  onPressed: _toggleCompletion,
                  style: FilledButton.styleFrom(
                    backgroundColor: _task.isCompleted
                        ? Colors.green.withOpacity(0.2)
                        : theme.colorScheme.primaryContainer,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _task.isCompleted
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                        color: _task.isCompleted
                            ? Colors.green
                            : theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _task.isCompleted ? 'Completed' : 'Mark as completed',
                        style: TextStyle(
                          color: _task.isCompleted
                              ? Colors.green
                              : theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Task title
            Text(
              'Title',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _task.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  decoration: _task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Task priority
            Text(
              'Priority',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.getPriorityBackgroundColor(context, _task.priority),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.flag,
                    color: AppTheme.getPriorityColor(context, _task.priority),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _task.priority.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.getPriorityColor(context, _task.priority),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Due date
            if (_task.dueDate != null) ...[
              Text(
                'Due Date',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isOverdue
                      ? Colors.red.withOpacity(0.1)
                      : theme.colorScheme.primaryContainer.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: isOverdue
                          ? Colors.red
                          : theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormatter.formatDate(_task.dueDate!),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: isOverdue
                                ? Colors.red
                                : theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormatter.getRelativeDate(_task.dueDate),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isOverdue
                                ? Colors.red
                                : theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            
            // Description
            Text(
              'Description',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _task.description.isEmpty
                    ? 'No description provided'
                    : _task.description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: _task.description.isEmpty
                      ? theme.colorScheme.onSurfaceVariant.withOpacity(0.7)
                      : theme.colorScheme.onSurfaceVariant,
                  fontStyle: _task.description.isEmpty
                      ? FontStyle.italic
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Creation date
            Text(
              'Created',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormatter.formatDateTime(_task.createdAt),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Delete button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _confirmDelete,
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text('Delete Task', style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editTask() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(task: _task),
        fullscreenDialog: true,
      ),
    );
    
    if (result == true) {
      // Refresh task data
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final updatedTask = taskProvider.tasks.firstWhere((task) => task.id == _task.id);
      setState(() {
        _task = updatedTask;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task updated successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _toggleCompletion() {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    
    // Start animation
    if (!_task.isCompleted) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    
    // Update task
    taskProvider.toggleTaskCompletion(_task.id);
    
    // Update local task object
    setState(() {
      _task = _task.copyWith(isCompleted: !_task.isCompleted);
    });
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text(
          'Are you sure you want to delete this task? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false)
                  .deleteTask(_task.id);
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Return to list screen
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Task deleted'),
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}