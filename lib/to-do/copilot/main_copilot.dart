import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'task_model.dart';
import 'task_provider.dart';

// Main entry point for the To-Do app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const TodoApp());
}

// Root widget of the application
class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        title: 'Modern Todo App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
          useMaterial3: true, // Enable Material Design 3
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: const TaskListScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

// Main screen showing the list of tasks
class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        centerTitle: true,
        actions: [
          _buildSortButton(context),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final tasks = taskProvider.tasks;
          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add a new task to get started',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: tasks.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              return _buildTaskItem(context, tasks[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskSheet(context),
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Create the sort button and dropdown menu
  Widget _buildSortButton(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.sort),
      tooltip: 'Sort tasks',
      onSelected: (value) {
        Provider.of<TaskProvider>(context, listen: false).setSortBy(value);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'dueDate',
          child: Row(
            children: [
              Icon(Icons.calendar_today),
              SizedBox(width: 8),
              Text('By due date'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'priority',
          child: Row(
            children: [
              Icon(Icons.flag),
              SizedBox(width: 8),
              Text('By priority'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'completion',
          child: Row(
            children: [
              Icon(Icons.check_circle),
              SizedBox(width: 8),
              Text('By completion'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'title',
          child: Row(
            children: [
              Icon(Icons.sort_by_alpha),
              SizedBox(width: 8),
              Text('By title'),
            ],
          ),
        ),
      ],
    );
  }

  // Build each task item in the list
  Widget _buildTaskItem(BuildContext context, Task task) {
    final bool isOverdue = task.dueDate.isBefore(DateTime.now()) && !task.isCompleted;
    
    return Dismissible(
      key: Key(task.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<TaskProvider>(context, listen: false).deleteTask(task.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${task.title} deleted'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: InkWell(
          onTap: () => _showTaskDetails(context, task),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Animated task completion checkbox
                TaskCompletionCheckbox(task: task),
                const SizedBox(width: 16),
                // Task info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            task.getPriorityIcon(),
                            color: task.getPriorityColor(),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task.isCompleted
                                    ? Theme.of(context).disabledColor
                                    : null,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: isOverdue
                                ? Colors.red
                                : Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMM dd, yyyy').format(task.dueDate),
                            style: TextStyle(
                              fontSize: 14,
                              color: isOverdue
                                  ? Colors.red
                                  : Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _showEditTaskSheet(context, task),
                  tooltip: 'Edit task',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Show task details dialog
  void _showTaskDetails(BuildContext context, Task task) {
    final bool isOverdue = task.dueDate.isBefore(DateTime.now()) && !task.isCompleted;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      task.getPriorityIcon(),
                      color: task.getPriorityColor(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.pop(context);
                        _showEditTaskSheet(context, task);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        Provider.of<TaskProvider>(context, listen: false)
                            .deleteTask(task.id);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${task.title} deleted'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: isOverdue ? Colors.red : null,
                ),
                const SizedBox(width: 8),
                Text(
                  'Due: ${DateFormat('EEEE, MMMM dd, yyyy').format(task.dueDate)}',
                  style: TextStyle(
                    color: isOverdue ? Colors.red : null,
                    fontWeight: isOverdue ? FontWeight.bold : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Description:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              task.description.isEmpty ? 'No description provided' : task.description,
              style: TextStyle(
                color: task.description.isEmpty
                    ? Theme.of(context).disabledColor
                    : null,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(
                  task.isCompleted ? Icons.refresh : Icons.check_circle,
                ),
                label: Text(
                  task.isCompleted ? 'Mark as incomplete' : 'Mark as complete',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Provider.of<TaskProvider>(context, listen: false)
                      .toggleTaskCompletion(task.id);
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Show bottom sheet for adding a new task
  void _showAddTaskSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          24 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: TaskForm(
          onSubmit: (task) {
            Provider.of<TaskProvider>(context, listen: false).addTask(task);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  // Show bottom sheet for editing a task
  void _showEditTaskSheet(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          24 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: TaskForm(
          initialTask: task,
          onSubmit: (updatedTask) {
            Provider.of<TaskProvider>(context, listen: false).updateTask(updatedTask);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

// Animated checkbox component for task completion
class TaskCompletionCheckbox extends StatelessWidget {
  final Task task;

  const TaskCompletionCheckbox({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<TaskProvider>(context, listen: false)
            .toggleTaskCompletion(task.id);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: task.isCompleted
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: task.isCompleted
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            width: 2,
          ),
        ),
        child: task.isCompleted
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              )
            : null,
      ),
    );
  }
}

// Form for adding or editing tasks
class TaskForm extends StatefulWidget {
  final Task? initialTask;
  final Function(Task) onSubmit;

  const TaskForm({
    super.key,
    this.initialTask,
    required this.onSubmit,
  });

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late TaskPriority _priority;
  late DateTime _dueDate;

  @override
  void initState() {
    super.initState();
    _title = widget.initialTask?.title ?? '';
    _description = widget.initialTask?.description ?? '';
    _priority = widget.initialTask?.priority ?? TaskPriority.medium;
    _dueDate = widget.initialTask?.dueDate ?? DateTime.now().add(const Duration(days: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.initialTask == null ? 'Add New Task' : 'Edit Task',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
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
            onChanged: (value) => _title = value,
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
            ),
            onChanged: (value) => _description = value,
            minLines: 3,
            maxLines: 5,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          // Priority selection
          DropdownButtonFormField<TaskPriority>(
            value: _priority,
            decoration: const InputDecoration(
              labelText: 'Priority',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.flag),
            ),
            items: TaskPriority.values.map((priority) {
              IconData icon;
              String label;
              Color color;

              switch (priority) {
                case TaskPriority.low:
                  icon = Icons.arrow_downward;
                  label = 'Low';
                  color = Colors.green;
                  break;
                case TaskPriority.medium:
                  icon = Icons.remove;
                  label = 'Medium';
                  color = Colors.orange;
                  break;
                case TaskPriority.high:
                  icon = Icons.arrow_upward;
                  label = 'High';
                  color = Colors.red;
                  break;
              }

              return DropdownMenuItem<TaskPriority>(
                value: priority,
                child: Row(
                  children: [
                    Icon(icon, color: color, size: 16),
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
          // Due date picker
          InkWell(
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: _dueDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (pickedDate != null) {
                setState(() {
                  _dueDate = pickedDate;
                });
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Due Date',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              child: Text(DateFormat('EEEE, MMMM dd, yyyy').format(_dueDate)),
            ),
          ),
          const SizedBox(height: 24),
          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final task = widget.initialTask?.copyWith(
                    title: _title,
                    description: _description,
                    priority: _priority,
                    dueDate: _dueDate,
                  ) ??
                  Task(
                    title: _title,
                    description: _description,
                    priority: _priority,
                    dueDate: _dueDate,
                  );
                  widget.onSubmit(task);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(widget.initialTask == null ? 'Add Task' : 'Save Changes'),
            ),
          ),
        ],
      ),
    );
  }
}