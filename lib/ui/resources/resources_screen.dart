// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import '../../models/country_mode.dart';
import '../../providers/app_state.dart';
import '../../core/theme.dart';

class ResourcesScreen extends StatelessWidget {
  final AppState appState;
  const ResourcesScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIndia = appState.country == CountryMode.india;
    final screenWidth = MediaQuery.of(context).size.width;
    final columns = CivicTheme.gridColumns(screenWidth);

    final resources = isIndia
        ? [
            const _Resource(
              Icons.how_to_vote,
              'Voting Guide',
              'Step-by-step voting process in India',
              Colors.green,
              '1. Find your polling booth online.\n2. Verify your name is on the electoral roll.\n3. Carry your EPIC or valid ID.\n4. Stand in queue, have your identity verified, sign the register, and press the button on the EVM.',
            ),
            const _Resource(
              Icons.description,
              'Required Documents',
              'ID proofs needed for voting',
              Colors.orange,
              'The primary document is the EPIC (Voter ID). However, if you do not have it, you can carry your Aadhaar Card, PAN Card, Driving License, Passport, or MGNREGA Job Card, provided your name is on the voter list.',
            ),
            const _Resource(
              Icons.calendar_month,
              'Election Timeline',
              'Upcoming election schedule',
              Colors.blue,
              'Lok Sabha and Vidhan Sabha elections are usually held in multiple phases across different states. You must check the official Election Commission of India (ECI) website for exact dates matching your constituency.',
            ),
            const _Resource(
              Icons.shield,
              'Voter Rights',
              'Know your rights as a voter',
              Colors.purple,
              'You have the right to a secret ballot. If you are in the queue before the voting time ends, you have the right to cast your vote. You also have the right to use NOTA (None of the Above).',
            ),
            const _Resource(
              Icons.quiz,
              'FAQs',
              'Frequently asked questions',
              Colors.teal,
              'Q: Can I vote without an EPIC card?\nA: Yes, using alternative photo IDs.\n\nQ: Can I vote online?\nA: No, India currently only supports physical voting via EVMs at polling booths.',
            ),
            const _Resource(
              Icons.link,
              'NVSP Portal',
              'National Voter Service Portal',
              Colors.indigo,
              'The NVSP portal (voters.eci.gov.in) allows you to register as a new voter, correct personal details on your card, download your e-EPIC, and search your name in the electoral roll.',
            ),
          ]
        : [
            const _Resource(
              Icons.how_to_vote,
              'Voting Guide',
              'How to vote in the United States',
              Colors.green,
              'Voting processes vary by state. Generally, you must register to vote, locate your assigned polling place, bring the required ID (if applicable in your state), and cast your ballot either in person or by mail.',
            ),
            const _Resource(
              Icons.app_registration,
              'Registration',
              'How to register to vote',
              Colors.orange,
              'Most states require registration weeks before election day (except North Dakota). Many states offer online registration. You can check your registration status or register online at vote.gov.',
            ),
            const _Resource(
              Icons.calendar_month,
              'Election Timeline',
              'Key dates and deadlines',
              Colors.blue,
              'Federal general elections occur on the Tuesday following the first Monday in November. However, primaries, caucuses, and local elections happen throughout the year. Deadlines for registration and mail-in ballots vary widely by state.',
            ),
            const _Resource(
              Icons.shield,
              'Voter Rights',
              'Your rights at the polls',
              Colors.purple,
              'You have the right to request a provisional ballot if your name is missing from the rolls. You also have the right to vote if you are in line when polls close, and the right to request voting assistance if needed.',
            ),
            const _Resource(
              Icons.quiz,
              'FAQs',
              'Frequently asked questions',
              Colors.teal,
              'Q: Do I need to show an ID?\nA: About 35 states require some form of ID; check your state\'s rules.\n\nQ: Can I vote early?\nA: Most states offer an early voting period where you can cast your ballot before Election Day.',
            ),
            const _Resource(
              Icons.mail,
              'Mail-in Voting',
              'Absentee and mail ballot guide',
              Colors.indigo,
              'Mail-in (or absentee) voting allows you to vote from home. Some states send ballots to all voters, while others require an excuse. Ensure you sign the envelope correctly and mail it back before your state\'s deadline.',
            ),
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            '📚 Resources',
            style: theme.textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            isIndia
                ? 'Election resources for Indian voters'
                : 'Election resources for US voters',
            style: theme.textTheme.bodySmall,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: GridView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  childAspectRatio: 0.95,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: resources.length,
                itemBuilder: (context, index) {
                  final r = resources[index];
                  return _ResourceCard(
                      resource: r,
                      onTap: () => _showResourceDetail(context, r));
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showResourceDetail(BuildContext context, _Resource r) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(r.icon, color: r.color, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(r.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ]),
            const SizedBox(height: 12),
            Text(r.subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 20),
            Text(
              r.details,
              style: const TextStyle(
                  color: Colors.white, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Head to the Home tab to ask CivicGuide about "${r.title}"!'),
                      behavior: SnackBarBehavior.floating,
                      action: SnackBarAction(
                        label: 'Got it',
                        onPressed: () {},
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.smart_toy),
                label: const Text('Ask AI about this'),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

/// Vertical card for a resource item — icon on top, title, subtitle.
class _ResourceCard extends StatelessWidget {
  final _Resource resource;
  final VoidCallback onTap;
  const _ResourceCard({required this.resource, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = resource;

    return Semantics(
      button: true,
      label: '${r.title}: ${r.subtitle}',
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: r.color.withAlpha(50)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon circle
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: r.color.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(r.icon, color: r.color, size: 24),
                ),
                const SizedBox(height: 10),
                Text(
                  r.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  r.subtitle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Resource {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String details;
  const _Resource(
      this.icon, this.title, this.subtitle, this.color, this.details);
}
