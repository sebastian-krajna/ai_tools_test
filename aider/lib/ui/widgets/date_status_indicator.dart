import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateStatusIndicator extends StatelessWidget {
  final DateTime? dueDate;
  final bool isCompleted;

  const DateStatusIndicator({
    Key? key,
    required this.dueDate,
    required this.isCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (dueDate == null) {
      return const Text('No due date');
    }

    final now = DateTime.now();
    final isOverdue = dueDate!.isBefore(now) && !isCompleted;
    final isDueSoon = !isOverdue && 
        dueDate!.difference(now).inDays < 2 && 
        !isCompleted;

    final dateStr = DateFormat('MMM d, y').format(dueDate!);
    
    return Row(
      children: [
        Icon(
          isOverdue 
              ? Icons.warning_amber_rounded 
              : isDueSoon 
                  ? Icons.access_time_filled_rounded 
                  : Icons.event,
          size: 16,
          color: isOverdue 
              ? Colors.red 
              : isDueSoon 
                  ? Colors.orange 
                  : null,
        ),
        const SizedBox(width: 4),
        Text(
          dateStr,
          style: TextStyle(
            color: isOverdue 
                ? Colors.red 
                : isDueSoon 
                    ? Colors.orange 
                    : null,
            fontWeight: isOverdue || isDueSoon ? FontWeight.bold : null,
          ),
        ),
      ],
    );
  }
}
