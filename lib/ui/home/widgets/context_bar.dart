// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import '../../../providers/app_state.dart';

class ContextBar extends StatelessWidget {
  final AppState appState;

  const ContextBar({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: 'Location and language context',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: theme.colorScheme.surface,
        child: Row(
          children: [
            Icon(Icons.pin_drop, size: 14, color: theme.colorScheme.primary),
            const SizedBox(width: 6),
            Text(
              appState.locationCode.isNotEmpty
                  ? '${appState.countryConfig.flag} ${appState.locationCode}'
                  : '${appState.countryConfig.flag} ${appState.countryConfig.name}',
              style: theme.textTheme.bodySmall,
            ),
            const Spacer(),
            if (appState.isGuest)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.withAlpha(30),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('Guest',
                    style: TextStyle(fontSize: 10, color: Colors.orange)),
              ),
            Text(
              '🌐 ${appState.language}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
