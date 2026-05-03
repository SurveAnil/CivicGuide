/// Widget tests for CivicGuide.
///
/// Note: Full-app widget tests are not possible in the standard test runner
/// because [LoginScreen] imports `google_sign_in_web` which depends on
/// `dart:js_interop` (a web-only library). These tests focus on isolated
/// widgets that do not have web-platform dependencies.
library;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:civic_guide/providers/app_state.dart';
import 'package:civic_guide/ui/resources/resources_screen.dart';
import 'package:civic_guide/ui/helpline/helpline_screen.dart';
import 'package:civic_guide/models/country_mode.dart';

void main() {
  group('ResourcesScreen Widget', () {
    testWidgets('Renders India resources for India country',
        (WidgetTester tester) async {
      final appState = AppState();
      appState.setCountry(CountryMode.india);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(body: ResourcesScreen(appState: appState)),
        ),
      );

      expect(find.text('📚 Resources'), findsOneWidget);
      expect(find.text('Election resources for Indian voters'), findsOneWidget);
      expect(find.text('Voting Guide'), findsOneWidget);
      expect(find.text('NVSP Portal'), findsOneWidget);
    });

    testWidgets('Renders US resources for US country',
        (WidgetTester tester) async {
      final appState = AppState();
      appState.setCountry(CountryMode.us);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(body: ResourcesScreen(appState: appState)),
        ),
      );

      expect(find.text('📚 Resources'), findsOneWidget);
      expect(find.text('Election resources for US voters'), findsOneWidget);
      expect(find.text('Mail-in Voting'), findsOneWidget);
    });

    testWidgets('Tapping a resource card opens bottom sheet',
        (WidgetTester tester) async {
      final appState = AppState();

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(body: ResourcesScreen(appState: appState)),
        ),
      );

      await tester.tap(find.text('Voting Guide'));
      await tester.pumpAndSettle();

      expect(find.text('Ask AI about this'), findsOneWidget);
    });
  });

  group('HelplineScreen Widget', () {
    testWidgets('Renders India helplines', (WidgetTester tester) async {
      final appState = AppState();
      appState.setCountry(CountryMode.india);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(body: HelplineScreen(appState: appState)),
        ),
      );

      expect(find.text('📞 Helpline'), findsOneWidget);
      expect(find.text('Election Commission of India'), findsOneWidget);
      expect(find.text('1800-111-950'), findsOneWidget);
    });

    testWidgets('Renders US helplines', (WidgetTester tester) async {
      final appState = AppState();
      appState.setCountry(CountryMode.us);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(body: HelplineScreen(appState: appState)),
        ),
      );

      expect(find.text('📞 Helpline'), findsOneWidget);
      expect(find.text('USA.gov Vote'), findsOneWidget);
    });
  });
}
