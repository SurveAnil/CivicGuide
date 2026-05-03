// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';
import '../../providers/app_state.dart';
import '../../core/theme.dart';

class LoginScreen extends StatefulWidget {
  final AppState appState;
  const LoginScreen({super.key, required this.appState});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _authService.googleSignIn.onCurrentUserChanged.listen((account) {
        if (account != null) {
          _handleGoogleSignIn();
        }
      });
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    final result = await _authService.signInWithGoogle();
    if (!mounted) return;
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Sign-in cancelled or failed. Please try again.')),
      );
    }
    setState(() => _isLoading = false);
  }

  Future<void> _continueAsGuest() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('guest_mode', true);
    if (!mounted) return;
    // Setting guest on appState triggers AuthGate rebuild → MainShell
    widget.appState.setGuest(true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: CivicTheme.maxContentWidth),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: FocusTraversalGroup(
                policy: OrderedTraversalPolicy(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ── Logo / Icon ──────────────────────────────────
                    Semantics(
                      label: 'CivicGuide logo',
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary.withAlpha(30),
                          border: Border.all(
                              color: theme.colorScheme.primary.withAlpha(80),
                              width: 2),
                        ),
                        child: Icon(Icons.how_to_vote_rounded,
                            size: 52, color: theme.colorScheme.primary),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── App Title ────────────────────────────────────
                    Semantics(
                      header: true,
                      child: RichText(
                        text: TextSpan(
                          style: theme.textTheme.displaySmall,
                          children: [
                            const TextSpan(
                                text: 'Civic',
                                style: TextStyle(color: Colors.white)),
                            TextSpan(
                                text: 'Guide',
                                style: TextStyle(
                                    color: theme.colorScheme.primary)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your intelligent civic assistant',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 40),

                    // ── Feature Highlights ───────────────────────────
                    _buildFeatureTile(
                        theme, Icons.search, 'AI-powered election guidance'),
                    _buildFeatureTile(
                        theme, Icons.language, 'Multilingual support'),
                    _buildFeatureTile(theme, Icons.credit_card,
                        'Secure digital voter card (India)'),
                    _buildFeatureTile(theme, Icons.lock_outline,
                        'Privacy-first, no data sold'),
                    const SizedBox(height: 40),

                    // ── Google Sign-In Button ────────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: _isLoading
                          ? const Center(
                              child: Padding(
                              padding: EdgeInsets.all(12),
                              child: CircularProgressIndicator(),
                            ))
                          : kIsWeb
                              ? Center(
                                  child: Semantics(
                                    button: true,
                                    label: 'Sign in with Google',
                                    child: (GoogleSignInPlatform.instance
                                            as dynamic)
                                        .renderButton(
                                      configuration: GSIButtonConfiguration(
                                        theme: GSIButtonTheme.filledBlue,
                                        size: GSIButtonSize.large,
                                        shape: GSIButtonShape.pill,
                                      ),
                                    ),
                                  ),
                                )
                              : Semantics(
                                  button: true,
                                  label: 'Continue with Google sign-in',
                                  child: OutlinedButton.icon(
                                    onPressed: _handleGoogleSignIn,
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                          color: theme.colorScheme.primary
                                              .withAlpha(100)),
                                      backgroundColor:
                                          theme.colorScheme.surface,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14)),
                                    ),
                                    icon: const _GoogleLogo(),
                                    label: const Text(
                                      'Continue with Google',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                    ),
                    const SizedBox(height: 16),

                    // ── Continue as Guest ────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: Semantics(
                        button: true,
                        label: 'Continue as guest without signing in',
                        child: OutlinedButton.icon(
                          onPressed: _continueAsGuest,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white24),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          icon: const Icon(Icons.person_outline,
                              size: 20, color: Colors.white54),
                          label: const Text(
                            'Continue as Guest',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white54),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Guest mode has limited features. Sign in to save voter data.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.white30),
                    ),

                    const SizedBox(height: 20),
                    const Text(
                      'By continuing, you agree to our privacy-first data policy.\nWe never sell your data.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: Colors.white24),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureTile(ThemeData theme, IconData icon, String label) {
    return Semantics(
      label: label,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple inline Google 'G' logo widget
class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      child: const Center(
        child: Text(
          'G',
          style: TextStyle(
            color: Color(0xFF4285F4),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
