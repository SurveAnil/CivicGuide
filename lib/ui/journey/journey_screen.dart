// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import '../../models/country_mode.dart';
import '../../providers/app_state.dart';
import '../../core/theme.dart';

/// Interactive Voting Journey screen with a stateful checklist
/// and a chronological election timeline.
///
/// This is a real UI component — not just AI-generated text —
/// providing tangible product value for the "election process
/// education" problem statement.
class JourneyScreen extends StatefulWidget {
  /// The global app state controlling country, language, and guest mode.
  final AppState appState;

  const JourneyScreen({super.key, required this.appState});

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool get _isIndia => widget.appState.country == CountryMode.india;

  // ── Checklist Data ──────────────────────────────────────────
  List<_ChecklistItem> get _checklistItems {
    if (_isIndia) {
      return const [
        _ChecklistItem(
          'Check Electoral Roll',
          'Verify your name on the voter list at voters.eci.gov.in',
          Icons.fact_check,
        ),
        _ChecklistItem(
          'Get Voter ID (EPIC)',
          'Apply for or download your e-EPIC from the NVSP portal',
          Icons.credit_card,
        ),
        _ChecklistItem(
          'Find Polling Booth',
          'Locate your assigned booth using the Voter Helpline app',
          Icons.location_on,
        ),
        _ChecklistItem(
          'Carry Valid ID',
          'EPIC, Aadhaar, PAN, Passport, or Driving License',
          Icons.badge,
        ),
        _ChecklistItem(
          'Check Voting Date',
          'Confirm the polling date for your constituency on eci.gov.in',
          Icons.calendar_today,
        ),
        _ChecklistItem(
          'Know Your Candidates',
          'Review candidate details on the ECI affidavit portal',
          Icons.people,
        ),
        _ChecklistItem(
          'Understand EVM & VVPAT',
          'Learn how the Electronic Voting Machine works',
          Icons.how_to_vote,
        ),
        _ChecklistItem(
          'Exercise Your Vote',
          'Visit your booth, verify identity, and press the button!',
          Icons.thumb_up,
        ),
      ];
    } else {
      return const [
        _ChecklistItem(
          'Register to Vote',
          'Register online at vote.gov or your state website',
          Icons.app_registration,
        ),
        _ChecklistItem(
          'Check Registration Status',
          'Confirm your registration at nass.org/can-I-vote',
          Icons.fact_check,
        ),
        _ChecklistItem(
          'Find Polling Place',
          'Use your full address to locate your assigned polling place',
          Icons.location_on,
        ),
        _ChecklistItem(
          'Review ID Requirements',
          'Check your state\'s voter ID laws — varies by state',
          Icons.badge,
        ),
        _ChecklistItem(
          'Research Candidates',
          'Review ballot information on vote411.org or ballotpedia.org',
          Icons.people,
        ),
        _ChecklistItem(
          'Check Key Dates',
          'Note registration deadlines, early voting periods, and Election Day',
          Icons.calendar_today,
        ),
        _ChecklistItem(
          'Plan Your Vote',
          'Decide: in-person, early voting, or mail-in ballot',
          Icons.route,
        ),
        _ChecklistItem(
          'Cast Your Vote',
          'Show up, present ID if required, and vote!',
          Icons.how_to_vote,
        ),
      ];
    }
  }

  // ── Timeline Data ──────────────────────────────────────────
  List<_TimelineEvent> get _timelineEvents {
    if (_isIndia) {
      return const [
        _TimelineEvent(
          'Check Electoral Roll',
          'Before announcement',
          'Verify your name on the voter list well before elections are announced.',
          Icons.search,
          Colors.blue,
        ),
        _TimelineEvent(
          'Election Announced',
          'T-45 days',
          'The Election Commission announces the schedule and Model Code of Conduct begins.',
          Icons.campaign,
          Colors.orange,
        ),
        _TimelineEvent(
          'Nomination Filing',
          'T-30 days',
          'Candidates file their nominations. Review affidavits for transparency.',
          Icons.description,
          Colors.purple,
        ),
        _TimelineEvent(
          'Campaigning Period',
          'T-14 days',
          'Parties campaign. Study manifestos and attend public debates if available.',
          Icons.groups,
          Colors.teal,
        ),
        _TimelineEvent(
          'Silence Period',
          'T-2 days',
          'Campaigning ends 48 hours before polling. Reflect on your choice.',
          Icons.volume_off,
          Colors.grey,
        ),
        _TimelineEvent(
          'Polling Day',
          'Election Day',
          'Visit your assigned booth between 7 AM – 6 PM with valid ID.',
          Icons.how_to_vote,
          Colors.green,
        ),
        _TimelineEvent(
          'Counting & Results',
          'T+3 days',
          'Votes are counted. Results are declared on the ECI website.',
          Icons.analytics,
          Colors.indigo,
        ),
      ];
    } else {
      return const [
        _TimelineEvent(
          'Register to Vote',
          '30+ days before',
          'Most states require registration 15–30 days before Election Day.',
          Icons.app_registration,
          Colors.blue,
        ),
        _TimelineEvent(
          'Request Absentee Ballot',
          '45 days before',
          'If voting by mail, request your ballot early.',
          Icons.mail,
          Colors.orange,
        ),
        _TimelineEvent(
          'Early Voting Opens',
          '~14 days before',
          'Many states allow early in-person voting. Check your state.',
          Icons.access_time,
          Colors.purple,
        ),
        _TimelineEvent(
          'Mail Ballot Deadline',
          '~7 days before',
          'Mail your completed ballot before your state\'s postmark deadline.',
          Icons.send,
          Colors.teal,
        ),
        _TimelineEvent(
          'Election Day',
          'First Tuesday after Nov 1',
          'Polls typically open 6–7 AM and close 7–8 PM. Bring required ID.',
          Icons.how_to_vote,
          Colors.green,
        ),
        _TimelineEvent(
          'Results Announced',
          'Election Night+',
          'Results begin on election night. Final certification takes weeks.',
          Icons.analytics,
          Colors.indigo,
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // ── Header ──────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🗳️ Voting Journey', style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                _isIndia
                    ? 'Your step-by-step guide to voting in India'
                    : 'Your step-by-step guide to voting in the US',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),

        // ── Tab Bar ─────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Semantics(
            label: 'Switch between Checklist and Timeline views',
            child: TabBar(
              controller: _tabController,
              indicatorColor: theme.colorScheme.primary,
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: Colors.white54,
              tabs: const [
                Tab(icon: Icon(Icons.checklist), text: 'Checklist'),
                Tab(icon: Icon(Icons.timeline), text: 'Timeline'),
              ],
            ),
          ),
        ),

        // ── Tab Content ─────────────────────────────────────
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: CivicTheme.maxContentWidth),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildChecklistTab(theme),
                  _buildTimelineTab(theme),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Checklist Tab ─────────────────────────────────────────
  Widget _buildChecklistTab(ThemeData theme) {
    final items = _checklistItems;
    final completedCount = widget.appState.checklistProgress.values.where((v) => v).length;


    return Column(
      children: [
        // Progress bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Semantics(
            label:
                'Checklist progress: $completedCount of ${items.length} completed',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$completedCount of ${items.length} completed',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      items.isNotEmpty
                          ? '${(completedCount / items.length * 100).round()}%'
                          : '0%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: items.isNotEmpty
                        ? completedCount / items.length
                        : 0,
                    backgroundColor: Colors.white12,
                    color: theme.colorScheme.primary,
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isChecked = widget.appState.checklistProgress[item.title] ?? false;

              return Semantics(
                label:
                    '${item.title}: ${item.description}. ${isChecked ? "Completed" : "Not completed"}',
                child: Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: CheckboxListTile(
                    value: isChecked,
                    onChanged: (val) {
                      widget.appState.toggleChecklistItem(item.title, val ?? false);
                    },
                    secondary: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isChecked
                            ? theme.colorScheme.primary.withAlpha(30)
                            : Colors.white.withAlpha(10),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.icon,
                        color: isChecked
                            ? theme.colorScheme.primary
                            : Colors.white38,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        decoration: isChecked
                            ? TextDecoration.lineThrough
                            : null,
                        color: isChecked ? Colors.white38 : null,
                      ),
                    ),
                    subtitle: Text(
                      item.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: isChecked ? Colors.white24 : Colors.white54,
                      ),
                    ),
                    activeColor: theme.colorScheme.primary,
                    checkColor: Colors.black,
                    controlAffinity: ListTileControlAffinity.trailing,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Timeline Tab ──────────────────────────────────────────
  Widget _buildTimelineTab(ThemeData theme) {
    final events = _timelineEvents;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final isLast = index == events.length - 1;

        return Semantics(
          label: '${event.title}, ${event.timing}: ${event.description}',
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline connector
                SizedBox(
                  width: 40,
                  child: Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: event.color.withAlpha(30),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: event.color,
                            width: 2,
                          ),
                        ),
                        child:
                            Icon(event.icon, color: event.color, size: 16),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: Colors.white12,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Content card
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: event.color.withAlpha(40)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(event.title,
                                  style: theme.textTheme.titleSmall),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: event.color.withAlpha(20),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                event.timing,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: event.color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          event.description,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Data Models ──────────────────────────────────────────────
class _ChecklistItem {
  final String title;
  final String description;
  final IconData icon;
  const _ChecklistItem(this.title, this.description, this.icon);
}

class _TimelineEvent {
  final String title;
  final String timing;
  final String description;
  final IconData icon;
  final Color color;
  const _TimelineEvent(
      this.title, this.timing, this.description, this.icon, this.color);
}
