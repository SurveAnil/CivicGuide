// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/country_mode.dart';
import '../../providers/app_state.dart';

class HelplineScreen extends StatelessWidget {
  final AppState appState;
  const HelplineScreen({super.key, required this.appState});

  List<_HelplineContact> get _contacts {
    if (appState.country == CountryMode.india) {
      return const [
        _HelplineContact('Election Commission of India', '1800-111-950',
            'Toll-free voter helpline', Icons.gavel),
        _HelplineContact('NVSP Helpdesk', '011-2305-2205',
            'Voter registration support', Icons.support_agent),
        _HelplineContact(
            'cVIGIL App', '1950', 'Report election violations', Icons.report),
        _HelplineContact('Police Emergency', '100', 'Emergency assistance',
            Icons.local_police),
      ];
    } else {
      return const [
        _HelplineContact('USA.gov Vote', '1-866-868-3468',
            'Federal voting assistance', Icons.how_to_vote),
        _HelplineContact('EAC Helpline', '1-866-747-1471',
            'Election Assistance Commission', Icons.support_agent),
        _HelplineContact('DoJ Voting Section', '1-800-253-3931',
            'Report voting rights violations', Icons.gavel),
        _HelplineContact(
            'Emergency', '911', 'Emergency assistance', Icons.local_police),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text('📞 Helpline', style: theme.textTheme.titleLarge),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Emergency and support contacts',
            style: theme.textTheme.bodySmall,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                itemCount: _contacts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final c = _contacts[index];
                  return _HelplineCard(contact: c);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HelplineCard extends StatelessWidget {
  final _HelplineContact contact;
  const _HelplineCard({required this.contact});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = contact;

    return Semantics(
      label: '${c.name}, phone number ${c.number}, ${c.description}',
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => launchUrl(Uri.parse('tel:${c.number}')),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child:
                      Icon(c.icon, color: theme.colorScheme.primary, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.name, style: theme.textTheme.titleSmall),
                      const SizedBox(height: 2),
                      Text(c.number,
                          style: TextStyle(
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          )),
                      Text(c.description,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(fontSize: 12)),
                    ],
                  ),
                ),
                Semantics(
                  button: true,
                  label: 'Call ${c.name}',
                  child: IconButton(
                    icon: Icon(Icons.call, color: theme.colorScheme.primary),
                    tooltip: 'Call ${c.name}',
                    onPressed: () => launchUrl(Uri.parse('tel:${c.number}')),
                  ),
                ),
                Semantics(
                  button: true,
                  label: 'Copy phone number for ${c.name}',
                  child: IconButton(
                    icon:
                        const Icon(Icons.copy, color: Colors.white38, size: 20),
                    tooltip: 'Copy number',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: c.number));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Copied ${c.number}')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HelplineContact {
  final String name;
  final String number;
  final String description;
  final IconData icon;
  const _HelplineContact(this.name, this.number, this.description, this.icon);
}
