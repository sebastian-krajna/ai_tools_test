import 'package:flutter/material.dart';
import '../providers/task_provider.dart';

/// Widget for selecting task sorting options
class SortOptions extends StatelessWidget {
  final TaskSortOption currentSortOption;
  final bool sortAscending;
  final Function(TaskSortOption) onSortOptionChanged;
  final VoidCallback onSortDirectionChanged;
  
  /// Constructor for the sort options widget
  const SortOptions({
    super.key,
    required this.currentSortOption,
    required this.sortAscending,
    required this.onSortOptionChanged,
    required this.onSortDirectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        // Sort direction button
        IconButton(
          onPressed: onSortDirectionChanged,
          icon: Icon(
            sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
          ),
          tooltip: sortAscending ? 'Ascending' : 'Descending',
        ),
        // Sort option chips
        _buildSortChip(
          context,
          'Priority',
          TaskSortOption.priority,
        ),
        _buildSortChip(
          context,
          'Due Date',
          TaskSortOption.dueDate,
        ),
        _buildSortChip(
          context,
          'Status',
          TaskSortOption.status,
        ),
        _buildSortChip(
          context,
          'Created',
          TaskSortOption.creationDate,
        ),
      ],
    );
  }
  
  /// Build a chip for a sort option
  Widget _buildSortChip(
    BuildContext context,
    String label,
    TaskSortOption option,
  ) {
    final isSelected = currentSortOption == option;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSortOptionChanged(option),
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }
}
