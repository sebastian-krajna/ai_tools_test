import 'package:flutter/material.dart';
import 'package:todo_app/utils/date_formatter.dart';

/// A widget that displays the due date of a task
class DueDateBadge extends StatelessWidget {
  final DateTime? dueDate;
  final bool small;
  final bool isCompleted;

  const DueDateBadge({
    super.key,
    required this.dueDate,
    this.small = false,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    if (dueDate == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6.0 : 8.0,
        vertical: small ? 2.0 : 4.0,
      ),
      decoration: BoxDecoration(
        color: _getDueDateColor(context).withOpacity(0.2),
        borderRadius: BorderRadius.circular(small ? 4.0 : 8.0),
        border: Border.all(
          color: _getDueDateColor(context),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getDueDateIcon(),
            size: small ? 12.0 : 14.0,
            color: _getDueDateColor(context),
          ),
          const SizedBox(width: 4.0),
          Text(
            DateFormatter.formatRelativeDate(dueDate),
            style: TextStyle(
              color: _getDueDateColor(context),
              fontSize: small ? 10.0 : 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Get the icon associated with the due date status
  IconData _getDueDateIcon() {
    if (isCompleted) {
      return Icons.check_circle_outline;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    
    if (dueDay.isBefore(today)) {
      return Icons.warning_amber;
    } else if (dueDay.isAtSameMomentAs(today)) {
      return Icons.today;
    } else if (dueDay.difference(today).inDays <= 2) {
      return Icons.upcoming;
    } else {
      return Icons.event;
    }
  }

  /// Get the color associated with the due date status
  Color _getDueDateColor(BuildContext context) {
    if (isCompleted) {
      return Colors.grey;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    
    if (dueDay.isBefore(today)) {
      return Colors.red.shade700;
    } else if (dueDay.isAtSameMomentAs(today)) {
      return Colors.orange.shade700;
    } else if (dueDay.difference(today).inDays <= 2) {
      return Colors.blue.shade700;
    } else {
      return Colors.green.shade700;
    }
  }
}