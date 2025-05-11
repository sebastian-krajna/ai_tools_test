import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/task.dart';
import '../utils/date_formatter.dart';

/// Widget for displaying a task in a list
class TaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final Function(bool?) onCheckboxChanged;
  final VoidCallback onDelete;

  const TaskListItem({
    Key? key,
    required this.task,
    required this.onTap,
    required this.onCheckboxChanged,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOverdue = task.dueDate != null && 
        !task.isCompleted && 
        DateFormatter.isOverdue(task.dueDate);

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: Card(
        color: task.isCompleted 
            ? theme.colorScheme.surfaceVariant.withOpacity(0.5) 
            : theme.colorScheme.surface,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Row(
              children: [
                // Checkbox
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: task.isCompleted,
                      onChanged: onCheckboxChanged,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                
                // Priority indicator
                Container(
                  width: 4,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.getPriorityColor(task.priority),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Task content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        task.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          decoration: task.isCompleted 
                              ? TextDecoration.lineThrough 
                              : null,
                          color: task.isCompleted 
                              ? theme.colorScheme.onSurface.withOpacity(0.6) 
                              : theme.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      // Description
                      if (task.description.isNotEmpty)
                        Text(
                          task.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                            decoration: task.isCompleted 
                                ? TextDecoration.lineThrough 
                                : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      
                      // Due date
                      if (task.dueDate != null)
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 14,
                              color: isOverdue 
                                  ? Colors.red 
                                  : theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormatter.getRelativeDateString(task.dueDate),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isOverdue 
                                    ? Colors.red 
                                    : theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                
                // Priority badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.getPriorityColor(task.priority).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    task.priority.name,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.getPriorityColor(task.priority),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
