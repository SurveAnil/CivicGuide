import 'package:flutter_test/flutter_test.dart';
import 'package:civic_guide/models/user_profile.dart';

void main() {
  group('UserProfile — Serialization', () {
    test('toMap includes all fields', () {
      final profile = UserProfile(
        uid: 'test-uid-123',
        displayName: 'Test User',
        email: 'test@example.com',
        photoUrl: 'https://example.com/photo.jpg',
        epicNumber: 'XYZ1234567',
        voterName: 'Test Voter',
        relativeName: 'Test Parent',
        gender: 'Male',
        dateOfBirth: '01-01-1990',
        state: 'Maharashtra',
      );

      final map = profile.toMap();

      expect(map['uid'], equals('test-uid-123'));
      expect(map['displayName'], equals('Test User'));
      expect(map['email'], equals('test@example.com'));
      expect(map['photoUrl'], equals('https://example.com/photo.jpg'));
      expect(map['epicNumber'], equals('XYZ1234567'));
      expect(map['voterName'], equals('Test Voter'));
      expect(map['relativeName'], equals('Test Parent'));
      expect(map['gender'], equals('Male'));
      expect(map['dateOfBirth'], equals('01-01-1990'));
      expect(map['state'], equals('Maharashtra'));
      expect(map['updatedAt'], isNotNull);
    });

    test('toMap handles null optional fields', () {
      final profile = UserProfile(uid: 'uid-only');
      final map = profile.toMap();

      expect(map['uid'], equals('uid-only'));
      expect(map['displayName'], isNull);
      expect(map['email'], isNull);
      expect(map['epicNumber'], isNull);
    });

    test('fromMap reconstructs a complete profile', () {
      final map = {
        'uid': 'test-uid',
        'displayName': 'Jane Doe',
        'email': 'jane@example.com',
        'photoUrl': null,
        'epicNumber': 'ABC9876543',
        'voterName': 'Jane D.',
        'relativeName': 'John D.',
        'gender': 'Female',
        'dateOfBirth': '15-03-1985',
        'state': 'Delhi',
      };

      final profile = UserProfile.fromMap(map);

      expect(profile.uid, equals('test-uid'));
      expect(profile.displayName, equals('Jane Doe'));
      expect(profile.epicNumber, equals('ABC9876543'));
      expect(profile.state, equals('Delhi'));
    });

    test('fromMap uses empty string as default for missing uid', () {
      final profile = UserProfile.fromMap({});
      expect(profile.uid, equals(''));
    });

    test('fromMap gracefully handles partial data', () {
      final profile = UserProfile.fromMap({
        'uid': 'partial-uid',
        'displayName': 'Partial User',
      });

      expect(profile.uid, equals('partial-uid'));
      expect(profile.displayName, equals('Partial User'));
      expect(profile.email, isNull);
      expect(profile.epicNumber, isNull);
    });

    test('Round-trip serialization preserves data', () {
      final original = UserProfile(
        uid: 'round-trip',
        displayName: 'Round Trip',
        email: 'round@trip.com',
        epicNumber: 'RT123456',
        voterName: 'RT Voter',
        state: 'Karnataka',
      );

      final reconstructed = UserProfile.fromMap(original.toMap());

      expect(reconstructed.uid, equals(original.uid));
      expect(reconstructed.displayName, equals(original.displayName));
      expect(reconstructed.email, equals(original.email));
      expect(reconstructed.epicNumber, equals(original.epicNumber));
      expect(reconstructed.voterName, equals(original.voterName));
      expect(reconstructed.state, equals(original.state));
    });

    test('toMap includes updatedAt as ISO8601 string', () {
      final profile = UserProfile(uid: 'timestamp-test');
      final map = profile.toMap();
      final updatedAt = map['updatedAt'] as String;

      // Should be parseable as a DateTime
      expect(() => DateTime.parse(updatedAt), returnsNormally);
    });
  });

  group('UserProfile — Edge Cases', () {
    test('Handles Unicode characters in names', () {
      final profile = UserProfile(
        uid: 'unicode',
        voterName: 'राजेश कुमार',
        state: 'महाराष्ट्र',
      );
      expect(profile.voterName, equals('राजेश कुमार'));
      expect(profile.state, equals('महाराष्ट्र'));
    });

    test('Handles very long strings', () {
      final longName = 'A' * 1000;
      final profile = UserProfile(uid: 'long', displayName: longName);
      expect(profile.displayName!.length, equals(1000));
    });
  });
}
