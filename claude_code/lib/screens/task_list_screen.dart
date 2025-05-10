import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/providers/theme_provider.dart';
import 'package:todo_app/screens/task_detail_screen.dart';
import 'package:todo_app/screens/task_form_screen.dart';
import 'package:todo_app/widgets/empty_state.dart';
import 'package:todo_app/widgets/task_list_item.dart';

/// The main screen displaying the list of tasks
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        centerTitle: false,
        actions: [
          _buildSortButton(),
          _buildFilterButton(),
          _buildThemeToggle(),
        ],
      ),
      body: _buildTaskList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTask,
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Build the task list with animations for changes
  Widget _buildTaskList() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final tasks = taskProvider.tasks;

        if (tasks.isEmpty) {
          return _buildEmptyState(context);
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: ListView.builder(
            key: ValueKey<int>(tasks.length),
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return _buildTaskItemWithAnimation(task, index);
            },
          ),
        );
      },
    );
  }

  /// Build a task item with a slide transition animation
  Widget _buildTaskItemWithAnimation(Task task, int index) {
    return AnimatedSlide(
      offset: Offset.zero,
      duration: Duration(milliseconds: 300 + (index * 50)),
      curve: Curves.easeOutQuart,
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 300 + (index * 50)),
        curve: Curves.easeOutQuart,
        child: TaskListItem(
          key: ValueKey(task.id),
          task: task,
          onToggleCompletion: _toggleTaskCompletion,
          onDelete: _deleteTask,
          onEdit: _editTask,
          onTap: _viewTaskDetails,
        ),
      ),
    );
  }

  /// Build the empty state widget when no tasks exist
  Widget _buildEmptyState(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    
    switch (taskProvider.currentFilter) {
      case TaskFilter.completed:
        return const EmptyState(
          message: 'No completed tasks yet',
          icon: Icons.check_circle_outline,
        );
      case TaskFilter.active:
        return EmptyState(
          message: 'No active tasks',
          icon: Icons.assignment_outlined,
          actionLabel: 'Add Task',
          onAction: _addNewTask,
        );
      case TaskFilter.all:
      default:
        return EmptyState(
          message: 'No tasks yet. Create your first task!',
          icon: Icons.note_add,
          actionLabel: 'Add Task',
          onAction: _addNewTask,
        );
    }
  }

  /// Build the sort button and popup menu
  Widget _buildSortButton() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, _) {
        return PopupMenuButton<TaskSort>(
          icon: const Icon(Icons.sort),
          tooltip: 'Sort',
          onSelected: taskProvider.setSort,
          itemBuilder: (context) => [
            _buildSortMenuItem(
              context: context,
              title: 'Priority',
              icon: Icons.priority_high,
              value: TaskSort.priority,
              currentSort: taskProvider.currentSort,
              isAscending: taskProvider.sortAscending,
            ),
            _buildSortMenuItem(
              context: context,
              title: 'Due Date',
              icon: Icons.calendar_today,
              value: TaskSort.dueDate,
              currentSort: taskProvider.currentSort,
              isAscending: taskProvider.sortAscending,
            ),
            _buildSortMenuItem(
              context: context,
              title: 'Title',
              icon: Icons.sort_by_alpha,
              value: TaskSort.title,
              currentSort: taskProvider.currentSort,
              isAscending: taskProvider.sortAscending,
            ),
            _buildSortMenuItem(
              context: context,
              title: 'Created Date',
              icon: Icons.access_time,
              value: TaskSort.createdAt,
              currentSort: taskProvider.currentSort,
              isAscending: taskProvider.sortAscending,
            ),
          ],
        );
      },
    );
  }

  /// Build a single sort menu item
  PopupMenuItem<TaskSort> _buildSortMenuItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required TaskSort value,
    required TaskSort currentSort,
    required bool isAscending,
  }) {
    final isSelected = currentSort == value;
    
    return PopupMenuItem<TaskSort>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : null,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
          ),
          const Spacer(),
          if (isSelected)
            Icon(
              isAscending ? Icons.arrow_upward : Icons.arrow_downward,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
        ],
      ),
    );
  }

  /// Build the filter button and popup menu
  Widget _buildFilterButton() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, _) {
        return PopupMenuButton<TaskFilter>(
          icon: const Icon(Icons.filter_list),
          tooltip: 'Filter',
          onSelected: taskProvider.setFilter,
          itemBuilder: (context) => [
            _buildFilterMenuItem(
              context: context,
              title: 'All',
              icon: Icons.list,
              value: TaskFilter.all,
              currentFilter: taskProvider.currentFilter,
            ),
            _buildFilterMenuItem(
              context: context,
              title: 'Active',
              icon: Icons.radio_button_unchecked,
              value: TaskFilter.active,
              currentFilter: taskProvider.currentFilter,
            ),
            _buildFilterMenuItem(
              context: context,
              title: 'Completed',
              icon: Icons.check_circle_outline,
              value: TaskFilter.completed,
              currentFilter: taskProvider.currentFilter,
            ),
          ],
        );
      },
    );
  }

  /// Build a single filter menu item
  PopupMenuItem<TaskFilter> _buildFilterMenuItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required TaskFilter value,
    required TaskFilter currentFilter,
  }) {
    final isSelected = currentFilter == value;
    
    return PopupMenuItem<TaskFilter>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : null,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
          ),
          const Spacer(),
          if (isSelected)
            Icon(
              Icons.check,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
        ],
      ),
    );
  }

  /// Build the theme toggle button
  Widget _buildThemeToggle() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return IconButton(
          icon: Icon(
            themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
          ),
          tooltip: 'Toggle Theme',
          onPressed: themeProvider.toggleTheme,
        );
      },
    );
  }

  /// Navigate to add new task screen
  void _addNewTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TaskFormScreen(),
      ),
    );
  }

  /// Navigate to edit task screen
  void _editTask(String taskId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(taskId: taskId),
      ),
    );
  }

  /// Navigate to task details screen
  void _viewTaskDetails(String taskId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(taskId: taskId),
      ),
    );
  }

  /// Toggle task completion status
  void _toggleTaskCompletion(String taskId) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.toggleTaskCompletion(taskId);
  }

  /// Delete a task
  void _deleteTask(String taskId) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.deleteTask(taskId);
  }
}