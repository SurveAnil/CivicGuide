// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'dart:async';
import '../../models/country_mode.dart';
import '../../providers/app_state.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../models/user_profile.dart';
import '../home/home_screen.dart';
import '../resources/resources_screen.dart';
import '../helpline/helpline_screen.dart';
import '../profile/profile_screen.dart';
import '../journey/journey_screen.dart';

class MainShell extends StatefulWidget {
  final AppState appState;
  const MainShell({super.key, required this.appState});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  // Navigation is now controlled via AppState to allow programmatic redirects.


  static const _languages = ['English', 'Hindi', 'Marathi', 'Spanish'];
  final FirestoreService _firestoreService = FirestoreService();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(appState: widget.appState),
      JourneyScreen(appState: widget.appState),
      ResourcesScreen(appState: widget.appState),
      HelplineScreen(appState: widget.appState),
      ProfileScreen(appState: widget.appState),
    ];
    _initSync();
  }

  bool _isSyncingFromRemote = false;

  StreamSubscription? _profileSub;


  void _initSync() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _profileSub = _firestoreService.streamProfile(user.uid).listen((profile) {
        if (profile != null && mounted) {
          _isSyncingFromRemote = true;
          
          if (profile.checklistProgress != null) {
            widget.appState.setChecklistProgress(profile.checklistProgress!);
          }
          if (profile.languagePreference != null) {
            widget.appState.setLanguage(profile.languagePreference!);
          }
          
          _isSyncingFromRemote = false;
        }
      });
    }

    widget.appState.addListener(_onAppStateChanged);
  }

  void _onAppStateChanged() {
    if (_isSyncingFromRemote) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _firestoreService.saveProfile(UserProfile(
        uid: user.uid,
        checklistProgress: widget.appState.checklistProgress,
        languagePreference: widget.appState.language,
      ));
    }
  }

  @override
  void dispose() {
    _profileSub?.cancel();
    widget.appState.removeListener(_onAppStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // 🔥 Rebuild Optimization: Only rebuild shell when country or language changes.
    final country = context.select<AppState, CountryMode>((state) => state.country);
    final language = context.select<AppState, String>((state) => state.language);
    final tabIndex = context.select<AppState, int>((state) => state.currentTabIndex);

    return Scaffold(
          appBar: AppBar(
            title: Semantics(
              header: true,
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                  children: [
                    const TextSpan(
                        text: 'Civic', style: TextStyle(color: Colors.white)),
                    TextSpan(
                        text: 'Guide',
                        style: TextStyle(color: theme.colorScheme.primary)),
                  ],
                ),
              ),
            ),
            actions: [
              // ── Country Selector ───────────────────────────
              Semantics(
                label: 'Select country',
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<CountryMode>(
                      value: country,
                      dropdownColor: theme.colorScheme.surface,
                      icon: const Icon(Icons.arrow_drop_down, size: 18),
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.white),
                      items: const [
                        DropdownMenuItem(
                          value: CountryMode.india,
                          child: Text('🇮🇳 India'),
                        ),
                        DropdownMenuItem(
                          value: CountryMode.us,
                          child: Text('🇺🇸 US'),
                        ),
                      ],
                      onChanged: (mode) {
                        if (mode != null) widget.appState.setCountry(mode);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),

              // ── Language Selector ──────────────────────────
              Semantics(
                label: 'Select language',
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: language,
                      dropdownColor: theme.colorScheme.surface,
                      icon: const Icon(Icons.arrow_drop_down, size: 18),
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.white),
                      items: _languages.map((lang) {
                        return DropdownMenuItem(
                            value: lang, child: Text('🌐 $lang'));
                      }).toList(),
                      onChanged: (lang) {
                        if (lang != null) widget.appState.setLanguage(lang);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: IndexedStack(
            index: tabIndex,
            children: _screens,
          ),
          bottomNavigationBar: Semantics(
            label: 'Main navigation',
            child: NavigationBar(
              selectedIndex: tabIndex,
              onDestinationSelected: (i) => widget.appState.setTabIndex(i),
              backgroundColor: theme.colorScheme.surface,
              indicatorColor: theme.colorScheme.primary.withAlpha(50),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                  tooltip: 'Home screen with chat assistant',
                ),
                NavigationDestination(
                  icon: Icon(Icons.checklist_outlined),
                  selectedIcon: Icon(Icons.checklist),
                  label: 'Journey',
                  tooltip: 'Voting checklist and timeline',
                ),
                NavigationDestination(
                  icon: Icon(Icons.library_books_outlined),
                  selectedIcon: Icon(Icons.library_books),
                  label: 'Resources',
                  tooltip: 'Election resources and guides',
                ),
                NavigationDestination(
                  icon: Icon(Icons.phone_outlined),
                  selectedIcon: Icon(Icons.phone),
                  label: 'Helpline',
                  tooltip: 'Emergency and support contacts',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile',
                  tooltip: 'Your profile and settings',
                ),
              ],
            ),
          ),
        );
  }
}
