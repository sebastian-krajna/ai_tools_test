import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../utils/constants.dart';

/// Screen for creating or editing a task
class TaskFormScreen extends StatefulWidget {
  final Task? task;
  
  /// Constructor for TaskFormScreen
  /// If task is provided, it's an edit mode, otherwise it's create mode
  const TaskFormScreen({super.key, this.task});
  
  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late TaskPriority _priority;
  DateTime? _dueDate;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize values from existing task or defaults
    _title = widget.task?.title ?? '';
    _description = widget.task?.description ?? '';
    _priority = widget.task?.priority ?? TaskPriority.medium;
    _dueDate = widget.task?.dueDate;
  }
  
  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.task != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Task' : 'New Task'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                children: [
                  // Title field
                  TextFormField(
                    initialValue: _title,
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
                    onSaved: (value) => _title = value?.trim() ?? '',
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  
                  // Description field
                  TextFormField(
                    initialValue: _description,
                    decoration: const InputDecoration(
                      labelText: 'Description (optional)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                      alignLabelWithHint: true,
                    ),
                    onSaved: (value) => _description = value?.trim() ?? '',
                    maxLines: 3,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  
                  // Priority selection
                  const Text(
                    'Priority',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPrioritySelector(),
                  const SizedBox(height: 16),
                  
                  // Due date picker
                  const Text(
                    'Due Date (optional)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDueDatePicker(),
                  const SizedBox(height: 32),
                  
                  // Save button
                  FilledButton.icon(
                    onPressed: _saveTask,
                    icon: const Icon(Icons.save),
                    label: Text(isEditMode ? 'Update Task' : 'Create Task'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
  
  /// Build the priority selector with radio buttons
  Widget _buildPrioritySelector() {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            _buildPriorityOption(TaskPriority.low),
            const SizedBox(width: 8),
            _buildPriorityOption(TaskPriority.medium),
            const SizedBox(width: 8),
            _buildPriorityOption(TaskPriority.high),
          ],
        ),
      ),
    );
  }
  
  /// Build a single priority option
  Widget _buildPriorityOption(TaskPriority priority) {
    final selected = _priority == priority;
    final color = AppConstants.getPriorityColor(
      priority,
      isDarkMode: Theme.of(context).brightness == Brightness.dark,
    );
    
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _priority = priority),
        borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
            border: Border.all(
              color: selected ? color : Colors.grey.withOpacity(0.3),
              width: 2,
            ),
            color: selected ? color.withOpacity(0.1) : null,
          ),
          child: Column(
            children: [
              Text(
                priority.emoji,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text(
                priority.name,
                style: TextStyle(
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  color: selected ? color : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Build the due date picker
  Widget _buildDueDatePicker() {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: _pickDueDate,
        borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                _dueDate != null ? Icons.event : Icons.event_available,
                color: _dueDate != null
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              const SizedBox(width: 16),
              Text(
                _dueDate != null
                    ? DateFormat.yMMMd().format(_dueDate!)
                    : 'No due date set',
                style: TextStyle(
                  fontWeight:
                      _dueDate != null ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const Spacer(),
              if (_dueDate != null)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() => _dueDate = null),
                  tooltip: 'Clear due date',
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Show date picker to select due date
  Future<void> _pickDueDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    
    if (pickedDate != null) {
      setState(() => _dueDate = pickedDate);
    }
  }
  
  /// Save the task (create new or update existing)
  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    _formKey.currentState!.save();
    
    setState(() => _isLoading = true);
    
    try {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      
      if (widget.task == null) {
        // Create new task
        final newTask = Task(
          title: _title,
          description: _description,
          priority: _priority,
          dueDate: _dueDate,
        );
        
        await taskProvider.addTask(newTask);
      } else {
        // Update existing task
        final updatedTask = widget.task!.copyWith(
          title: _title,
          description: _description,
          priority: _priority,
          dueDate: _dueDate,
        );
        
        await taskProvider.updateTask(updatedTask);
      }
      
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}