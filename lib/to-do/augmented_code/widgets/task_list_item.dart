import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/date_formatter.dart';
import 'priority_badge.dart';
import 'due_date_badge.dart';

/// Widget for displaying a task in the list
class TaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final ValueChanged<bool?> onCompletionToggle;
  final VoidCallback onDelete;
  
  /// Constructor for the task list item
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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Checkbox for completion status
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: task.isCompleted,
                    onChanged: onCompletionToggle,
                    shape: const CircleBorder(),
                  ),
                ),
                const SizedBox(width: 8),
                // Task details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title with strike-through if completed
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.isCompleted
                              ? Colors.grey
                              : Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      if (task.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[600],
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      // Priority and due date badges
                      Row(
                        children: [
                          PriorityBadge(priority: task.priority),
                          const SizedBox(width: 8),
                          if (task.dueDate != null)
                            DueDateBadge(dueDate: task.dueDate),
                        ],
                      ),
                    ],
                  ),
                ),
                // Chevron icon
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
