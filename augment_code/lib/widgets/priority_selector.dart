import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/task.dart';

/// Widget for selecting task priority
class PrioritySelector extends StatelessWidget {
  final TaskPriority selectedPriority;
  final Function(TaskPriority) onPriorityChanged;

  const PrioritySelector({
    Key? key,
    required this.selectedPriority,
    required this.onPriorityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildPriorityOption(
              context,
              TaskPriority.low,
              'Low',
              AppColors.lowPriority,
            ),
            const SizedBox(width: 8),
            _buildPriorityOption(
              context,
              TaskPriority.medium,
              'Medium',
              AppColors.mediumPriority,
            ),
            const SizedBox(width: 8),
            _buildPriorityOption(
              context,
              TaskPriority.high,
              'High',
              AppColors.highPriority,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriorityOption(
    BuildContext context,
    TaskPriority priority,
    String label,
    Color color,
  ) {
    final isSelected = selectedPriority == priority;
    
    return Expanded(
      child: InkWell(
        onTap: () => onPriorityChanged(priority),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? color : Colors.grey.shade700,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
