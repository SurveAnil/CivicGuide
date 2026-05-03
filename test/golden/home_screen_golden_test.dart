import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:civic_guide/ui/home/home_screen.dart';
import 'package:civic_guide/providers/app_state.dart';
import 'package:provider/provider.dart';

void main() {
  group('HomeScreen Golden Tests', () {
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

    testWidgets('HomeScreen matches golden - Mobile Width', (WidgetTester tester) async {
      final appState = AppState();
      
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: appState,
          child: buildTestableWidget(HomeScreen(appState: appState), const Size(390, 844)),
        ),
      );
      
      // Wait for animations/initialization
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(HomeScreen),
        matchesGoldenFile('goldens/home_screen_mobile.png'),
      );
    });

    testWidgets('HomeScreen matches golden - Desktop Width', (WidgetTester tester) async {
      final appState = AppState();
      
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: appState,
          child: buildTestableWidget(HomeScreen(appState: appState), const Size(1024, 768)),
        ),
      );
      
      // Wait for animations/initialization
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(HomeScreen),
        matchesGoldenFile('goldens/home_screen_desktop.png'),
      );
    });
  });
}
