import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/task.dart';
import '../../providers/task_provider.dart';
import '../widgets/priority_badge.dart';
import 'task_form_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Task'),
                  content: const Text(
                    'Are you sure you want to delete this task?',
                  ),
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
                        Navigator.pop(context); // Go back to home
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and completion status
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    if (value != null) {
                      Provider.of<TaskProvider>(context, listen: false)
                          .toggleTaskCompletion(task.id);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Priority
            Row(
              children: [
                const Icon(Icons.flag, size: 20),
                const SizedBox(width: 8),
                const Text('Priority:'),
                const SizedBox(width: 8),
                PriorityBadge(priority: task.priority),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Due date
            if (task.dueDate != null) ...[
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 20),
                  const SizedBox(width: 8),
                  const Text('Due date:'),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('EEEE, MMMM d, y').format(task.dueDate!),
                    style: TextStyle(
                      color: task.isCompleted
                          ? null
                          : task.dueDate!.isBefore(DateTime.now())
                              ? Colors.red
                              : null,
                      fontWeight: task.isCompleted
                          ? null
                          : task.dueDate!.isBefore(DateTime.now())
                              ? FontWeight.bold
                              : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            
            // Description
            const Text(
              'Description:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                task.description.isEmpty
                    ? 'No description provided'
                    : task.description,
                style: TextStyle(
                  color: task.description.isEmpty
                      ? Theme.of(context).disabledColor
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
