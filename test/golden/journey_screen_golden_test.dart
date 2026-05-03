import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:civic_guide/ui/journey/journey_screen.dart';
import 'package:civic_guide/providers/app_state.dart';
import 'package:provider/provider.dart';

void main() {
  group('JourneyScreen Golden Tests', () {
    Widget buildTestableWidget(Widget child, Size size) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: MediaQuery(
          data: MediaQueryData(size: size),
          child: Scaffold(body: child),
        ),
      );
    }

    testWidgets('JourneyScreen matches golden - Mobile Width', (WidgetTester tester) async {
      final appState = AppState();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: appState,
          child: buildTestableWidget(JourneyScreen(appState: appState), const Size(390, 844)),
        ),
      );
      
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(JourneyScreen),
        matchesGoldenFile('goldens/journey_screen_mobile.png'),
      );
    });

    testWidgets('JourneyScreen matches golden - Desktop Width', (WidgetTester tester) async {
      final appState = AppState();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: appState,
          child: buildTestableWidget(JourneyScreen(appState: appState), const Size(1024, 768)),
        ),
      );
      
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(JourneyScreen),
        matchesGoldenFile('goldens/journey_screen_desktop.png'),
      );
    });
  });
}
