import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/priority_helper.dart';

/// Widget for displaying a task's priority level
class PriorityBadge extends StatelessWidget {
  final TaskPriority priority;
  final bool showIcon;
  final bool showLabel;
  
  /// Constructor for the priority badge
  const PriorityBadge({
    super.key,
    required this.priority,
    this.showIcon = true,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = PriorityHelper.getColorForPriority(priority);
    final icon = PriorityHelper.getIconForPriority(priority);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(icon, size: 16, color: color),
            if (showLabel) const SizedBox(width: 4),
          ],
          if (showLabel)
            Text(
              priority.name,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}
