import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';

/// Screen for adding a new task or editing an existing one
class TaskDetailScreen extends StatefulWidget {
  /// The task to edit (null if creating a new task)
  final Task? task;

  /// Constructor
  const TaskDetailScreen({super.key, this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  TaskPriority _priority = TaskPriority.medium;
  DateTime? _dueDate;
  
  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    
    // If editing an existing task, populate the form fields
    if (_isEditing) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Task' : 'Add Task'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                autofocus: !_isEditing,
              ),
              const SizedBox(height: 16),
              
              // Description field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              
              // Priority selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Priority',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildPrioritySelector(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Due date selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Due Date',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _dueDate == null
                                  ? 'No due date'
                                  : DateFormat('MMM d, yyyy').format(_dueDate!),
                            ),
                          ),
                          TextButton(
                            onPressed: _pickDueDate,
                            child: Text(_dueDate == null ? 'Add' : 'Change'),
                          ),
                          if (_dueDate != null)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _dueDate = null;
                                });
                              },
                              child: const Text('Clear'),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Save button
              ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: Text(
                  _isEditing ? 'Update Task' : 'Add Task',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the priority selector
  Widget _buildPrioritySelector() {
    return SegmentedButton<TaskPriority>(
      segments: const [
        ButtonSegment<TaskPriority>(
          value: TaskPriority.low,
          label: Text('Low'),
          icon: Icon(Icons.arrow_downward),
        ),
        ButtonSegment<TaskPriority>(
          value: TaskPriority.medium,
          label: Text('Medium'),
          icon: Icon(Icons.remove),
        ),
        ButtonSegment<TaskPriority>(
          value: TaskPriority.high,
          label: Text('High'),
          icon: Icon(Icons.arrow_upward),
        ),
      ],
      selected: {_priority},
      onSelectionChanged: (Set<TaskPriority> selected) {
        setState(() {
          _priority = selected.first;
        });
      },
    );
  }

  /// Opens a date picker to select the due date
  Future<void> _pickDueDate() async {
    final initialDate = _dueDate ?? DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    
    if (newDate != null) {
      setState(() {
        _dueDate = newDate;
      });
    }
  }

  /// Saves the task
  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      
      if (_isEditing) {
        // Update existing task
        final updatedTask = widget.task!.copyWith(
          title: _titleController.text,
          description: _descriptionController.text,
          priority: _priority,
          dueDate: _dueDate,
        );
        
        taskProvider.updateTask(widget.task!.id, updatedTask);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task updated')),
        );
      } else {
        // Create new task
        final newTask = Task(
          title: _titleController.text,
          description: _descriptionController.text,
          priority: _priority,
          dueDate: _dueDate,
        );
        
        taskProvider.addTask(newTask);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task added')),
        );
      }
      
      Navigator.of(context).pop();
    }
  }
}
