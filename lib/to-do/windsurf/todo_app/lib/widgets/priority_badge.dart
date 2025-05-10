import 'package:flutter/material.dart';
import '../models/task.dart';

/// A widget that displays the priority level of a task as a badge
class PriorityBadge extends StatelessWidget {
  /// The priority to display
  final TaskPriority priority;
  
  /// The size of the badge
  final double size;

  /// Constructor
  const PriorityBadge({
    super.key,
    required this.priority,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getPriorityColor(),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          _getPriorityIcon(),
          color: Colors.white,
          size: size * 0.6,
        ),
      ),
    );
  }

  /// Returns the appropriate color for the priority level
  Color _getPriorityColor() {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
    }
  }

  /// Returns the appropriate icon for the priority level
  IconData _getPriorityIcon() {
    switch (priority) {
      case TaskPriority.low:
        return Icons.arrow_downward;
      case TaskPriority.medium:
        return Icons.remove;
      case TaskPriority.high:
        return Icons.arrow_upward;
    }
  }
}
