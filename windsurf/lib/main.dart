import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/task_provider.dart';
import 'screens/task_list_screen.dart';
import 'utils/app_theme.dart';

/// Entry point for the application
void main() {
  runApp(const MyApp());
}

/// Root widget of the application
/// 
/// This widget sets up the provider for state management and defines
/// the overall theme and structure of the app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the app with a ChangeNotifierProvider to manage state
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        title: 'Modern Todo',
        debugShowCheckedModeBanner: false,
        // Apply the app theme from our theme utility
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.system, // Respect system theme setting
        home: const TaskListScreen(),
      ),
    );
  }
}
