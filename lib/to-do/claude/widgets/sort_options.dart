import 'package:flutter/material.dart';
import '../providers/task_provider.dart';

/// Widget to display sorting options for the task list
class SortOptions extends StatelessWidget {
  final TaskSortCriteria currentSortCriteria;
  final bool sortAscending;
  final Function(TaskSortCriteria) onSortChanged;
  
  /// Constructor for SortOptions
  const SortOptions({
    super.key,
    required this.currentSortCriteria,
    required this.sortAscending,
    required this.onSortChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TaskSortCriteria>(
      initialValue: currentSortCriteria,
      tooltip: 'Sort tasks',
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.sort),
          const SizedBox(width: 4),
          Icon(
            sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
            size: 16,
          ),
        ],
      ),
      onSelected: onSortChanged,
      itemBuilder: (context) => [
        _buildMenuItem(
          context,
          TaskSortCriteria.priority,
          'Priority',
          Icons.flag,
        ),
        _buildMenuItem(
          context,
          TaskSortCriteria.dueDate,
          'Due Date',
          Icons.calendar_today,
        ),
        _buildMenuItem(
          context,
          TaskSortCriteria.title,
          'Title',
          Icons.sort_by_alpha,
        ),
        _buildMenuItem(
          context,
          TaskSortCriteria.creationDate,
          'Creation Date',
          Icons.access_time,
        ),
        _buildMenuItem(
          context,
          TaskSortCriteria.completionStatus,
          'Completion Status',
          Icons.check_circle_outline,
        ),
      ],
    );
  }
  
  /// Build a single menu item for a sort criteria
  PopupMenuItem<TaskSortCriteria> _buildMenuItem(
    BuildContext context,
    TaskSortCriteria criteria,
    String label,
    IconData icon,
  ) {
    final isSelected = currentSortCriteria == criteria;
    
    return PopupMenuItem<TaskSortCriteria>(
      value: criteria,
      child: Row(
        children: [
          Icon(
            icon,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : null,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
          ),
          if (isSelected) ...[
            const Spacer(),
            Icon(
              sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ],
      ),
    );
  }
}