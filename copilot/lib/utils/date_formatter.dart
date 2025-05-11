import 'package:intl/intl.dart';

/// Utility class for formatting dates
class DateFormatter {
  /// Format a date to a readable string (e.g., "May 11, 2025")
  static String formatDate(DateTime date) {
    return DateFormat.yMMMMd().format(date);
  }
  
  /// Format a date to include time (e.g., "May 11, 2025 3:30 PM")
  static String formatDateTime(DateTime date) {
    return DateFormat.yMMMMd().add_jm().format(date);
  }
  
  /// Get a relative date string (e.g., "Today", "Tomorrow", "Yesterday", "In 3 days", "3 days ago")
  static String getRelativeDate(DateTime? date) {
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
    } else if (difference > 1) {
      return 'In $difference days';
    } else {
      return '${difference.abs()} days ago';
    }
  }
  
  /// Check if a due date is overdue
  static bool isOverdue(DateTime? dueDate) {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate.isBefore(now) && 
           !(dueDate.year == now.year && 
             dueDate.month == now.month && 
             dueDate.day == now.day);
  }
}