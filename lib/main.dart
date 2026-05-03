// ignore_for_file: public_member_api_docs
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'providers/app_state.dart';
import 'ui/auth/auth_gate.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CivicGuideApp());
}

class CivicGuideApp extends StatefulWidget {
  const CivicGuideApp({super.key});

  @override
  State<CivicGuideApp> createState() => _CivicGuideAppState();
}

class _CivicGuideAppState extends State<CivicGuideApp> {
  final AppState _appState = AppState();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _appState,
      child: MaterialApp(
        title: 'CivicGuide',
        theme: CivicTheme.darkTheme,
        home: AuthGate(appState: _appState),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
