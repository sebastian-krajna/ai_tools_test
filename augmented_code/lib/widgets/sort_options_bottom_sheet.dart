import 'package:flutter/material.dart';
import '../providers/task_provider.dart';

/// Bottom sheet for selecting task sorting options
class SortOptionsBottomSheet extends StatelessWidget {
  final TaskSortOption currentSortOption;
  final bool showCompletedFirst;
  final Function(TaskSortOption) onSortOptionChanged;
  final Function(bool) onShowCompletedFirstChanged;

  const SortOptionsBottomSheet({
    Key? key,
    required this.currentSortOption,
    required this.showCompletedFirst,
    required this.onSortOptionChanged,
    required this.onShowCompletedFirstChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sort Tasks',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Sort options
          Text(
            'Sort by:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          
          _buildSortOption(
            context,
            TaskSortOption.dueDate,
            Icons.calendar_today,
          ),
          _buildSortOption(
            context,
            TaskSortOption.priority,
            Icons.flag,
          ),
          _buildSortOption(
            context,
            TaskSortOption.title,
            Icons.sort_by_alpha,
          ),
          _buildSortOption(
            context,
            TaskSortOption.creationDate,
            Icons.access_time,
          ),
          
          const Divider(height: 32),
          
          // Completed tasks option
          SwitchListTile(
            title: const Text('Show completed tasks first'),
            value: showCompletedFirst,
            onChanged: onShowCompletedFirstChanged,
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    TaskSortOption option,
    IconData icon,
  ) {
    final isSelected = currentSortOption == option;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : null,
      ),
      title: Text(option.name),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      onTap: () {
        onSortOptionChanged(option);
        Navigator.pop(context);
      },
    );
  }
}
