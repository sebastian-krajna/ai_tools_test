import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';
import '../widgets/task_list_item.dart';
import 'task_detail_screen.dart';
import 'task_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          PopupMenuButton<TaskSortOption>(
            icon: const Icon(Icons.sort),
            onSelected: (option) {
              Provider.of<TaskProvider>(context, listen: false)
                  .setSortOption(option);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: TaskSortOption.priority,
                child: Text('Sort by Priority'),
              ),
              const PopupMenuItem(
                value: TaskSortOption.dueDate,
                child: Text('Sort by Due Date'),
              ),
              const PopupMenuItem(
                value: TaskSortOption.completion,
                child: Text('Sort by Completion'),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (taskProvider.errorMessage != null) {
            return Center(
              child: Text(
                'Error: ${taskProvider.errorMessage}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final tasks = taskProvider.tasks;
          
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
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add a task to get started',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return AnimatedList(
            initialItemCount: tasks.length,
            itemBuilder: (context, index, animation) {
              final task = tasks[index];
              return SlideTransition(
                position: animation.drive(
                  Tween(
                    begin: const Offset(1, 0),
                    end: const Offset(0, 0),
                  ),
                ),
                child: TaskListItem(
                  task: task,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailScreen(task: task),
                      ),
                    );
                  },
                  onCompletionToggle: (_) {
                    taskProvider.toggleTaskCompletion(task.id);
                  },
                  onDelete: () {
                    taskProvider.deleteTask(task.id);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskFormScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }
}
