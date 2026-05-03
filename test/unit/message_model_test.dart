import 'package:flutter_test/flutter_test.dart';
import 'package:civic_guide/models/message.dart';

void main() {
  group('ChatMessage Model', () {
    test('Creates user message with required fields', () {
      final msg = ChatMessage(text: 'Hello', isUser: true);
      expect(msg.text, equals('Hello'));
      expect(msg.isUser, isTrue);
      expect(msg.timestamp, isA<DateTime>());
    });

    test('Creates bot message with required fields', () {
      final msg = ChatMessage(text: 'Hi there', isUser: false);
      expect(msg.text, equals('Hi there'));
      expect(msg.isUser, isFalse);
    });

    test('ActionChips default to null', () {
      final msg = ChatMessage(text: 'Test', isUser: false);
      expect(msg.actionChips, isNull);
    });

    test('ActionChips are stored when provided', () {
      final msg = ChatMessage(
        text: 'Choose:',
        isUser: false,
        actionChips: ['Option A', 'Option B'],
      );
      expect(msg.actionChips, isNotNull);
      expect(msg.actionChips!.length, equals(2));
      expect(msg.actionChips![0], equals('Option A'));
    });

    test('replyToText defaults to null', () {
      final msg = ChatMessage(text: 'Test', isUser: true);
      expect(msg.replyToText, isNull);
    });

    test('replyToText is stored when provided', () {
      final msg = ChatMessage(
        text: 'My reply',
        isUser: true,
        replyToText: 'Original message text',
      );
      expect(msg.replyToText, equals('Original message text'));
    });

    test('Timestamp is auto-generated close to now', () {
      final before = DateTime.now();
      final msg = ChatMessage(text: 'Test', isUser: true);
      final after = DateTime.now();

      expect(msg.timestamp.isAfter(before) || msg.timestamp.isAtSameMomentAs(before), isTrue);
      expect(msg.timestamp.isBefore(after) || msg.timestamp.isAtSameMomentAs(after), isTrue);
    });

    test('Custom timestamp is preserved', () {
      final dt = DateTime(2026, 5, 1, 12, 0);
      final msg = ChatMessage(text: 'Test', isUser: true, timestamp: dt);
      expect(msg.timestamp, equals(dt));
    });

    test('Empty text message is allowed', () {
      final msg = ChatMessage(text: '', isUser: true);
      expect(msg.text, equals(''));
    });

    test('Message with special characters renders correctly', () {
      final msg = ChatMessage(text: '¿Estoy registrado? 🇺🇸', isUser: true);
      expect(msg.text, equals('¿Estoy registrado? 🇺🇸'));
    });

    test('Message with Hindi text is stored correctly', () {
      final msg = ChatMessage(text: 'नमस्ते! मतदान कैसे करें?', isUser: false);
      expect(msg.text, contains('नमस्ते'));
    });

    test('Message with Marathi text is stored correctly', () {
      final msg = ChatMessage(text: 'मतदार यादी शोधा', isUser: false);
      expect(msg.text, contains('मतदार'));
    });

    test('Empty actionChips list is stored as-is', () {
      final msg = ChatMessage(text: 'Test', isUser: false, actionChips: []);
      expect(msg.actionChips, isNotNull);
      expect(msg.actionChips!.isEmpty, isTrue);
    });
  });
}
