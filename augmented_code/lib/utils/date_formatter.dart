import 'package:intl/intl.dart';

/// Utility class for formatting dates
class DateFormatter {
  /// Format a date as 'MMM dd, yyyy' (e.g., "Jan 01, 2023")
  static String formatDate(DateTime? date) {
    if (date == null) return 'No due date';
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Format a date as 'MMM dd, yyyy - HH:mm' (e.g., "Jan 01, 2023 - 14:30")
  static String formatDateWithTime(DateTime? date) {
    if (date == null) return 'No due date';
    return DateFormat('MMM dd, yyyy - HH:mm').format(date);
  }

  /// Get a relative date string (e.g., "Today", "Tomorrow", "Yesterday", or formatted date)
  static String getRelativeDateString(DateTime? date) {
    if (date == null) return 'No due date';
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    final difference = dateOnly.difference(today).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference == -1) {
      return 'Yesterday';
    } else {
      return formatDate(date);
    }
  }

  /// Check if a date is overdue
  static bool isOverdue(DateTime? date) {
    if (date == null) return false;
    return date.isBefore(DateTime.now());
  }
}
