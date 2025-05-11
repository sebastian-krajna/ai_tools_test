import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'constants/app_theme.dart';
import 'providers/task_provider.dart';
import 'repositories/task_repository.dart';
import 'screens/task_list_screen.dart';

/// Main entry point for the application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Create repository and provider instances
  final taskRepository = TaskRepository();
  await taskRepository.init();

  final taskProvider = TaskProvider(taskRepository);
  await taskProvider.init();

  runApp(
    // Provide the TaskProvider to the widget tree
    ChangeNotifierProvider.value(
      value: taskProvider,
      child: const MyApp(),
    ),
  );
}

/// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: AppTheme.getLightTheme(),
      home: const TaskListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
