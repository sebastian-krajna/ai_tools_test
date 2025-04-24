import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../utils/priority_helper.dart';
import '../utils/date_formatter.dart';

/// Screen for adding or editing a task
class TaskFormScreen extends StatefulWidget {
  final Task? task;
  
  /// Constructor for the task form screen
  /// If [task] is provided, the form will be in edit mode
  const TaskFormScreen({
    super.key,
    this.task,
  });

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TaskPriority _priority;
  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  
  bool get _isEditMode => widget.task != null;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers and values
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _priority = widget.task?.priority ?? TaskPriority.medium;
    
    if (widget.task?.dueDate != null) {
      _dueDate = DateTime(
        widget.task!.dueDate!.year,
        widget.task!.dueDate!.month,
        widget.task!.dueDate!.day,
      );
      _dueTime = TimeOfDay.fromDateTime(widget.task!.dueDate!);
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
        title: Text(_isEditMode ? 'Edit Task' : 'Add Task'),
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
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
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
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                textInputAction: TextInputAction.newline,
              ),
              const SizedBox(height: 24),
              
              // Priority selection
              Text(
                'Priority',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _buildPrioritySelector(),
              const SizedBox(height: 24),
              
              // Due date selection
              Text(
                'Due Date (optional)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _buildDateTimeSelector(),
              const SizedBox(height: 32),
              
              // Submit button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _submitForm,
                  child: Text(
                    _isEditMode ? 'Update Task' : 'Add Task',
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
  
  /// Build the priority selection widget
  Widget _buildPrioritySelector() {
    return Wrap(
      spacing: 8,
      children: PriorityHelper.getPriorityOptions().map((option) {
        final TaskPriority value = option['value'];
        final String label = option['label'];
        final IconData icon = option['icon'];
        final Color color = option['color'];
        
        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: _priority == value ? Colors.white : color),
              const SizedBox(width: 4),
              Text(label),
            ],
          ),
          selected: _priority == value,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _priority = value;
              });
            }
          },
          selectedColor: color,
          labelStyle: TextStyle(
            color: _priority == value ? Colors.white : null,
            fontWeight: FontWeight.bold,
          ),
        );
      }).toList(),
    );
  }
  
  /// Build the date and time selection widget
  Widget _buildDateTimeSelector() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _selectDueDate,
            icon: const Icon(Icons.calendar_today),
            label: Text(
              _dueDate != null
                  ? DateFormatter.formatDate(_dueDate)
                  : 'Select Date',
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _dueDate != null ? _selectDueTime : null,
            icon: const Icon(Icons.access_time),
            label: Text(
              _dueTime != null
                  ? _dueTime!.format(context)
                  : 'Select Time',
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        if (_dueDate != null || _dueTime != null)
          IconButton(
            onPressed: () {
              setState(() {
                _dueDate = null;
                _dueTime = null;
              });
            },
            icon: const Icon(Icons.clear),
            tooltip: 'Clear date and time',
          ),
      ],
    );
  }
  
  /// Show date picker to select due date
  Future<void> _selectDueDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    
    if (pickedDate != null) {
      setState(() {
        _dueDate = pickedDate;
        if (_dueTime == null) {
          _dueTime = const TimeOfDay(hour: 23, minute: 59);
        }
      });
    }
  }
  
  /// Show time picker to select due time
  Future<void> _selectDueTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _dueTime ?? TimeOfDay.now(),
    );
    
    if (pickedTime != null) {
      setState(() {
        _dueTime = pickedTime;
      });
    }
  }
  
  /// Submit the form and save the task
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      
      // Combine date and time if both are selected
      DateTime? combinedDateTime;
      if (_dueDate != null) {
        final time = _dueTime ?? const TimeOfDay(hour: 23, minute: 59);
        combinedDateTime = DateTime(
          _dueDate!.year,
          _dueDate!.month,
          _dueDate!.day,
          time.hour,
          time.minute,
        );
      }
      
      if (_isEditMode) {
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
