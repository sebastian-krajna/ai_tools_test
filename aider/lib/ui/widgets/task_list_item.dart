import 'package:flutter/material.dart';
import '../../models/task.dart';
import 'priority_badge.dart';
import 'date_status_indicator.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final Function(bool?) onCompletionToggle;
  final VoidCallback onDelete;

  const TaskListItem({
    Key? key,
    required this.task,
    required this.onTap,
    required this.onCompletionToggle,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
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
                // Checkbox with animation
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: 0,
                    end: task.isCompleted ? 1.0 : 0.0,
                  ),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: 1.0 + (value * 0.2),
                      child: Checkbox(
                        value: task.isCompleted,
                        onChanged: onCompletionToggle,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                // Task content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          PriorityBadge(priority: task.priority, small: true),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      DateStatusIndicator(
                        dueDate: task.dueDate,
                        isCompleted: task.isCompleted,
                      ),
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
}
