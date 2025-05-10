import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/widgets/priority_badge.dart';

void main() {
  testWidgets('PriorityBadge displays correct text for each priority level', (WidgetTester tester) async {
    // Build and verify the low priority badge
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PriorityBadge(priority: TaskPriority.low),
        ),
      ),
    );
    expect(find.text('Low'), findsOneWidget);
    
    // Build and verify the medium priority badge
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PriorityBadge(priority: TaskPriority.medium),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Medium'), findsOneWidget);
    
    // Build and verify the high priority badge
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PriorityBadge(priority: TaskPriority.high),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('High'), findsOneWidget);
  });
  
  testWidgets('PriorityBadge respects small parameter', (WidgetTester tester) async {
    // Build standard size badge
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PriorityBadge(priority: TaskPriority.medium),
        ),
      ),
    );
    
    final standardBadge = tester.widget<Container>(find.byType(Container));
    final standardPadding = standardBadge.padding as EdgeInsets;
    
    // Build small badge
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PriorityBadge(
            priority: TaskPriority.medium,
            small: true,
          ),
        ),
      ),
    );
    await tester.pump();
    
    final smallBadge = tester.widget<Container>(find.byType(Container));
    final smallPadding = smallBadge.padding as EdgeInsets;
    
    // Small badge should have smaller padding
    expect(smallPadding.horizontal, lessThan(standardPadding.horizontal));
    expect(smallPadding.vertical, lessThan(standardPadding.vertical));
  });
}