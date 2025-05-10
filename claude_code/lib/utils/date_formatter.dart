import 'package:intl/intl.dart';

/// Utility class for date formatting operations
class DateFormatter {
  /// Format a date as 'MMM d, yyyy' (e.g., 'Jan 1, 2023')
  static String formatDate(DateTime? date) {
    if (date == null) return 'No date';
    return DateFormat.yMMMd().format(date);
  }
  
  /// Format a date as relative to today (Today, Tomorrow, Yesterday, or formatted date)
  static String formatRelativeDate(DateTime? date) {
    if (date == null) return 'No date';
    
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
    } else if (difference > 1 && difference < 7) {
      // Return day of week for dates within a week
      return DateFormat('EEEE').format(date);
    } else {
      return formatDate(date);
    }
  }
  
  /// Format a time as 'h:mm a' (e.g., '2:30 PM')
  static String formatTime(DateTime? time) {
    if (time == null) return '';
    return DateFormat.jm().format(time);
  }
  
  /// Format a date and time (e.g., 'Jan 1, 2023 at 2:30 PM')
  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'No date';
    return '${formatDate(dateTime)} at ${formatTime(dateTime)}';
  }
  
  /// Get "X days left" or "X days overdue" text
  static String getDaysRemainingText(DateTime? dueDate) {
    if (dueDate == null) return '';
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(dueDate.year, dueDate.month, dueDate.day);
    
    final daysRemaining = dueDay.difference(today).inDays;
    
    if (daysRemaining > 0) {
      return daysRemaining == 1 ? '1 day left' : '$daysRemaining days left';
    } else if (daysRemaining < 0) {
      final daysOverdue = daysRemaining.abs();
      return daysOverdue == 1 ? '1 day overdue' : '$daysOverdue days overdue';
    } else {
      return 'Due today';
    }
  }
}