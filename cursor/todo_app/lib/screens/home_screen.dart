import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/task_item.dart';
import 'task_detail_screen.dart';
import 'task_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  SortOption _currentSortOption = SortOption.dueDate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Initialize task provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).initialize();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Sort Tasks By',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ...SortOption.values.map((option) {
                String optionName;
                IconData iconData;
                
                switch(option) {
                  case SortOption.priority:
                    optionName = 'Priority';
                    iconData = Icons.flag;
                    break;
                  case SortOption.dueDate:
                    optionName = 'Due Date';
                    iconData = Icons.calendar_today;
                    break;
                  case SortOption.completion:
                    optionName = 'Completion Status';
                    iconData = Icons.check_circle;
                    break;
                  case SortOption.creationDate:
                    optionName = 'Creation Date';
                    iconData = Icons.access_time;
                    break;
                }
                
                return ListTile(
                  leading: Icon(iconData),
                  title: Text(optionName),
                  trailing: _currentSortOption == option 
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                  onTap: () {
                    setState(() {
                      _currentSortOption = option;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task Manager',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort Tasks',
            onPressed: _showSortOptions,
          ),
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).isDarkMode 
                ? Icons.light_mode 
                : Icons.dark_mode,
            ),
            tooltip: 'Toggle Theme',
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final sortedTasks = taskProvider.getSortedTasks(_currentSortOption);
          
          return TabBarView(
            controller: _tabController,
            children: [
              // Active tasks tab
              _buildTaskList(
                sortedTasks.where((task) => !task.isCompleted).toList(),
                'No active tasks',
                'Add a new task to get started',
              ),
              
              // Completed tasks tab
              _buildTaskList(
                sortedTasks.where((task) => task.isCompleted).toList(),
                'No completed tasks',
                'Tasks you complete will appear here',
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks, String emptyTitle, String emptySubtitle) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 80,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            const SizedBox(height: 16),
            Text(
              emptyTitle,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              emptySubtitle,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskItem(
          task: task,
          onTaskTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailScreen(task: task),
              ),
            );
          },
        );
      },
    );
  }
} 