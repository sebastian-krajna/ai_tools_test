import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/widgets/task_form.dart';

/// Screen for creating or editing a task
class TaskFormScreen extends StatefulWidget {
  final String? taskId;

  const TaskFormScreen({
    super.key,
    this.taskId,
  });

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  late Task? _task;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  /// Load the task if editing an existing task
  Future<void> _loadTask() async {
    if (widget.taskId != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final taskProvider = Provider.of<TaskProvider>(context, listen: false);
        _task = taskProvider.getTaskById(widget.taskId!);
      } catch (e) {
        _showErrorDialog('Failed to load task: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      _task = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskId == null ? 'Add Task' : 'Edit Task'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TaskForm(
                    task: _task,
                    onSave: _saveTask,
                  ),
                ],
              ),
            ),
    );
  }

  /// Save the task and navigate back
  Future<void> _saveTask(Task task) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      
      if (widget.taskId == null) {
        await taskProvider.addTask(task);
        if (mounted) {
          _showSnackBar('Task added successfully');
        }
      } else {
        await taskProvider.updateTask(task);
        if (mounted) {
          _showSnackBar('Task updated successfully');
        }
      }
      
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      _showErrorDialog('Failed to save task: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Show a snackbar with a message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show an error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}