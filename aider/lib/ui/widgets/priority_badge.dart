import 'package:flutter/material.dart';
import '../../models/task.dart';

class PriorityBadge extends StatelessWidget {
  final TaskPriority priority;
  final bool small;

  const PriorityBadge({
    Key? key,
    required this.priority,
    this.small = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (priority) {
      case TaskPriority.high:
        color = Colors.red;
        label = 'High';
        break;
      case TaskPriority.medium:
        color = Colors.orange;
        label = 'Medium';
        break;
      case TaskPriority.low:
        color = Colors.green;
        label = 'Low';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 10,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: small ? 10 : 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
