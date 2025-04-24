import 'package:intl/intl.dart';

/// Utility class for formatting dates
class DateFormatter {
  /// Format a date as 'MMM d, yyyy' (e.g., "Jan 1, 2023")
  static String formatDate(DateTime? date) {
    if (date == null) return 'No due date';
    return DateFormat.yMMMd().format(date);
  }
  
  /// Format a date as 'MMM d, yyyy - h:mm a' (e.g., "Jan 1, 2023 - 2:30 PM")
  static String formatDateWithTime(DateTime? date) {
    if (date == null) return 'No due date';
    return DateFormat('MMM d, yyyy - h:mm a').format(date);
  }
  
  /// Get a relative date string (e.g., "Today", "Tomorrow", "Yesterday", or formatted date)
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
    } else {
      return formatDate(date);
    }
  }
  
  /// Check if a date is overdue
  static bool isOverdue(DateTime? date) {
    if (date == null) return false;
    return date.isBefore(DateTime.now());
  }
  
  /// Check if a date is today
  static bool isToday(DateTime? date) {
    if (date == null) return false;
    
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }
  
  /// Check if a date is tomorrow
  static bool isTomorrow(DateTime? date) {
    if (date == null) return false;
    
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return date.year == tomorrow.year && 
           date.month == tomorrow.month && 
           date.day == tomorrow.day;
  }
}
