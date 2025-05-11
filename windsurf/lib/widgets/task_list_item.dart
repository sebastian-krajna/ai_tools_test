import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/date_formatter.dart';

/// Widget representing a single task in a list
class TaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final Function(bool?) onCheckboxChanged;
  final VoidCallback onDelete;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onTap,
    required this.onCheckboxChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
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

    // Create a dismissible card for swipe-to-delete functionality
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Animated checkbox for task completion
                AnimatedScale(
                  scale: task.isCompleted ? 1.2 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Checkbox(
                    value: task.isCompleted,
                    onChanged: onCheckboxChanged,
                    activeColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Task content (title, due date, priority indicator)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Priority indicator
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: getPriorityColor(),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Task title with strike-through if completed
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
                                    ? theme.disabledColor
                                    : null,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (task.dueDate != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.event,
                              size: 14,
                              color: DateFormatter.isOverdue(task.dueDate) && !task.isCompleted
                                  ? Colors.red
                                  : theme.hintColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormatter.getRelativeDateDescription(task.dueDate),
                              style: TextStyle(
                                fontSize: 12,
                                color: DateFormatter.isOverdue(task.dueDate) && !task.isCompleted
                                    ? Colors.red
                                    : theme.hintColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // Priority text badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: getPriorityColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    task.priority.name,
                    style: TextStyle(
                      fontSize: 12,
                      color: getPriorityColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
