import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_item.dart';
import 'task_form_screen.dart';
import 'task_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SortOption _currentSortOption = SortOption.dueDate;
  bool _showCompletedTasks = true;

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final isLoading = taskProvider.isLoading;
    
    List<Task> tasks = _showCompletedTasks 
        ? taskProvider.tasks 
        : taskProvider.pendingTasks;
    
    tasks = taskProvider.sortTasks(tasks, _currentSortOption);

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showSortOptions,
          ),
          IconButton(
            icon: Icon(_showCompletedTasks 
                ? Icons.check_circle 
                : Icons.check_circle_outline),
            onPressed: () {
              setState(() {
                _showCompletedTasks = !_showCompletedTasks;
              });
            },
            tooltip: _showCompletedTasks 
                ? 'Hide completed tasks' 
                : 'Show completed tasks',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tasks.isEmpty
              ? _buildEmptyState()
              : _buildTaskList(tasks),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToTaskForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.task_alt,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks yet',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add a new task',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: TaskItem(
            task: task,
            onTap: () => _navigateToTaskDetails(context, task),
            onToggleComplete: () {
              Provider.of<TaskProvider>(context, listen: false)
                  .toggleTaskCompletion(task.id);
            },
          ),
        );
      },
    );
  }

  void _navigateToTaskForm(BuildContext context, {Task? task}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(task: task),
      ),
    );
  }

  void _navigateToTaskDetails(BuildContext context, Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsScreen(task: task),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Sort by Priority'),
                leading: const Icon(Icons.priority_high),
                selected: _currentSortOption == SortOption.priority,
                onTap: () {
                  setState(() {
                    _currentSortOption = SortOption.priority;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Sort by Due Date'),
                leading: const Icon(Icons.calendar_today),
                selected: _currentSortOption == SortOption.dueDate,
                onTap: () {
                  setState(() {
                    _currentSortOption = SortOption.dueDate;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Sort by Completion Status'),
                leading: const Icon(Icons.check_circle),
                selected: _currentSortOption == SortOption.completionStatus,
                onTap: () {
                  setState(() {
                    _currentSortOption = SortOption.completionStatus;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
} 