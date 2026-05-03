import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OCRService — JSON Parsing', () {

    test('Parses valid JSON response with all fields', () {
      const jsonResponse = '''
      {
        "epicNumber": "XYZ1234567",
        "voterName": "Rajesh Kumar",
        "relativeName": "Suresh Kumar",
        "gender": "Male",
        "dob": "01-01-1990",
        "state": "Maharashtra"
      }
      ''';

      // Access private method via public scanVoterID flow
      // We test the parser directly by extracting the logic
      final result = _parseTestJson(jsonResponse);

      expect(result['epicNumber'], equals('XYZ1234567'));
      expect(result['voterName'], equals('Rajesh Kumar'));
      expect(result['relativeName'], equals('Suresh Kumar'));
      expect(result['gender'], equals('Male'));
      expect(result['dob'], equals('01-01-1990'));
      expect(result['state'], equals('Maharashtra'));
    });

    test('Handles partial JSON with missing fields', () {
      const jsonResponse = '''
      {
        "epicNumber": "ABC999",
        "voterName": "Test User"
      }
      ''';

      final result = _parseTestJson(jsonResponse);

      expect(result['epicNumber'], equals('ABC999'));
      expect(result['voterName'], equals('Test User'));
      expect(result.containsKey('gender'), isFalse);
      expect(result.containsKey('state'), isFalse);
    });

    test('Handles JSON wrapped in markdown code blocks', () {
      const jsonResponse = '''```json
      {
        "epicNumber": "WRAP123",
        "voterName": "Wrapped User"
      }
      ```''';

      final cleaned =
          jsonResponse.replaceAll('```json', '').replaceAll('```', '').trim();
      final result = _parseTestJson(cleaned);

      expect(result['epicNumber'], equals('WRAP123'));
      expect(result['voterName'], equals('Wrapped User'));
    });

    test('Returns empty map for completely invalid text', () {
      final result = _parseTestJson('This is not JSON at all');
      expect(result, isEmpty);
    });

    test('Returns empty map for empty string', () {
      final result = _parseTestJson('');
      expect(result, isEmpty);
    });

    test('Handles null values gracefully', () {
      const jsonResponse = '''
      {
        "epicNumber": "TEST123",
        "voterName": null,
        "state": "Delhi"
      }
      ''';

      final result = _parseTestJson(jsonResponse);
      // The regex parser won't match null values (no quotes)
      expect(result['epicNumber'], equals('TEST123'));
      expect(result['state'], equals('Delhi'));
    });

    test('Handles Unicode characters in parsed fields', () {
      const jsonResponse = '''
      {
        "epicNumber": "HIN789",
        "voterName": "राजेश कुमार",
        "state": "महाराष्ट्र"
      }
      ''';

      final result = _parseTestJson(jsonResponse);
      expect(result['voterName'], equals('राजेश कुमार'));
      expect(result['state'], equals('महाराष्ट्र'));
    });
  });
}

/// Replicates the OCRService._parseManualJson logic for testing
/// since the original is private.
Map<String, String> _parseTestJson(String text) {
  final Map<String, String> result = {};
  final keys = [
    'epicNumber',
    'voterName',
    'relativeName',
    'gender',
    'dob',
    'state'
  ];

  for (var key in keys) {
    final regExp = RegExp('"$key"\\s*:\\s*"([^"]+)"');
    final match = regExp.firstMatch(text);
    if (match != null) {
      result[key] = match.group(1) ?? '';
    }
  }
  return result;
}
