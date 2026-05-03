import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:civic_guide/main.dart' as app;
import 'package:civic_guide/ui/shell/main_shell.dart';
import 'package:civic_guide/ui/home/home_screen.dart';
import 'package:civic_guide/ui/journey/journey_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('CivicGuide End-to-End Flow', () {
    testWidgets('Guest Login -> Home -> Journey -> Toggle -> Language -> Failure', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 1. Guest Login -> Home loads
      // Find the "Continue as Guest" button on the AuthGate/LoginScreen
      final guestButton = find.text('Continue as Guest');
      expect(guestButton, findsOneWidget);
      await tester.tap(guestButton);
      await tester.pumpAndSettle();

      // Verify HomeScreen loads
      expect(find.byType(MainShell), findsOneWidget);
      expect(find.byType(HomeScreen), findsOneWidget);

      // 2. Language Selection Flow
      // Verify app starts in default language (English)
      expect(find.text('🌐 English'), findsOneWidget);
      
      // Tap language dropdown and switch to Hindi
      await tester.tap(find.text('🌐 English'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('🌐 Hindi').last);
      await tester.pumpAndSettle();

      // Verify UI translates (e.g. Chat greeting translates to Hindi)
      expect(find.text('🌐 Hindi'), findsOneWidget);

      // 3. Navigation to JourneyScreen
      // Tap the 'Journey' tab in the bottom navigation bar
      final journeyTab = find.text('Journey');
      expect(journeyTab, findsOneWidget);
      await tester.tap(journeyTab);
      await tester.pumpAndSettle();

      // Verify JourneyScreen loads
      expect(find.byType(JourneyScreen), findsOneWidget);

      // 4. Checklist Interaction Flow
      // Find a checklist checkbox (e.g. "Verify Voter Registration") and tap it
      final firstCheckbox = find.byType(Checkbox).first;
      expect(firstCheckbox, findsOneWidget);
      
      // Check its initial state (should be false/unchecked)
      var checkboxWidget = tester.widget<Checkbox>(firstCheckbox);
      expect(checkboxWidget.value, isFalse);

      // Tap it
      await tester.tap(firstCheckbox);
      await tester.pumpAndSettle();

      // Verify it toggled to true
      checkboxWidget = tester.widget<Checkbox>(firstCheckbox);
      expect(checkboxWidget.value, isTrue);

      // 5. Navigate back to Home and test Failure/Recovery Flow
      final homeTab = find.text('Home');
      await tester.tap(homeTab);
      await tester.pumpAndSettle();

      // Ensure language remained Hindi
      expect(find.text('🌐 Hindi'), findsOneWidget);

      // Trigger a failure state by typing nonsense into the location input
      final chatInput = find.byType(TextField);
      expect(chatInput, findsOneWidget);
      await tester.enterText(chatInput, 'INVALID_LOCATION_123');
      await tester.testTextInput.receiveAction(TextInputAction.send);
      await tester.pumpAndSettle();

      // The controller should respond with a failure/invalid message
      // Note: we're in Hindi, so the message is 'कृपया एक वैध 6-अंकीय भारतीय पिन कोड दर्ज करें।' (in_pin_invalid)
      // We look for a ChatBubble containing "कृपया" (please)
      expect(find.textContaining('कृपया'), findsWidgets);
    });
  });
}
