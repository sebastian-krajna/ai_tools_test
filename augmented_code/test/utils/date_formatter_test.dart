import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/utils/date_formatter.dart';

void main() {
  group('DateFormatter Tests', () {
    test('formatDate should format date correctly', () {
      final date = DateTime(2023, 5, 15);
      expect(DateFormatter.formatDate(date), 'May 15, 2023');
    });
    
    test('formatDate should handle null date', () {
      expect(DateFormatter.formatDate(null), 'No due date');
    });
    
    test('formatDateWithTime should format date and time correctly', () {
      final date = DateTime(2023, 5, 15, 14, 30);
      expect(DateFormatter.formatDateWithTime(date), 'May 15, 2023 - 14:30');
    });
    
    test('formatDateWithTime should handle null date', () {
      expect(DateFormatter.formatDateWithTime(null), 'No due date');
    });
    
    test('getRelativeDateString should return "Today" for today', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day, 14, 30);
      expect(DateFormatter.getRelativeDateString(today), 'Today');
    });
    
    test('getRelativeDateString should return "Tomorrow" for tomorrow', () {
      final now = DateTime.now();
      final tomorrow = DateTime(now.year, now.month, now.day + 1, 14, 30);
      expect(DateFormatter.getRelativeDateString(tomorrow), 'Tomorrow');
    });
    
    test('getRelativeDateString should return "Yesterday" for yesterday', () {
      final now = DateTime.now();
      final yesterday = DateTime(now.year, now.month, now.day - 1, 14, 30);
      expect(DateFormatter.getRelativeDateString(yesterday), 'Yesterday');
    });
    
    test('getRelativeDateString should format other dates', () {
      final date = DateTime(2023, 5, 15);
      expect(DateFormatter.getRelativeDateString(date), 'May 15, 2023');
    });
    
    test('getRelativeDateString should handle null date', () {
      expect(DateFormatter.getRelativeDateString(null), 'No due date');
    });
    
    test('isOverdue should return true for past dates', () {
      final pastDate = DateTime.now().subtract(const Duration(days: 1));
      expect(DateFormatter.isOverdue(pastDate), true);
    });
    
    test('isOverdue should return false for future dates', () {
      final futureDate = DateTime.now().add(const Duration(days: 1));
      expect(DateFormatter.isOverdue(futureDate), false);
    });
    
    test('isOverdue should return false for null dates', () {
      expect(DateFormatter.isOverdue(null), false);
    });
  });
}
