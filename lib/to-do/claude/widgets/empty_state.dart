import 'package:flutter/material.dart';

/// Widget to display when there are no tasks
class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onActionPressed;
  final String? actionLabel;
  
  /// Constructor for EmptyState
  const EmptyState({
    super.key,
    required this.message,
    this.icon = Icons.task_alt,
    this.onActionPressed,
    this.actionLabel,
  });
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
            ),
          ),
          if (onActionPressed != null && actionLabel != null) ...[
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onActionPressed,
              icon: const Icon(Icons.add),
              label: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}