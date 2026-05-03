import 'package:flutter_test/flutter_test.dart';
import 'package:civic_guide/core/location_utils.dart';

void main() {
  group('LocationUtils — ZIP Code Extraction', () {
    test('Valid 5-digit ZIP code is extracted', () {
      expect(LocationUtils.extractZipCode('10001'), equals('10001'));
    });

    test('ZIP code with city name in parentheses is extracted', () {
      expect(LocationUtils.extractZipCode('10001 (New York)'), equals('10001'));
    });

    test('ZIP code with different city is extracted', () {
      expect(LocationUtils.extractZipCode('90210 (Beverly Hills)'), equals('90210'));
    });

    test('4-digit number returns empty string', () {
      expect(LocationUtils.extractZipCode('1234'), equals(''));
    });

    test('6-digit number returns empty string for ZIP', () {
      expect(LocationUtils.extractZipCode('123456'), equals(''));
    });

    test('Letters return empty string', () {
      expect(LocationUtils.extractZipCode('abcde'), equals(''));
    });

    test('Empty string returns empty', () {
      expect(LocationUtils.extractZipCode(''), equals(''));
    });

    test('Mixed alphanumeric returns empty', () {
      expect(LocationUtils.extractZipCode('10a01'), equals(''));
    });

    test('ZIP with leading/trailing whitespace is trimmed and extracted', () {
      expect(LocationUtils.extractZipCode('  10001  '), equals('10001'));
    });

    test('ZIP followed by random text returns empty', () {
      expect(LocationUtils.extractZipCode('10001 random'), equals(''));
    });
  });

  group('LocationUtils — PIN Code Extraction', () {
    test('Valid 6-digit PIN code is extracted', () {
      expect(LocationUtils.extractPinCode('411057'), equals('411057'));
    });

    test('PIN code with city name in parentheses is extracted', () {
      expect(LocationUtils.extractPinCode('411057 (Pune)'), equals('411057'));
    });

    test('PIN code with different city is extracted', () {
      expect(LocationUtils.extractPinCode('110001 (New Delhi)'), equals('110001'));
    });

    test('5-digit number returns empty string for PIN', () {
      expect(LocationUtils.extractPinCode('10001'), equals(''));
    });

    test('7-digit number returns empty string', () {
      expect(LocationUtils.extractPinCode('1234567'), equals(''));
    });

    test('Letters return empty string', () {
      expect(LocationUtils.extractPinCode('abcdef'), equals(''));
    });

    test('Empty string returns empty', () {
      expect(LocationUtils.extractPinCode(''), equals(''));
    });

    test('PIN with leading/trailing whitespace is trimmed and extracted', () {
      expect(LocationUtils.extractPinCode('  411057  '), equals('411057'));
    });

    test('PIN followed by random text returns empty', () {
      expect(LocationUtils.extractPinCode('411057 random'), equals(''));
    });
  });
}
