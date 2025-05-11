import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_list_item.dart';
import 'edit_task_screen.dart';
import 'task_detail_screen.dart';

/// Main screen displaying the list of tasks with filtering and sorting options
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  SortCriteria _currentSortCriteria = SortCriteria.priority;
  bool _showCompletedTasks = true;
  
  @override
  void initState() {
    super.initState();
    // Initialize task data when screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modern Todo'),
        actions: [
          // Sort button
          PopupMenuButton<SortCriteria>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort tasks',
            onSelected: _handleSortSelection,
            itemBuilder: (context) => [
              _buildPopupMenuItem(
                SortCriteria.priority,
                'Priority',
                Icons.flag,
              ),
              _buildPopupMenuItem(
                SortCriteria.dueDate,
                'Due Date',
                Icons.calendar_today,
              ),
              _buildPopupMenuItem(
                SortCriteria.completed,
                'Completion Status',
                Icons.check_circle_outline,
              ),
              _buildPopupMenuItem(
                SortCriteria.title,
                'Title',
                Icons.sort_by_alpha,
              ),
              _buildPopupMenuItem(
                SortCriteria.creationDate,
                'Creation Date',
                Icons.access_time,
              ),
            ],
          ),
          // Toggle completed tasks visibility
          IconButton(
            icon: Icon(
              _showCompletedTasks
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
            tooltip: _showCompletedTasks
                ? 'Hide completed tasks'
                : 'Show completed tasks',
            onPressed: _toggleCompletedTasksVisibility,
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (taskProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${taskProvider.error}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      taskProvider.initialize();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Filter tasks based on completion status if needed
          final tasks = _showCompletedTasks
              ? taskProvider.tasks
              : taskProvider.getTasksByCompletionStatus(false);

          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 80,
                    color: Theme.of(context).disabledColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add a new task',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
            );
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: ListView.builder(
              key: ValueKey<int>(tasks.length),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskListItem(
                  task: task,
                  onTap: () => _navigateToTaskDetail(task.id),
                  onCheckboxChanged: (value) {
                    taskProvider.toggleTaskCompletion(task.id);
                  },
                  onDelete: () => _deleteTask(task.id),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTask,
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Helper method to build consistent popup menu items
  PopupMenuItem<SortCriteria> _buildPopupMenuItem(
    SortCriteria criteria,
    String title,
    IconData iconData,
  ) {
    return PopupMenuItem<SortCriteria>(
      value: criteria,
      child: Row(
        children: [
          Icon(
            iconData,
            color: _currentSortCriteria == criteria
                ? Theme.of(context).colorScheme.primary
                : null,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: _currentSortCriteria == criteria
                  ? FontWeight.bold
                  : null,
              color: _currentSortCriteria == criteria
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
          ),
          if (_currentSortCriteria == criteria) ...[
            const Spacer(),
            Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.primary,
              size: 16,
            ),
          ],
        ],
      ),
    );
  }

  // Handle sort criteria selection
  void _handleSortSelection(SortCriteria criteria) {
    setState(() {
      _currentSortCriteria = criteria;
    });
    Provider.of<TaskProvider>(context, listen: false).sortTasks(criteria);
  }

  // Toggle visibility of completed tasks
  void _toggleCompletedTasksVisibility() {
    setState(() {
      _showCompletedTasks = !_showCompletedTasks;
    });
  }

  // Navigate to add task screen
  void _addNewTask() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditTaskScreen(),
      ),
    );
  }

  // Navigate to task detail screen
  void _navigateToTaskDetail(String taskId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(taskId: taskId),
      ),
    );
  }

  // Delete a task by its ID
  void _deleteTask(String taskId) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final taskName = taskProvider.tasks
        .firstWhere((task) => task.id == taskId)
        .title;
    
    taskProvider.deleteTask(taskId);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "$taskName" deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // This would require additional functionality to implement
            // For now, just show a message that it's not implemented
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Undo functionality not implemented'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }
}
