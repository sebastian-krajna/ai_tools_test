import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'screens/task_list_screen.dart';
import 'services/storage_service.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage service
  final storageService = StorageService();
  await storageService.init();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskProvider(storageService)..loadTasks(),
        ),
      ],
      child: const TodoApp(),
    ),
  );
}

class TodoApp extends StatefulWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: AppTheme.getThemeData(context, isDarkMode: _isDarkMode),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: TaskListScreen(),
        // Theme toggle in bottom right corner
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        persistentFooterButtons: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
            tooltip: _isDarkMode ? 'Switch to light theme' : 'Switch to dark theme',
          ),
        ],
      ),
    );
  }
}
