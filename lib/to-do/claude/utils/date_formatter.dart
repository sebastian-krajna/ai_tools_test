import 'package:intl/intl.dart';

/// Utility class for date formatting operations
class DateFormatter {
  /// Format a date as a relative timeframe
  /// Returns today, tomorrow, yesterday, or the formatted date
  static String formatRelativeDate(DateTime? date) {
    if (date == null) {
      return 'No date';
    }
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateWithoutTime = DateTime(date.year, date.month, date.day);
    
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));
    
    if (dateWithoutTime == today) {
      return 'Today';
    } else if (dateWithoutTime == tomorrow) {
      return 'Tomorrow';
    } else if (dateWithoutTime == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat.MMMd().format(date);
    }
  }
  
  /// Format a date with time
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, y - h:mm a').format(dateTime);
  }
  
  /// Format just the date
  static String formatDate(DateTime dateTime) {
    return DateFormat('MMM d, y').format(dateTime);
  }
  
  /// Get time ago string (e.g., "2 hours ago", "5 days ago")
  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year(s) ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month(s) ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day(s) ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour(s) ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute(s) ago';
    } else {
      return 'Just now';
    }
  }
}