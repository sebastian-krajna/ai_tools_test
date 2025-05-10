import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/utils/date_formatter.dart';
import 'package:todo_app/widgets/due_date_badge.dart';
import 'package:todo_app/widgets/priority_badge.dart';

/// A widget that displays a single task item in a list
class TaskListItem extends StatelessWidget {
  final Task task;
  final Function(String) onToggleCompletion;
  final Function(String) onDelete;
  final Function(String) onEdit;
  final Function(String) onTap;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onToggleCompletion,
    required this.onDelete,
    required this.onEdit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(task.id),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        dismissible: DismissiblePane(
          onDismissed: () => onDelete(task.id),
          closeOnCancel: true,
          confirmDismiss: () async {
            return await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Task'),
                content: Text('Are you sure you want to delete "${task.title}"?'),
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
            ) ??
                false;
          },
        ),
        children: [
          SlidableAction(
            onPressed: (context) => onEdit(task.id),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
          ),
          SlidableAction(
            onPressed: (context) => onDelete(task.id),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        elevation: 1,
        child: InkWell(
          onTap: () => onTap(task.id),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) => onToggleCompletion(task.id),
                    shape: const CircleBorder(),
                  ),
                ),
                const SizedBox(width: 8),
                // Task content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Task title
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
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (task.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: task.isCompleted
                                ? Colors.grey
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      // Badges row
                      Row(
                        children: [
                          PriorityBadge(
                            priority: task.priority,
                            small: true,
                          ),
                          const SizedBox(width: 8),
                          if (task.dueDate != null)
                            DueDateBadge(
                              dueDate: task.dueDate,
                              isCompleted: task.isCompleted,
                              small: true,
                            ),
                        ],
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