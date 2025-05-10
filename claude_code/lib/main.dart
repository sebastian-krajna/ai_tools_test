import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/providers/theme_provider.dart';
import 'package:todo_app/screens/task_list_screen.dart';
import 'package:todo_app/services/storage_service.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage service
  final storageService = StorageService();
  await storageService.init();
  
  // Initialize theme provider
  final themeProvider = ThemeProvider();
  await themeProvider.init();
  
  // Initialize task provider
  final taskProvider = TaskProvider(storageService);
  await taskProvider.init();
  
  // Run the app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ChangeNotifierProvider<TaskProvider>.value(value: taskProvider),
      ],
      child: const MyApp(),
    ),
  );
}

/// The main app widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'Todo App',
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          home: const TaskListScreen(),
        );
      },
    );
  }
}