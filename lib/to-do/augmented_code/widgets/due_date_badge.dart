import 'package:flutter/material.dart';
import '../utils/date_formatter.dart';

/// Widget for displaying a task's due date status
class DueDateBadge extends StatelessWidget {
  final DateTime? dueDate;
  
  /// Constructor for the due date badge
  const DueDateBadge({
    super.key,
    required this.dueDate,
  });

  @override
  Widget build(BuildContext context) {
    if (dueDate == null) {
      return const SizedBox.shrink();
    }
    
    final isOverdue = DateFormatter.isOverdue(dueDate);
    final isToday = DateFormatter.isToday(dueDate);
    final isTomorrow = DateFormatter.isTomorrow(dueDate);
    
    Color color;
    IconData icon;
    String text;
    
    if (isOverdue) {
      color = Colors.red;
      icon = Icons.warning;
      text = 'Overdue';
    } else if (isToday) {
      color = Colors.orange;
      icon = Icons.today;
      text = 'Today';
    } else if (isTomorrow) {
      color = Colors.blue;
      icon = Icons.event;
      text = 'Tomorrow';
    } else {
      color = Colors.green;
      icon = Icons.event;
      text = DateFormatter.formatDate(dueDate);
    }
    
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
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            text,
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
