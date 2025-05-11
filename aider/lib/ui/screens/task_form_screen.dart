import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/task.dart';
import '../../providers/task_provider.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  const TaskFormScreen({Key? key, this.task}) : super(key: key);

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TaskPriority _priority;
  DateTime? _dueDate;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.task != null;
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _priority = widget.task?.priority ?? TaskPriority.medium;
    _dueDate = widget.task?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      
      if (_isEditing && widget.task != null) {
        final updatedTask = widget.task!.copyWith(
          title: _titleController.text,
          description: _descriptionController.text,
          priority: _priority,
          dueDate: _dueDate,
        );
        taskProvider.updateTask(updatedTask);
      } else {
        taskProvider.addTask(
          _titleController.text,
          _descriptionController.text,
          _priority,
          _dueDate,
        );
      }
      
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Task' : 'Add Task'),
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
                hintText: 'Enter task title',
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
                labelText: 'Description',
                hintText: 'Enter task description',
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              textInputAction: TextInputAction.newline,
            ),
            
            const SizedBox(height: 16),
            
            // Priority selection
            DropdownButtonFormField<TaskPriority>(
              value: _priority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                prefixIcon: Icon(Icons.flag),
              ),
              items: TaskPriority.values.map((priority) {
                String label;
                Color color;
                
                switch (priority) {
                  case TaskPriority.high:
                    label = 'High';
                    color = Colors.red;
                    break;
                  case TaskPriority.medium:
                    label = 'Medium';
                    color = Colors.orange;
                    break;
                  case TaskPriority.low:
                    label = 'Low';
                    color = Colors.green;
                    break;
                }
                
                return DropdownMenuItem<TaskPriority>(
                  value: priority,
                  child: Row(
                    children: [
                      Icon(Icons.circle, size: 12, color: color),
                      const SizedBox(width: 8),
                      Text(label),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _priority = value;
                  });
                }
              },
            ),
            
            const SizedBox(height: 16),
            
            // Due date selection
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Due Date',
                  prefixIcon: const Icon(Icons.calendar_today),
                  suffixIcon: _dueDate != null
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _dueDate = null;
                            });
                          },
                        )
                      : null,
                ),
                child: Text(
                  _dueDate == null
                      ? 'No due date'
                      : DateFormat('EEE, MMM d, y').format(_dueDate!),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Save button
            ElevatedButton.icon(
              onPressed: _saveTask,
              icon: Icon(_isEditing ? Icons.save : Icons.add),
              label: Text(_isEditing ? 'Save Changes' : 'Add Task'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
