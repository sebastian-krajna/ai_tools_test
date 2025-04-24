import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../models/task.dart';
import '../widgets/priority_badge.dart';

void main() {
  testWidgets('PriorityBadge displays correct priority with icon and label', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: PriorityBadge(
              priority: TaskPriority.high,
              showIcon: true,
              showLabel: true,
            ),
          ),
        ),
      ),
    );
    
    // Verify that the widget displays the correct text
    expect(find.text('High'), findsOneWidget);
    
    // Verify that the widget contains an icon
    expect(find.byType(Icon), findsOneWidget);
  });
  
  testWidgets('PriorityBadge displays only icon when showLabel is false', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: PriorityBadge(
              priority: TaskPriority.medium,
              showIcon: true,
              showLabel: false,
            ),
          ),
        ),
      ),
    );
    
    // Verify that the widget does not display the text
    expect(find.text('Medium'), findsNothing);
    
    // Verify that the widget contains an icon
    expect(find.byType(Icon), findsOneWidget);
  });
  
  testWidgets('PriorityBadge displays only label when showIcon is false', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: PriorityBadge(
              priority: TaskPriority.low,
              showIcon: false,
              showLabel: true,
            ),
          ),
        ),
      ),
    );
    
    // Verify that the widget displays the correct text
    expect(find.text('Low'), findsOneWidget);
    
    // Verify that the widget does not contain an icon
    expect(find.byType(Icon), findsNothing);
  });
}
