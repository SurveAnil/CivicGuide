// ignore_for_file: public_member_api_docs
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/app_state.dart';
import '../shell/main_shell.dart';
import 'login_screen.dart';

/// Watches Firebase auth state and shows LoginScreen or MainShell accordingly.
/// Also supports guest mode via SharedPreferences and AppState.
class AuthGate extends StatefulWidget {
  final AppState appState;
  const AuthGate({super.key, required this.appState});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _checkingGuest = true;

  @override
  void initState() {
    super.initState();
    _checkGuestStatus();
    widget.appState.addListener(_onAppStateChanged);
  }

  @override
  void dispose() {
    widget.appState.removeListener(_onAppStateChanged);
    super.dispose();
  }

  void _onAppStateChanged() {
    // Rebuild when guest mode changes
    if (mounted) setState(() {});
  }

  Future<void> _checkGuestStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final guest = prefs.getBool('guest_mode') ?? false;
    if (mounted) {
      widget.appState.setGuest(guest);
      setState(() => _checkingGuest = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingGuest) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Guest mode → go directly to main shell
    if (widget.appState.isGuest) {
      return MainShell(appState: widget.appState);
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Still connecting to Firebase
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // Signed in → show main app
        if (snapshot.hasData && snapshot.data != null) {
          return MainShell(appState: widget.appState);
        }
        // Signed out → show login
        return LoginScreen(appState: widget.appState);
      },
    );
  }
}
