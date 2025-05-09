import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/constants.dart';

/// Widget to display a task's priority level as a badge
class PriorityBadge extends StatelessWidget {
  final TaskPriority priority;
  final bool compact;
  
  /// Constructor for PriorityBadge
  const PriorityBadge({
    super.key,
    required this.priority,
    this.compact = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final color = AppConstants.getPriorityColor(priority, isDarkMode: isDark);
    
    if (compact) {
      return Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      );
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            priority.emoji,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 4),
          Text(
            priority.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}