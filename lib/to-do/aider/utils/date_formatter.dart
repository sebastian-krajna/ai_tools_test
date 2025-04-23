import 'package:intl/intl.dart';

/// Utility class for formatting dates
class DateFormatter {
  /// Format a date as "Month day, year" (e.g., "Jan 1, 2023")
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
  
  /// Format a date as "Month day, year at hour:minute" (e.g., "Jan 1, 2023 at 12:30 PM")
  static String formatDateWithTime(DateTime date) {
    return DateFormat('MMM dd, yyyy \'at\' h:mm a').format(date);
  }
  
  /// Get a relative date string (e.g., "Today", "Tomorrow", "Yesterday", or the formatted date)
  static String getRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == tomorrow) {
      return 'Tomorrow';
    } else if (dateOnly == yesterday) {
      return 'Yesterday';
    } else {
      return formatDate(date);
    }
  }
  
  /// Get a string describing how much time is left until the due date
  static String getTimeUntil(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);
    
    if (difference.isNegative) {
      // Past due
      final days = difference.inDays.abs();
      if (days == 0) {
        return 'Due today';
      } else if (days == 1) {
        return 'Overdue by 1 day';
      } else {
        return 'Overdue by $days days';
      }
    } else {
      // Due in the future
      final days = difference.inDays;
      if (days == 0) {
        return 'Due today';
      } else if (days == 1) {
        return 'Due tomorrow';
      } else {
        return 'Due in $days days';
      }
    }
  }
}
