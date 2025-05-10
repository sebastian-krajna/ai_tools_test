import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  final VoidCallback onTaskTap;

  const TaskItem({
    Key? key,
    required this.task,
    required this.onTaskTap,
  }) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getPriorityColor() {
    switch (widget.task.priority) {
      case TaskPriority.high:
        return Colors.red.shade200;
      case TaskPriority.medium:
        return Colors.orange.shade200;
      case TaskPriority.low:
        return Colors.green.shade200;
    }
  }

  String _getPriorityText() {
    switch (widget.task.priority) {
      case TaskPriority.high:
        return 'High';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
    }
  }

  bool _isOverdue() {
    final now = DateTime.now();
    return !widget.task.isCompleted && 
           widget.task.dueDate.isBefore(DateTime(now.year, now.month, now.day));
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dismissible(
        key: Key(widget.task.id),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (_) {
          Provider.of<TaskProvider>(context, listen: false)
            .deleteTask(widget.task.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${widget.task.title} removed'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: InkWell(
            onTap: widget.onTaskTap,
            onLongPress: () {
              _animationController.forward().then((_) {
                _animationController.reverse();
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Checkbox with animated transitions
                  GestureDetector(
                    onTap: () {
                      Provider.of<TaskProvider>(context, listen: false)
                        .toggleTaskCompletion(widget.task.id);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: widget.task.isCompleted 
                            ? Theme.of(context).colorScheme.primary 
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: widget.task.isCompleted 
                            ? Theme.of(context).colorScheme.primary 
                            : Theme.of(context).colorScheme.outline,
                          width: 2,
                        ),
                      ),
                      width: 24,
                      height: 24,
                      child: widget.task.isCompleted 
                        ? const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Task content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.task.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  decoration: widget.task.isCompleted 
                                    ? TextDecoration.lineThrough 
                                    : null,
                                  color: widget.task.isCompleted
                                    ? Theme.of(context).colorScheme.outline
                                    : null,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8, 
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getPriorityColor(),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _getPriorityText(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.task.description,
                          style: TextStyle(
                            color: widget.task.isCompleted
                              ? Theme.of(context).colorScheme.outline
                              : null,
                            decoration: widget.task.isCompleted 
                              ? TextDecoration.lineThrough 
                              : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: _isOverdue()
                                ? Colors.red
                                : Theme.of(context).colorScheme.outline,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              dateFormat.format(widget.task.dueDate),
                              style: TextStyle(
                                color: _isOverdue()
                                  ? Colors.red
                                  : Theme.of(context).colorScheme.outline,
                                fontWeight: _isOverdue() ? FontWeight.bold : null,
                              ),
                            ),
                            if (_isOverdue())
                              const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Text(
                                  'OVERDUE',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 