import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../utils/app_theme.dart';

/// Screen for adding or editing a task
class TaskFormScreen extends StatefulWidget {
  final Task? task;
  
  const TaskFormScreen({
    Key? key,
    this.task,
  }) : super(key: key);

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  TaskPriority _priority = TaskPriority.medium;
  DateTime? _dueDate;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    
    // If task is provided, populate form fields
    if (widget.task != null) {
      _isEditMode = true;
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _priority = widget.task!.priority;
      _dueDate = widget.task!.dueDate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Task' : 'Add Task'),
        actions: [
          if (_isEditMode)
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete Task',
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              textCapitalization: TextCapitalization.sentences,
              autofocus: !_isEditMode,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Description field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            
            // Priority selection
            Text(
              'Priority',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<TaskPriority>(
              segments: TaskPriority.values.map((priority) {
                final color = AppTheme.getPriorityColor(context, priority);
                return ButtonSegment<TaskPriority>(
                  value: priority,
                  label: Text(priority.name),
                  icon: Icon(Icons.flag, color: color),
                );
              }).toList(),
              selected: {_priority},
              onSelectionChanged: (Set<TaskPriority> selected) {
                setState(() {
                  _priority = selected.first;
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return AppTheme.getPriorityBackgroundColor(context, _priority);
                    }
                    return theme.colorScheme.surface;
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Due date selection
            Text(
              'Due Date (optional)',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: Text(
                _dueDate == null
                    ? 'No due date'
                    : DateFormat.yMMMMd().format(_dueDate!),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_dueDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      tooltip: 'Clear due date',
                      onPressed: () {
                        setState(() {
                          _dueDate = null;
                        });
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.edit_calendar),
                    tooltip: 'Set due date',
                    onPressed: _selectDueDate,
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 32),
            
            // Save button
            FilledButton.icon(
              onPressed: _saveTask,
              icon: const Icon(Icons.save),
              label: Text(_isEditMode ? 'Update Task' : 'Add Task'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme,
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      
      if (_isEditMode) {
        // Update existing task
        final updatedTask = widget.task!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          priority: _priority,
          dueDate: _dueDate,
        );
        
        taskProvider.updateTask(updatedTask);
        Navigator.of(context).pop(true);
      } else {
        // Create new task
        final newTask = Task(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          priority: _priority,
          dueDate: _dueDate,
        );
        
        taskProvider.addTask(newTask);
        Navigator.of(context).pop(true);
      }
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text(
          'Are you sure you want to delete this task? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false)
                  .deleteTask(widget.task!.id);
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(true); // Return to list screen
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Task deleted'),
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}