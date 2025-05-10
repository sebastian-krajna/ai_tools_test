import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/utils/date_formatter.dart';

/// A form widget for creating and editing tasks
class TaskForm extends StatefulWidget {
  final Task? task;
  final Function(Task) onSave;

  const TaskForm({
    super.key,
    this.task,
    required this.onSave,
  });

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TaskPriority _priority;
  DateTime? _dueDate;
  TimeOfDay? _dueTime;

  @override
  void initState() {
    super.initState();

    // Initialize form controllers
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _priority = widget.task?.priority ?? TaskPriority.medium;
    
    // Initialize due date and time if available
    if (widget.task?.dueDate != null) {
      _dueDate = widget.task!.dueDate;
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title field
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              hintText: 'Enter task title',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.title),
            ),
            textCapitalization: TextCapitalization.sentences,
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
              hintText: 'Enter task description',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description),
              alignLabelWithHint: true,
            ),
            textCapitalization: TextCapitalization.sentences,
            minLines: 3,
            maxLines: 5,
          ),
          const SizedBox(height: 16),

          // Priority selection
          Text(
            'Priority',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          SegmentedButton<TaskPriority>(
            segments: const [
              ButtonSegment<TaskPriority>(
                value: TaskPriority.low,
                label: Text('Low'),
                icon: Icon(Icons.keyboard_arrow_down),
              ),
              ButtonSegment<TaskPriority>(
                value: TaskPriority.medium,
                label: Text('Medium'),
                icon: Icon(Icons.drag_handle),
              ),
              ButtonSegment<TaskPriority>(
                value: TaskPriority.high,
                label: Text('High'),
                icon: Icon(Icons.keyboard_arrow_up),
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

          // Due date and time
          Text(
            'Due Date and Time (optional)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          
          Row(
            children: [
              Expanded(
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(
                    _dueDate == null
                        ? 'No date set'
                        : DateFormatter.formatDate(_dueDate),
                  ),
                  subtitle: const Text('Due date'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                    ),
                  ),
                  onTap: _selectDueDate,
                ),
              ),
              const SizedBox(width: 8),
              if (_dueDate != null)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _dueDate = null;
                      _dueTime = null;
                    });
                  },
                  tooltip: 'Clear date',
                ),
            ],
          ),
          
          if (_dueDate != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: const Icon(Icons.access_time),
                    title: Text(
                      _dueTime == null
                          ? 'No time set'
                          : _dueTime!.format(context),
                    ),
                    subtitle: const Text('Due time'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                      ),
                    ),
                    onTap: _selectDueTime,
                  ),
                ),
                const SizedBox(width: 8),
                if (_dueTime != null)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _dueTime = null;
                      });
                    },
                    tooltip: 'Clear time',
                  ),
              ],
            ),
          ],
          
          const SizedBox(height: 24),

          // Save button
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _saveTask,
              icon: const Icon(Icons.save),
              label: Text(widget.task == null ? 'Add Task' : 'Update Task'),
            ),
          ),
        ],
      ),
    );
  }

  /// Show date picker and update due date
  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      helpText: 'Select Due Date',
    );

    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
        
        // If there's already a time set, preserve it
        if (_dueTime != null) {
          _dueDate = DateTime(
            _dueDate!.year,
            _dueDate!.month,
            _dueDate!.day,
            _dueTime!.hour,
            _dueTime!.minute,
          );
        }
      });
    }
  }

  /// Show time picker and update due time
  Future<void> _selectDueTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _dueTime ?? TimeOfDay.now(),
      helpText: 'Select Due Time',
    );

    if (picked != null) {
      setState(() {
        _dueTime = picked;
        
        // Combine date and time
        if (_dueDate != null) {
          _dueDate = DateTime(
            _dueDate!.year,
            _dueDate!.month,
            _dueDate!.day,
            _dueTime!.hour,
            _dueTime!.minute,
          );
        }
      });
    }
  }

  /// Validate form and save task
  void _saveTask() {
    if (_formKey.currentState?.validate() == true) {
      DateTime? combinedDateTime;
      
      // Combine date and time if both are set
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

      final task = widget.task?.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _priority,
        dueDate: combinedDateTime,
      ) ??
          Task(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            priority: _priority,
            dueDate: combinedDateTime,
          );

      widget.onSave(task);
    }
  }
}