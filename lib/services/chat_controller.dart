// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/message.dart';
import '../models/country_mode.dart';
import '../core/location_utils.dart';
import '../core/translations.dart';
import '../providers/app_state.dart';
import 'api_service.dart';
import '../core/error_logger.dart';

enum ChatState { locationInput, ready }

class ChatController {
  final ValueNotifier<List<ChatMessage>> messages = ValueNotifier([]);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<String> loadingMessage = ValueNotifier('');
  final ApiService _apiService = ApiService();
  final FlutterTts _flutterTts = FlutterTts();
  final ValueNotifier<ChatMessage?> currentlySpeakingMessage =
      ValueNotifier(null);
  final ValueNotifier<ChatState> currentState =
      ValueNotifier(ChatState.locationInput);

  /// Reference to AppState so we can sync location code to the context bar
  final AppState appState;

  ChatState _currentState = ChatState.locationInput;
  String _savedLocationCode = '';

  String get savedLocationCode => _savedLocationCode;
  bool get isUS => appState.country == CountryMode.us;

  // Multilingual Engine
  String get _selectedLanguage => appState.language;
  String get selectedLanguage => _selectedLanguage;

  // Returns the language instruction to prepend to every Gemini system prompt
  String get languageInstruction {
    if (_selectedLanguage == 'English') return '';
    return 'CRITICAL: Reply to all prompts strictly in $_selectedLanguage. Do NOT use English except for proper nouns or technical terms that have no equivalent.\n\n';
  }

  // ── Smart loading messages ──────────────────────────────────
  static const _loadingMessages = [
    'Looking up your district info…',
    'Checking election data…',
    'Analyzing your question…',
    'Consulting official sources…',
    'Preparing a clear response…',
  ];
  int _loadingMsgIndex = 0;

  ChatController(this.appState) {
    // If AppState already has a location code saved, skip to ready
    if (appState.locationCode.isNotEmpty) {
      _savedLocationCode = appState.locationCode;
      _currentState = ChatState.ready;
      currentState.value = _currentState;
      _initializeChatReady();
    } else {
      _currentState = ChatState.locationInput;
      currentState.value = _currentState;
      _initializeChatLocation();
    }

    // Listen for country/language changes from the AppBar selectors
    appState.addListener(_onAppStateChanged);
  }

  void _onAppStateChanged() {
    // If country changed, reset to location input (different region)
    if (appState.locationCode.isEmpty && _currentState == ChatState.ready) {
      _savedLocationCode = '';
      _currentState = ChatState.locationInput;
      currentState.value = _currentState;
      _initializeChatLocation();
    } else if (appState.locationCode.isNotEmpty &&
        _currentState == ChatState.locationInput) {
      _savedLocationCode = appState.locationCode;
      _currentState = ChatState.ready;
      currentState.value = _currentState;
      _initializeChatReady();
    }
  }

  /// Legacy bridge — called from HomeScreen.didUpdateWidget
  void updateState(String language, bool newIsUS) {
    // Country change resets location
    if (newIsUS != isUS) {
      _savedLocationCode = '';
      _currentState = ChatState.locationInput;
      currentState.value = _currentState;
      _initializeChatLocation();
    }
  }

  // ── Initialization ──────────────────────────────────────────
  void _initializeChatLocation() {
    final greeting = isUS ? Translations.t('us_zip_prompt', selectedLanguage) : Translations.t('in_pin_prompt', selectedLanguage);
    final chips = isUS
        ? ["10001 (NY)", "90210 (CA)", "60601 (IL)"]
        : ["110001 (Delhi)", "411057 (Pune)", "400001 (Mumbai)"];

    messages.value = [
      ChatMessage(text: greeting, isUser: false, actionChips: chips),
    ];
  }

  void _initializeChatReady() {
    final successMsg = isUS ? Translations.t('us_zip_success', selectedLanguage) : Translations.t('in_pin_success', selectedLanguage);
    final chips = isUS ? Translations.tList('us_chips', selectedLanguage) : Translations.tList('in_chips', selectedLanguage);

    messages.value = [
      ChatMessage(text: successMsg, isUser: false, actionChips: chips),
    ];
  }

  // ── Send Message ────────────────────────────────────────────
  void sendMessage(String text, {String? replyToText}) async {
    if (text.trim().isEmpty) return;

    // Add user message to UI
    final newMessages = List<ChatMessage>.from(messages.value);
    newMessages.insert(
        0, ChatMessage(text: text, isUser: true, replyToText: replyToText));
    messages.value = newMessages;

    isLoading.value = true;
    _cycleLoadingMessage();

    String responseText = '';
    List<String>? nextChips;

    switch (_currentState) {
      case ChatState.locationInput:
        await Future.delayed(const Duration(milliseconds: 500));
        final code = isUS
            ? LocationUtils.extractZipCode(text)
            : LocationUtils.extractPinCode(text);

        if (code.isNotEmpty) {
          _savedLocationCode = code;
          _currentState = ChatState.ready;
          currentState.value = _currentState;

          // Sync location code to AppState so context bar updates
          appState.setLocationCode(code);

          responseText = isUS ? Translations.t('us_zip_success', selectedLanguage) : Translations.t('in_pin_success', selectedLanguage);
          nextChips = isUS ? Translations.tList('us_chips', selectedLanguage) : Translations.tList('in_chips', selectedLanguage);
        } else {
          responseText = isUS ? Translations.t('us_zip_invalid', selectedLanguage) : Translations.t('in_pin_invalid', selectedLanguage);
          nextChips = isUS
              ? ["10001 (NY)", "90210 (CA)", "60601 (IL)"]
              : ["110001 (Delhi)", "411057 (Pune)", "400001 (Mumbai)"];
        }
        break;

      case ChatState.ready:
        final filterKeywords = [
          "Please enter a valid",
          "Sorry,",
          "Please select a valid",
          "कृपया एक वैध",
          "क्षमा करें",
          "कृपया ऊपर दिए गए",
          "कृपया वैध",
          "क्षमस्व",
          "कृपया वरील पर्यायांमधून",
          "Ingrese un código",
          "Lo sentimos",
          "Seleccione una opción"
        ];
        final history = messages.value
            .where((m) =>
                !filterKeywords.any((keyword) => m.text.contains(keyword)))
            .toList();

        if (isUS) {
          responseText = await _apiService.fetchUSCivicData(
              _savedLocationCode, history,
              languageInstruction: languageInstruction);
        } else {
          responseText = await _apiService.fetchIndiaCivicData(
              _savedLocationCode, history,
              languageInstruction: languageInstruction);
        }
        break;
    }

    _processAndAddBotMessage(responseText, nextChips);
    isLoading.value = false;
    loadingMessage.value = '';
  }

  /// Sends a message with an attached image (multimodal)
  void sendMessageWithImage(
      String text, List<int> imageBytes, String mimeType) async {
    final displayText =
        text.trim().isNotEmpty ? text : "Please analyze this image.";

    final newMessages = List<ChatMessage>.from(messages.value);
    newMessages.insert(0, ChatMessage(text: "📎 $displayText", isUser: true));
    messages.value = newMessages;

    isLoading.value = true;
    _cycleLoadingMessage();

    String responseText = '';
    if (_currentState == ChatState.ready) {
      responseText = await _apiService.fetchMultimodalCivicData(
        locationCode: _savedLocationCode,
        isUS: isUS,
        prompt: displayText,
        imageBytes: imageBytes,
        mimeType: mimeType,
        languageInstruction: languageInstruction,
      );
    } else {
      responseText =
          "Please finish setting up your location first before uploading an image.";
    }

    _processAndAddBotMessage(responseText, null);
    isLoading.value = false;
    loadingMessage.value = '';
  }

  void _cycleLoadingMessage() {
    loadingMessage.value =
        _loadingMessages[_loadingMsgIndex % _loadingMessages.length];
    _loadingMsgIndex++;
  }

  void _processAndAddBotMessage(String text, List<String>? defaultChips) {
    List<String> actionChips = defaultChips ?? [];
    String finalText = text;
    bool isError = false;

    // Detect failure from API Service
    if (finalText.startsWith('Failed to') || 
        finalText.startsWith('An error occurred') || 
        finalText.startsWith('Error:')) {
      isError = true;
      actionChips = ['Retry', 'Open Checklist', 'Contact Helpline'];
      ErrorLogger.logError(finalText, null);
    }

    if (finalText.contains('[HAS_DATES]')) {
      finalText = finalText.replaceAll('[HAS_DATES]', '').trim();
      actionChips = List.from(actionChips)..add('📅 Add to Calendar');
    }

    final updatedMessages = List<ChatMessage>.from(messages.value);
    updatedMessages.insert(
        0,
        ChatMessage(
            text: finalText,
            isUser: false,
            isError: isError,
            actionChips: actionChips.isEmpty ? null : actionChips));
    messages.value = updatedMessages;
  }

  void handleActionChip(String chipText) {
    if (chipText == '📅 Add to Calendar') {
      _apiService.openCalendarEvent(
        title: 'Upcoming Election Deadline',
        details:
            'Saved via CivicGuide. Please verify exact requirements online.',
        date: DateTime.now().add(const Duration(days: 7)),
      );
    } else if (chipText == 'Retry') {
      // Find the last user message to retry
      final lastUserMsg = messages.value.firstWhere((m) => m.isUser,
          orElse: () => ChatMessage(text: '', isUser: true));
      if (lastUserMsg.text.isNotEmpty) {
        sendMessage(lastUserMsg.text);
      }
    } else if (chipText == 'Open Checklist' || chipText == 'Journey') {
      appState.setTabIndex(1);
    } else if (chipText == 'Contact Helpline' || chipText == 'Helpline') {
      appState.setTabIndex(3);
    } else {
      sendMessage(chipText);
    }
  }

  void dispose() {
    appState.removeListener(_onAppStateChanged);
    _flutterTts.stop();
    messages.dispose();
    isLoading.dispose();
    loadingMessage.dispose();
    currentlySpeakingMessage.dispose();
    currentState.dispose();
  }

  Future<void> toggleSpeak(ChatMessage message) async {
    if (currentlySpeakingMessage.value == message) {
      await _flutterTts.stop();
      currentlySpeakingMessage.value = null;
    } else {
      // Stop previous
      await _flutterTts.stop();
      currentlySpeakingMessage.value = message;

      String langCode = 'en-US';
      switch (_selectedLanguage) {
        case 'Hindi':
          langCode = 'hi-IN';
          break;
        case 'Marathi':
          langCode = 'mr-IN';
          break;
        case 'Spanish':
          langCode = 'es-ES';
          break;
      }

      await _flutterTts.setLanguage(langCode);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(
          0.5); // Slightly slower for better clarity in non-English

      _flutterTts.setCompletionHandler(() {
        currentlySpeakingMessage.value = null;
      });
      _flutterTts.setErrorHandler((msg) {
        currentlySpeakingMessage.value = null;
      });

      await _flutterTts.speak(message.text);
    }
  }
}
