import 'package:flutter/material.dart';

/// Standardized error component for graceful fallback.
class ErrorStateWidget extends StatelessWidget {
  /// User friendly error message.
  final String message;
  
  /// Primary recovery action.
  final VoidCallback onRetry;
  
  /// Optional secondary recovery action (e.g. Open Checklist).
  final VoidCallback? onSecondaryAction;
  
  /// Label for the secondary action.
  final String? secondaryActionLabel;

  /// Creates an [ErrorStateWidget].
  const ErrorStateWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.onSecondaryAction,
    this.secondaryActionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
              if (onSecondaryAction != null && secondaryActionLabel != null) ...[
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: onSecondaryAction,
                  child: Text(secondaryActionLabel!),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
