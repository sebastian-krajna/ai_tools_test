import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/priority_selector.dart';

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
  
  late TaskPriority _priority;
  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  
  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    
    // Initialize form fields with task data if editing
    if (_isEditing) {
      final task = widget.task!;
      _titleController.text = task.title;
      _descriptionController.text = task.description;
      _priority = task.priority;
      
      if (task.dueDate != null) {
        _dueDate = DateTime(
          task.dueDate!.year,
          task.dueDate!.month,
          task.dueDate!.day,
        );
        _dueTime = TimeOfDay.fromDateTime(task.dueDate!);
      }
    } else {
      _priority = TaskPriority.medium;
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
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter task title',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              
              // Description field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter task description (optional)',
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                textInputAction: TextInputAction.newline,
              ),
              const SizedBox(height: 24),
              
              // Priority selector
              PrioritySelector(
                selectedPriority: _priority,
                onPriorityChanged: (priority) {
                  setState(() {
                    _priority = priority;
                  });
                },
              ),
              const SizedBox(height: 24),
              
              // Due date picker
              Text(
                'Due Date',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _selectDueDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.calendar_today),
                          hintText: 'Select date',
                        ),
                        child: Text(
                          _dueDate != null
                              ? DateFormat('MMM dd, yyyy').format(_dueDate!)
                              : 'No date selected',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: _dueDate != null ? _selectDueTime : null,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.access_time),
                          hintText: 'Select time',
                          enabled: _dueDate != null,
                        ),
                        child: Text(
                          _dueTime != null
                              ? _dueTime!.format(context)
                              : 'No time selected',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_dueDate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextButton.icon(
                    onPressed: _clearDueDate,
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear due date'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              
              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _isEditing ? 'Update Task' : 'Add Task',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDueDate() async {
    final initialDate = _dueDate ?? DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    
    if (pickedDate != null) {
      setState(() {
        _dueDate = pickedDate;
        if (_dueTime == null) {
          _dueTime = TimeOfDay.now();
        }
      });
    }
  }

  Future<void> _selectDueTime() async {
    final initialTime = _dueTime ?? TimeOfDay.now();
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    
    if (pickedTime != null) {
      setState(() {
        _dueTime = pickedTime;
      });
    }
  }

  void _clearDueDate() {
    setState(() {
      _dueDate = null;
      _dueTime = null;
    });
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      
      // Combine date and time if both are selected
      DateTime? combinedDateTime;
      if (_dueDate != null) {
        if (_dueTime != null) {
          combinedDateTime = DateTime(
            _dueDate!.year,
            _dueDate!.month,
            _dueDate!.day,
            _dueTime!.hour,
            _dueTime!.minute,
          );
        } else {
          combinedDateTime = _dueDate;
        }
      }
      
      if (_isEditing) {
        // Update existing task
        final updatedTask = widget.task!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          priority: _priority,
          dueDate: combinedDateTime,
        );
        
        taskProvider.updateTask(updatedTask);
      } else {
        // Create new task
        final newTask = Task(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          priority: _priority,
          dueDate: combinedDateTime,
        );
        
        taskProvider.addTask(newTask);
      }
      
      Navigator.pop(context, true);
    }
  }
}
