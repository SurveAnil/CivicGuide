// ignore_for_file: public_member_api_docs
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/country_mode.dart';
import '../../models/user_profile.dart';
import '../../providers/app_state.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../services/ocr_service.dart' deferred as ocr;
import '../../core/theme.dart';

class ProfileScreen extends StatefulWidget {
  final AppState appState;
  const ProfileScreen({super.key, required this.appState});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final ImagePicker _imagePicker = ImagePicker();

  bool _isScanning = false;
  User? get _user => FirebaseAuth.instance.currentUser;
  bool get _isGuest => widget.appState.isGuest;

  Future<void> _handleScanVoterID() async {
    if (_isGuest) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign in to use Voter ID scanning.')),
      );
      return;
    }

    final XFile? picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (picked == null) return;

    setState(() => _isScanning = true);
    try {
      final bytes = await picked.readAsBytes();
      await ocr.loadLibrary();
      final ocrService = ocr.OCRService();
      final data = await ocrService.scanVoterID(bytes);

      if (data != null && _user != null) {
        final profile = UserProfile(
          uid: _user!.uid,
          displayName: _user!.displayName,
          email: _user!.email,
          photoUrl: _user!.photoURL,
          epicNumber: data['epicNumber'],
          voterName: data['voterName'],
          relativeName: data['relativeName'],
          gender: data['gender'],
          dateOfBirth: data['dob'],
          state: data['state'],
        );
        await _firestoreService.saveProfile(profile);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Voter ID details extracted and saved securely!')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Failed to read ID. Please ensure the photo is clear.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  Future<void> _handleLogout() async {
    if (_isGuest) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('guest_mode');
      widget.appState.setGuest(false);
    } else {
      await _authService.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIndia = widget.appState.country == CountryMode.india;

    // Guest mode — simplified profile
    if (_isGuest) {
      return _buildGuestProfile(theme, isIndia);
    }

    return StreamBuilder<UserProfile?>(
      stream: _user != null
          ? _firestoreService.streamProfile(_user!.uid)
          : Stream.value(null),
      builder: (context, snapshot) {
        final profile = snapshot.data;
        return _buildAuthenticatedProfile(theme, isIndia, profile);
      },
    );
  }

  Widget _buildGuestProfile(ThemeData theme, bool isIndia) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: CivicTheme.maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('👤 Profile', style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),

              // Guest info card
              _buildCard(
                theme: theme,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: theme.colorScheme.primary.withAlpha(50),
                      child: Icon(Icons.person_outline,
                          size: 32, color: theme.colorScheme.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Guest User', style: theme.textTheme.titleSmall),
                          const SizedBox(height: 2),
                          Text('Limited features available',
                              style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Sign in prompt
              _buildCard(
                theme: theme,
                child: Column(
                  children: [
                    const Icon(Icons.lock_outline, color: Colors.orange, size: 36),
                    const SizedBox(height: 12),
                    Text('Sign in to unlock all features',
                        style: theme.textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(
                      'Voter ID scanning, digital voter card, and data sync require a Google account.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: Semantics(
                        button: true,
                        label: 'Exit guest mode and sign in',
                        child: FilledButton.icon(
                          onPressed: _handleLogout,
                          icon: const Icon(Icons.login),
                          label: const Text('Sign In'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Settings
              Text('Settings', style: theme.textTheme.titleMedium),
              const SizedBox(height: 10),
              _buildSettingTile(
                  theme, Icons.language, 'Language', widget.appState.language),
              _buildSettingTile(theme, Icons.public, 'Country',
                  widget.appState.countryConfig.name),
              _buildSettingTile(
                  theme, Icons.info_outline, 'App Version', '2.0.0'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthenticatedProfile(
      ThemeData theme, bool isIndia, UserProfile? profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: CivicTheme.maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('👤 Profile', style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),

              // ── User Info Card ────────────────────────────────────
              _buildCard(
                theme: theme,
                child: Row(
                  children: [
                    Semantics(
                      label: 'Profile picture',
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor:
                            theme.colorScheme.primary.withAlpha(50),
                        backgroundImage: _user?.photoURL != null
                            ? NetworkImage(_user!.photoURL!)
                            : null,
                        child: _user?.photoURL == null
                            ? Icon(Icons.person,
                                size: 32, color: theme.colorScheme.primary)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_user?.displayName ?? 'Anonymous User',
                              style: theme.textTheme.titleSmall),
                          const SizedBox(height: 2),
                          Text(_user?.email ?? 'Logged in via Google',
                              style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                    Semantics(
                      button: true,
                      label: 'Sign out',
                      child: IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white38),
                        onPressed: _handleLogout,
                        tooltip: 'Sign Out',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── India: Digital Voter Card ──────────────────────────
              if (isIndia) ...[
                _buildCard(
                  theme: theme,
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withAlpha(30),
                      theme.colorScheme.surface,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderColor: theme.colorScheme.primary.withAlpha(60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.credit_card,
                              color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Text('Digital Voter Card',
                              style: theme.textTheme.titleSmall),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: profile?.epicNumber != null
                                  ? Colors.green.withAlpha(30)
                                  : Colors.orange.withAlpha(30),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              profile?.epicNumber != null
                                  ? '✅ Verified'
                                  : 'Not Scanned',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: profile?.epicNumber != null
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (profile?.epicNumber != null) ...[
                        _buildVoterDetail(
                            'Name', profile!.voterName ?? 'Not found'),
                        _buildVoterDetail(
                            'EPIC No.', profile.epicNumber ?? 'Not found'),
                        _buildVoterDetail(
                            'State', profile.state ?? 'Not found'),
                      ] else ...[
                        Text(
                          'Scan your EPIC voter ID card to create a secure digital copy.',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: Semantics(
                          button: true,
                          label: _isScanning
                              ? 'Processing voter ID scan'
                              : 'Scan voter ID card',
                          child: OutlinedButton.icon(
                            onPressed: _isScanning ? null : _handleScanVoterID,
                            icon: _isScanning
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2))
                                : const Icon(Icons.qr_code_scanner),
                            label: Text(
                                _isScanning ? 'Processing…' : 'Scan Voter ID'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // ── US: Preferences & Links ───────────────────────────
              if (!isIndia) ...[
                _buildInfoCard(theme, 'State', 'Not selected', Icons.map),
                const SizedBox(height: 10),
                _buildInfoCard(theme, 'Registration Status',
                    'Check on your state website', Icons.app_registration),
                const SizedBox(height: 10),
                _buildLinkCard(theme, 'Register to Vote', 'https://vote.gov',
                    Icons.how_to_vote),
                const SizedBox(height: 10),
                _buildLinkCard(theme, 'Check Registration',
                    'https://www.nass.org/can-I-vote', Icons.search),
                const SizedBox(height: 16),
              ],

              // ── Settings Section ──────────────────────────────────
              Text('Settings', style: theme.textTheme.titleMedium),
              const SizedBox(height: 10),
              _buildSettingTile(
                  theme, Icons.language, 'Language', widget.appState.language),
              _buildSettingTile(theme, Icons.public, 'Country',
                  widget.appState.countryConfig.name),
              _buildSettingTile(
                  theme, Icons.info_outline, 'App Version', '2.0.0'),
            ],
          ),
        ),
      ),
    );
  }

  // ── Reusable Card Widget ──────────────────────────────────────
  Widget _buildCard({
    required ThemeData theme,
    required Widget child,
    Gradient? gradient,
    Color? borderColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: gradient == null ? theme.colorScheme.surface : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor ?? Colors.white10),
      ),
      child: child,
    );
  }

  Widget _buildVoterDetail(String label, String value) {
    return Semantics(
      label: '$label: $value',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Text('$label: ',
                style: const TextStyle(color: Colors.white38, fontSize: 13)),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      ThemeData theme, String label, String value, IconData icon) {
    return Semantics(
      label: '$label: $value',
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: theme.textTheme.bodySmall),
                  Text(value, style: theme.textTheme.titleSmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkCard(
      ThemeData theme, String label, String url, IconData icon) {
    return Semantics(
      button: true,
      label: '$label: $url',
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.secondary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: theme.textTheme.titleSmall),
                  Text(url,
                      style: TextStyle(
                          fontSize: 11, color: theme.colorScheme.secondary)),
                ],
              ),
            ),
            const Icon(Icons.open_in_new, size: 18, color: Colors.white38),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile(
      ThemeData theme, IconData icon, String label, String value) {
    return Semantics(
      label: '$label: $value',
      child: ListTile(
        dense: true,
        leading: Icon(icon, color: Colors.white38, size: 22),
        title: Text(label, style: theme.textTheme.bodyMedium),
        trailing: Text(value, style: theme.textTheme.bodySmall),
      ),
    );
  }
}
