import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/screens/task_detail_screen.dart';
import 'package:todo_app/screens/task_form_screen.dart';
import 'package:todo_app/widgets/task_tile.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          PopupMenuButton<SortOption>(
            onSelected: (option) {
              taskProvider.sortTasks(option);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: SortOption.priority,
                child: Text('Sort by Priority'),
              ),
              const PopupMenuItem(
                value: SortOption.dueDate,
                child: Text('Sort by Due Date'),
              ),
              const PopupMenuItem(
                value: SortOption.completion,
                child: Text('Sort by Completion'),
              ),
            ],
          ),
        ],
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('No tasks yet. Add one!'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskTile(
                  task: task,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailScreen(task: task),
                      ),
                    );
                  },
                  onComplete: () {
                    taskProvider.toggleTaskCompletion(task.id);
                  },
                  onDelete: () {
                    _showDeleteConfirmationDialog(context, task.id);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TaskFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String taskId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false).deleteTask(taskId);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}