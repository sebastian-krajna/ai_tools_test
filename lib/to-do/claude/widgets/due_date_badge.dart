import 'package:flutter/material.dart';
import '../utils/date_formatter.dart';

/// Widget to display a task's due date as a badge
class DueDateBadge extends StatelessWidget {
  final DateTime? dueDate;
  final bool isOverdue;
  final bool isDueSoon;
  
  /// Constructor for DueDateBadge
  const DueDateBadge({
    super.key,
    required this.dueDate,
    this.isOverdue = false,
    this.isDueSoon = false,
  });
  
  @override
  Widget build(BuildContext context) {
    if (dueDate == null) {
      return const SizedBox.shrink();
    }
    
    Color color = Colors.grey;
    IconData icon = Icons.calendar_today;
    
    if (isOverdue) {
      color = Colors.red;
      icon = Icons.warning;
    } else if (isDueSoon) {
      color = Colors.orange;
      icon = Icons.timelapse;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            DateFormatter.formatRelativeDate(dueDate),
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: isOverdue || isDueSoon ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}