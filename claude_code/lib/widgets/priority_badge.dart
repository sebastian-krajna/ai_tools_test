import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';

/// A widget that displays the priority level of a task
class PriorityBadge extends StatelessWidget {
  final TaskPriority priority;
  final bool small;

  const PriorityBadge({
    super.key,
    required this.priority,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6.0 : 8.0,
        vertical: small ? 2.0 : 4.0,
      ),
      decoration: BoxDecoration(
        color: _getPriorityColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(small ? 4.0 : 8.0),
        border: Border.all(
          color: _getPriorityColor(),
          width: 1.0,
        ),
      ),
      child: Text(
        priority.name,
        style: TextStyle(
          color: _getPriorityColor(),
          fontSize: small ? 10.0 : 12.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Get the color associated with the priority level
  Color _getPriorityColor() {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red.shade700;
      case TaskPriority.medium:
        return Colors.orange.shade700;
      case TaskPriority.low:
        return Colors.green.shade700;
    }
  }
}