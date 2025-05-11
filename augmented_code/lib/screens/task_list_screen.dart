import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/empty_task_list.dart';
import '../widgets/sort_options_bottom_sheet.dart';
import '../widgets/task_list_item.dart';
import 'task_form_screen.dart';
import 'task_details_screen.dart';

/// Screen for displaying the list of tasks
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  void initState() {
    super.initState();
    // Load tasks when the screen is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortOptions,
            tooltip: 'Sort tasks',
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final tasks = taskProvider.tasks;
          
          if (tasks.isEmpty) {
            return EmptyTaskList(
              onAddTask: () => _navigateToTaskForm(context),
            );
          }
          
          return AnimatedList(
            initialItemCount: tasks.length,
            itemBuilder: (context, index, animation) {
              final task = tasks[index];
              return _buildTaskItem(context, task, animation);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToTaskForm(context),
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskItem(
    BuildContext context,
    Task task,
    Animation<double> animation,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      )),
      child: FadeTransition(
        opacity: animation,
        child: TaskListItem(
          task: task,
          onTap: () => _navigateToTaskDetails(context, task),
          onCheckboxChanged: (value) {
            _toggleTaskCompletion(task);
          },
          onDelete: () => _deleteTask(task),
        ),
      ),
    );
  }

  void _navigateToTaskForm(BuildContext context, {Task? task}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(task: task),
      ),
    );
    
    if (result == true) {
      // Refresh the task list
      if (mounted) {
        Provider.of<TaskProvider>(context, listen: false).loadTasks();
      }
    }
  }

  void _navigateToTaskDetails(BuildContext context, Task task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsScreen(taskId: task.id),
      ),
    );
    
    if (result == true) {
      // Refresh the task list
      if (mounted) {
        Provider.of<TaskProvider>(context, listen: false).loadTasks();
      }
    }
  }

  void _toggleTaskCompletion(Task task) {
    Provider.of<TaskProvider>(context, listen: false)
        .toggleTaskCompletion(task.id);
  }

  void _deleteTask(Task task) {
    Provider.of<TaskProvider>(context, listen: false).deleteTask(task.id);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "${task.title}" deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            Provider.of<TaskProvider>(context, listen: false).addTask(task);
          },
        ),
      ),
    );
  }

  void _showSortOptions() {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SortOptionsBottomSheet(
        currentSortOption: taskProvider.sortOption,
        showCompletedFirst: taskProvider.showCompletedFirst,
        onSortOptionChanged: (option) {
          taskProvider.sortOption = option;
        },
        onShowCompletedFirstChanged: (value) {
          taskProvider.showCompletedFirst = value;
        },
      ),
    );
  }
}
