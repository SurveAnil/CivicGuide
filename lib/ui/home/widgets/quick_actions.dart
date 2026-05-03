// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class QuickAction {
  final IconData icon;
  final String label;
  final String chipText;
  const QuickAction(this.icon, this.label, this.chipText);
}

class QuickActionsBar extends StatelessWidget {
  final List<QuickAction> actions;
  final Function(QuickAction) onActionTapped;

  const QuickActionsBar({
    super.key,
    required this.actions,
    required this.onActionTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: SizedBox(
        height: 90,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: CivicTheme.maxContentWidth),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: actions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final action = actions[index];
                return Semantics(
                  button: true,
                  label: '${action.label}: ${action.chipText}',
                  child: Material(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => onActionTapped(action),
                      child: Container(
                        width: 100,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: theme.colorScheme.primary.withAlpha(40)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(action.icon,
                                color: theme.colorScheme.primary, size: 28),
                            const SizedBox(height: 6),
                            Text(
                              action.label,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 10, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
