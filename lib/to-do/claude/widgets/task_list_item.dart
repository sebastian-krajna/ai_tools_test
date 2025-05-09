import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/constants.dart';
import 'priority_badge.dart';
import 'due_date_badge.dart';

/// Widget to display a single task in the list
class TaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final Function(bool) onCompletionToggle;
  final VoidCallback onDelete;
  
  /// Constructor for TaskListItem
  const TaskListItem({
    super.key,
    required this.task,
    required this.onTap,
    required this.onCompletionToggle,
    required this.onDelete,
  });
  
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.smallPadding,
          vertical: AppConstants.smallPadding / 2,
        ),
        elevation: 1,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Row(
              children: [
                // Task completion checkbox
                _buildCompletionCheckbox(context),
                const SizedBox(width: 12),
                
                // Task details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title row with priority indicator
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task.isCompleted
                                    ? Colors.grey
                                    : Theme.of(context).textTheme.bodyLarge?.color,
                              ),
                            ),
                          ),
                          PriorityBadge(
                            priority: task.priority,
                            compact: true,
                          ),
                        ],
                      ),
                      
                      // Description
                      if (task.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ],
                      
                      // Due date and status badges
                      if (task.dueDate != null) ...[
                        const SizedBox(height: 8),
                        DueDateBadge(
                          dueDate: task.dueDate,
                          isOverdue: task.isOverdue,
                          isDueSoon: task.isDueSoon,
                        ),
                      ],
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
  
  /// Build the task completion checkbox with animation
  Widget _buildCompletionCheckbox(BuildContext context) {
    return InkWell(
      onTap: () => onCompletionToggle(!task.isCompleted),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: AppConstants.shortAnimationDuration,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: task.isCompleted
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          border: Border.all(
            color: task.isCompleted
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(2),
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
    );
  }
  
  /// Show confirmation dialog before deleting a task
  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text(
          'Are you sure you want to delete "${task.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    ) ?? false;
  }
}