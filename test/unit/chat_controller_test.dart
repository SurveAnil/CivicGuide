import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:civic_guide/services/chat_controller.dart';
import 'package:civic_guide/providers/app_state.dart';
import 'package:civic_guide/models/country_mode.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    const channel = MethodChannel('flutter_tts');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return true;
    });
  });

  /// Helper to create an AppState configured for a given country
  AppState makeAppState({CountryMode country = CountryMode.us, String language = 'English'}) {
    final state = AppState();
    state.setCountry(country);
    state.setLanguage(language);
    return state;
  }

  group('ChatController — Initialization', () {
    late ChatController controller;
    late AppState appState;

    setUp(() {
      appState = makeAppState(country: CountryMode.us);
      controller = ChatController(appState);
    });

    tearDown(() {
      controller.dispose();
    });

    test('Initial state is locationInput', () {
      expect(controller.currentState.value, equals(ChatState.locationInput));
    });

    test('Initial messages contains location prompt', () {
      expect(controller.messages.value.length, equals(1));
      expect(controller.messages.value.first.text, contains('Zip'));
    });

    test('Initial message has location action chips', () {
      final chips = controller.messages.value.first.actionChips;
      expect(chips, isNotNull);
      expect(chips!.length, equals(3));
      expect(chips[0], contains('10001'));
    });

    test('Default language is English', () {
      expect(controller.selectedLanguage, equals('English'));
    });

    test('isLoading starts as false', () {
      expect(controller.isLoading.value, isFalse);
    });
  });

  group('ChatController — State Sync', () {
    late ChatController controller;
    late AppState appState;

    setUp(() {
      appState = makeAppState(country: CountryMode.us);
      controller = ChatController(appState);
    });

    tearDown(() {
      controller.dispose();
    });

    test('Updating language via AppState reflects in controller', () async {
      appState.setLanguage('Hindi');
      await Future.delayed(const Duration(milliseconds: 100));
      expect(controller.selectedLanguage, equals('Hindi'));
    });

    test('Switching country resets to locationInput', () async {
      controller.sendMessage('10001'); // Move to ready
      await Future.delayed(const Duration(milliseconds: 700));
      expect(controller.currentState.value, equals(ChatState.ready));

      appState.setCountry(CountryMode.india); // Switch to India via AppState
      await Future.delayed(const Duration(milliseconds: 100));
      expect(controller.currentState.value, equals(ChatState.locationInput));
      expect(controller.messages.value.first.text, contains('PIN'));
    });
  });

  group('ChatController — Location Flow', () {
    late ChatController controller;
    late AppState appState;

    setUp(() {
      appState = makeAppState(country: CountryMode.us);
      controller = ChatController(appState);
    });

    tearDown(() {
      controller.dispose();
    });

    test('Valid ZIP transitions to ready', () async {
      controller.sendMessage('10001');
      await Future.delayed(const Duration(milliseconds: 700));
      expect(controller.currentState.value, equals(ChatState.ready));
      expect(controller.savedLocationCode, equals('10001'));
    });

    test('Invalid ZIP stays in locationInput', () async {
      controller.sendMessage('123');
      await Future.delayed(const Duration(milliseconds: 700));
      expect(controller.currentState.value, equals(ChatState.locationInput));
    });
  });
}
