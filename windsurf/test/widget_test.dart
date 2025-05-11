// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:modern_todo_app/main.dart';
import 'package:modern_todo_app/providers/task_provider.dart';
import 'package:modern_todo_app/screens/task_list_screen.dart';

void main() {
  testWidgets('App loads with correct title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is displayed
    expect(find.text('Modern Todo'), findsOneWidget);
    
    // Verify that the TaskListScreen is the home page
    expect(find.byType(TaskListScreen), findsOneWidget);
    
    // Verify that the add task button is present
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
  
  testWidgets('Provider is properly set up', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    
    // Verify that we can find a Provider ancestor in the widget tree
    final BuildContext context = tester.element(find.byType(TaskListScreen));
    expect(Provider.of<TaskProvider>(context, listen: false), isNotNull);
  });
}
