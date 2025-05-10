import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_form.dart';

class TaskFormScreen extends StatelessWidget {
  final Task? task;

  const TaskFormScreen({
    Key? key,
    this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: TaskForm(
        task: task,
        onSave: (updatedTask) {
          final taskProvider = Provider.of<TaskProvider>(context, listen: false);
          
          if (task == null) {
            taskProvider.addTask(updatedTask);
          } else {
            taskProvider.updateTask(updatedTask);
          }
          
          Navigator.pop(context);
        },
      ),
    );
  }
} 