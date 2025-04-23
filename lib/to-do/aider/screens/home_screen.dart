import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_list_item.dart';
import 'task_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todo App'),
          actions: [
            _buildSortButton(context),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTaskList(context, false),
            _buildTaskList(context, true),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _navigateToTaskForm(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, bool showCompleted) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final tasks = showCompleted 
            ? taskProvider.tasks.where((task) => task.isCompleted).toList()
            : taskProvider.tasks.where((task) => !task.isCompleted).toList();
            
        if (tasks.isEmpty) {
          return Center(
            child: Text(
              showCompleted 
                  ? 'No completed tasks yet'
                  : 'No pending tasks. Add one!',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        }
        
        return ListView.builder(
          itemCount: tasks.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final task = tasks[index];
            return TaskListItem(
              task: task,
              onTap: () => _navigateToTaskForm(context, task: task),
            );
          },
        );
      },
    );
  }

  Widget _buildSortButton(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return PopupMenuButton<SortMethod>(
          icon: const Icon(Icons.sort),
          onSelected: (SortMethod method) {
            taskProvider.setSortMethod(method);
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<SortMethod>>[
            const PopupMenuItem<SortMethod>(
              value: SortMethod.dueDate,
              child: Text('Sort by due date'),
            ),
            const PopupMenuItem<SortMethod>(
              value: SortMethod.priority,
              child: Text('Sort by priority'),
            ),
            const PopupMenuItem<SortMethod>(
              value: SortMethod.title,
              child: Text('Sort by title'),
            ),
            const PopupMenuItem<SortMethod>(
              value: SortMethod.status,
              child: Text('Sort by status'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToTaskForm(BuildContext context, {Task? task}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(task: task),
      ),
    );
  }
}
