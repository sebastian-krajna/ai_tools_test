import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../screens/task_detail_screen.dart';
import '../utils/app_theme.dart';
import '../utils/date_formatter.dart';

/// Widget for displaying a task item in the task list
class TaskItem extends StatelessWidget {
  final Task task;
  
  const TaskItem({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOverdue = DateFormatter.isOverdue(task.dueDate) && !task.isCompleted;
    
    return Slidable(
      key: ValueKey(task.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () {
            Provider.of<TaskProvider>(context, listen: false)
                .deleteTask(task.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Task deleted'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    Provider.of<TaskProvider>(context, listen: false)
                        .addTask(task);
                  },
                ),
              ),
            );
          },
        ),
        children: [
          SlidableAction(
            onPressed: (context) {
              Provider.of<TaskProvider>(context, listen: false)
                  .deleteTask(task.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Task deleted'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      Provider.of<TaskProvider>(context, listen: false)
                          .addTask(task);
                    },
                  ),
                ),
              );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (context) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TaskDetailScreen(task: task),
                ),
              );
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: task.isCompleted
            ? theme.colorScheme.surfaceVariant
            : theme.colorScheme.surface,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TaskDetailScreen(task: task),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox for completion status
                Transform.scale(
                  scale: 1.2,
                  child: Container(
                    margin: const EdgeInsets.only(right: 16.0, top: 2.0),
                    child: Checkbox(
                      value: task.isCompleted,
                      activeColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (bool? value) {
                        // Animate completion status change
                        Provider.of<TaskProvider>(context, listen: false)
                            .toggleTaskCompletion(task.id);
                      },
                    ),
                  ),
                ),
                // Task details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title with priority indicator
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.getPriorityColor(context, task.priority),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              task.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task.isCompleted
                                    ? theme.colorScheme.onSurfaceVariant.withOpacity(0.7)
                                    : theme.colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Description (if available)
                      if (task.description.isNotEmpty)
                        Text(
                          task.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.isCompleted
                                ? theme.colorScheme.onSurfaceVariant.withOpacity(0.7)
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 8),
                      // Due date
                      if (task.dueDate != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isOverdue 
                                ? Colors.red.withOpacity(0.1)
                                : theme.colorScheme.primaryContainer.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: isOverdue
                                    ? Colors.red
                                    : theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormatter.getRelativeDate(task.dueDate),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isOverdue
                                      ? Colors.red
                                      : theme.colorScheme.primary,
                                  fontWeight: isOverdue
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
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