import 'package:flutter_test/flutter_test.dart';
import 'package:civic_guide/models/country_mode.dart';

void main() {
  group('CountryMode Enum', () {
    test('Has india and us values', () {
      expect(CountryMode.values.length, equals(2));
      expect(CountryMode.values, contains(CountryMode.india));
      expect(CountryMode.values, contains(CountryMode.us));
    });
  });

  group('CountryConfig — India', () {
    test('Has correct mode', () {
      expect(CountryConfig.india.mode, equals(CountryMode.india));
    });

    test('Has correct display name', () {
      expect(CountryConfig.india.name, equals('India'));
    });

    test('Has correct flag emoji', () {
      expect(CountryConfig.india.flag, equals('🇮🇳'));
    });

    test('Has correct code label', () {
      expect(CountryConfig.india.codeLabel, equals('PIN Code'));
    });

    test('Has correct code length of 6', () {
      expect(CountryConfig.india.codeLength, equals(6));
    });
  });

  group('CountryConfig — US', () {
    test('Has correct mode', () {
      expect(CountryConfig.us.mode, equals(CountryMode.us));
    });

    test('Has correct display name', () {
      expect(CountryConfig.us.name, equals('United States'));
    });

    test('Has correct flag emoji', () {
      expect(CountryConfig.us.flag, equals('🇺🇸'));
    });

    test('Has correct code label', () {
      expect(CountryConfig.us.codeLabel, equals('ZIP Code'));
    });

    test('Has correct code length of 5', () {
      expect(CountryConfig.us.codeLength, equals(5));
    });
  });

  group('CountryConfig — Equality', () {
    test('India and US configs are different', () {
      expect(CountryConfig.india.mode, isNot(equals(CountryConfig.us.mode)));
      expect(CountryConfig.india.name, isNot(equals(CountryConfig.us.name)));
      expect(CountryConfig.india.codeLength,
          isNot(equals(CountryConfig.us.codeLength)));
    });
  });
}
