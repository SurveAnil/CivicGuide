import 'package:flutter_test/flutter_test.dart';
import 'package:civic_guide/providers/app_state.dart';
import 'package:civic_guide/models/country_mode.dart';

void main() {
  group('AppState — Notification Tests', () {
    late AppState appState;
    late int notificationCount;

    setUp(() {
      appState = AppState();
      notificationCount = 0;
      appState.addListener(() => notificationCount++);
    });

    test('setCountry notifies listeners', () {
      appState.setCountry(CountryMode.us);
      expect(notificationCount, equals(1));
    });

    test('setCountry does NOT notify if same country', () {
      // Default is india
      appState.setCountry(CountryMode.india);
      expect(notificationCount, equals(0));
    });

    test('setLanguage notifies listeners', () {
      appState.setLanguage('Hindi');
      expect(notificationCount, equals(1));
    });

    test('setLanguage does NOT notify if same language', () {
      appState.setLanguage('English');
      expect(notificationCount, equals(0));
    });

    test('setLocationCode always notifies', () {
      appState.setLocationCode('110001');
      expect(notificationCount, equals(1));
    });

    test('setGuest notifies listeners', () {
      appState.setGuest(true);
      expect(notificationCount, equals(1));
    });

    test('Multiple state changes produce correct notification count', () {
      appState.setCountry(CountryMode.us);
      appState.setLanguage('Spanish');
      appState.setLocationCode('10001');
      appState.setGuest(true);
      expect(notificationCount, equals(4));
    });
  });

  group('AppState — Country Switching Edge Cases', () {
    late AppState appState;

    setUp(() {
      appState = AppState();
    });

    test('Switching country clears location code', () {
      appState.setLocationCode('110001');
      expect(appState.locationCode, equals('110001'));

      appState.setCountry(CountryMode.us);
      expect(appState.locationCode, isEmpty);
    });

    test('Switching back to same country still clears location if different', () {
      appState.setCountry(CountryMode.us);
      appState.setLocationCode('10001');
      appState.setCountry(CountryMode.india);
      expect(appState.locationCode, isEmpty);
    });

    test('countryConfig updates correctly after country switch', () {
      expect(appState.countryConfig.codeLength, equals(6));
      appState.setCountry(CountryMode.us);
      expect(appState.countryConfig.codeLength, equals(5));
    });
  });

  group('AppState — Guest Mode Flow', () {
    late AppState appState;

    setUp(() {
      appState = AppState();
    });

    test('Guest mode starts as false', () {
      expect(appState.isGuest, isFalse);
    });

    test('Guest can toggle on and off', () {
      appState.setGuest(true);
      expect(appState.isGuest, isTrue);

      appState.setGuest(false);
      expect(appState.isGuest, isFalse);
    });

    test('Guest mode does not affect country or language', () {
      appState.setLanguage('Marathi');
      appState.setCountry(CountryMode.us);
      appState.setGuest(true);

      expect(appState.language, equals('Marathi'));
      expect(appState.country, equals(CountryMode.us));
    });
  });

  group('AppState — Language Support', () {
    late AppState appState;

    setUp(() {
      appState = AppState();
    });

    test('Supports English', () {
      appState.setLanguage('English');
      expect(appState.language, equals('English'));
    });

    test('Supports Hindi', () {
      appState.setLanguage('Hindi');
      expect(appState.language, equals('Hindi'));
    });

    test('Supports Marathi', () {
      appState.setLanguage('Marathi');
      expect(appState.language, equals('Marathi'));
    });

    test('Supports Spanish', () {
      appState.setLanguage('Spanish');
      expect(appState.language, equals('Spanish'));
    });
  });
}
