import 'package:intl/intl.dart';

/// Utility class to handle date formatting operations
class DateFormatter {
  /// Format a DateTime to a readable string (e.g., "May 15, 2025")
  static String formatDate(DateTime? date) {
    if (date == null) return 'No due date';
    return DateFormat.yMMMMd().format(date);
  }

  /// Format a DateTime to include time (e.g., "May 15, 2025 at 3:30 PM")
  static String formatDateWithTime(DateTime? date) {
    if (date == null) return 'No due date';
    return DateFormat('MMMM d, y \'at\' h:mm a').format(date);
  }

  /// Check if a date is in the past
  static bool isOverdue(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.isBefore(now) && 
           !(date.year == now.year && 
             date.month == now.month && 
             date.day == now.day);
  }

  /// Check if a date is today
  static bool isToday(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  /// Get relative date description (e.g., "Today", "Tomorrow", "3 days left")
  static String getRelativeDateDescription(DateTime? date) {
    if (date == null) return 'No due date';
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(date.year, date.month, date.day);
    final difference = dueDate.difference(today).inDays;
    
    if (difference < 0) return 'Overdue by ${-difference} day${-difference > 1 ? 's' : ''}';
    if (difference == 0) return 'Due today';
    if (difference == 1) return 'Due tomorrow';
    return '$difference days left';
  }
}
