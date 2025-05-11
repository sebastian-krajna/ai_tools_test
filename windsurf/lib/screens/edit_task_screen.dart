import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../utils/date_formatter.dart';

/// Screen for adding a new task or editing an existing one
class EditTaskScreen extends StatefulWidget {
  final Task? task;

  const EditTaskScreen({super.key, this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late TaskPriority _priority;
  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    // Initialize with existing task data or defaults
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _priority = widget.task?.priority ?? TaskPriority.medium;
    
    if (widget.task?.dueDate != null) {
      _dueDate = widget.task!.dueDate;
      _dueTime = TimeOfDay.fromDateTime(widget.task!.dueDate!);
    }
    
    // Check initial validity
    _validateForm();
    
    // Listen for changes to validate form
    _titleController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Validate form and update state
  void _validateForm() {
    setState(() {
      _isValid = _titleController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Add Task'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title input field
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter task title',
                prefixIcon: Icon(Icons.title),
              ),
              textInputAction: TextInputAction.next,
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
            ),
            
            const SizedBox(height: 16),
            
            // Priority selection
            Text(
              'Priority',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<TaskPriority>(
              segments: [
                ButtonSegment(
                  value: TaskPriority.low,
                  label: const Text('Low'),
                  icon: const Icon(Icons.low_priority),
                ),
                ButtonSegment(
                  value: TaskPriority.medium,
                  label: const Text('Medium'),
                  icon: const Icon(Icons.flag),
                ),
                ButtonSegment(
                  value: TaskPriority.high,
                  label: const Text('High'),
                  icon: const Icon(Icons.priority_high),
                ),
              ],
              selected: {_priority},
              onSelectionChanged: (Set<TaskPriority> selection) {
                setState(() {
                  _priority = selection.first;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Due date selection
            _buildDateTimeSelector(context),
            
            const SizedBox(height: 16),
            
            // Description input field
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter task description (optional)',
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              minLines: 3,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
            ),
            
            const SizedBox(height: 32),
            
            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isValid ? _saveTask : null,
                icon: const Icon(Icons.save),
                label: Text(isEditing ? 'Update Task' : 'Create Task'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for date and time selection
  Widget _buildDateTimeSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Due Date & Time',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _dueDate != null
                      ? DateFormatter.formatDate(_dueDate)
                      : 'Select Date',
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _dueDate != null ? _pickTime : null,
                icon: const Icon(Icons.access_time),
                label: Text(
                  _dueTime != null
                      ? _dueTime!.format(context)
                      : 'Select Time',
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_dueDate != null)
          TextButton.icon(
            onPressed: () {
              setState(() {
                _dueDate = null;
                _dueTime = null;
              });
            },
            icon: const Icon(Icons.clear, size: 20),
            label: const Text('Clear Due Date'),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
          ),
      ],
    );
  }

  // Show date picker dialog
  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      helpText: 'Select Due Date',
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

  // Show time picker dialog
  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _dueTime ?? TimeOfDay.now(),
      helpText: 'Select Due Time',
    );

    if (pickedTime != null) {
      setState(() {
        _dueTime = pickedTime;
      });
    }
  }

  // Create or update the task and save it
  void _saveTask() {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    
    // Combine date and time if available
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

    if (widget.task == null) {
      // Create new task
      final newTask = Task(
        title: title,
        description: description,
        priority: _priority,
        dueDate: combinedDateTime,
      );
      taskProvider.addTask(newTask);
    } else {
      // Update existing task
      final updatedTask = widget.task!.copyWith(
        title: title,
        description: description,
        priority: _priority,
        dueDate: combinedDateTime,
      );
      taskProvider.updateTask(updatedTask);
    }

    Navigator.pop(context);
  }
}
