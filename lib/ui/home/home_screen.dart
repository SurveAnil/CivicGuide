// ignore_for_file: public_member_api_docs
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../models/message.dart';
import '../../models/country_mode.dart';
import '../../providers/app_state.dart';
import '../../services/chat_controller.dart';
import '../chat_bubble.dart';

import 'widgets/context_bar.dart';
import 'widgets/quick_actions.dart';
import 'widgets/chat_input_bar.dart';

class HomeScreen extends StatefulWidget {
  final AppState appState;
  const HomeScreen({super.key, required this.appState});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ChatController _controller;
  final TextEditingController _textController = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controller = ChatController(widget.appState);
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.appState.language != widget.appState.language ||
        oldWidget.appState.country != widget.appState.country) {
      _controller.updateState(
        widget.appState.language,
        widget.appState.country == CountryMode.us,
      );
    }
  }

  bool _speechAvailable = false;
  bool _isListening = false;

  Uint8List? _attachedImageBytes;
  String? _attachedImageMimeType;
  String? _replyingToText;

  // ── Quick Action Definitions ────────────────────────────────
  List<QuickAction> get _quickActions {
    if (widget.appState.country == CountryMode.india) {
      return const [
        QuickAction(
            Icons.how_to_vote, 'Register to Vote', 'Form 6 Registration'),
        QuickAction(
            Icons.app_registration, 'Check Voter Info', 'Check NVSP status'),
        QuickAction(
            Icons.location_on, 'Find Polling Booth', 'Find Polling locations'),
        QuickAction(
            Icons.calendar_month, 'Election Timeline', 'Upcoming dates'),
      ];
    } else {
      return const [
        QuickAction(
            Icons.location_on, 'Find Polling Location', 'Polling locations'),
        QuickAction(Icons.gavel, 'Voting Rules', 'Voter ID rules'),
        QuickAction(
            Icons.app_registration, 'Registration Guide', 'Am I registered?'),
        QuickAction(
            Icons.calendar_month, 'Election Timeline', 'Upcoming dates'),
      ];
    }
  }

  void _toggleListening() async {
    if (!_speechAvailable) {
      _speechAvailable = await _speechToText.initialize(
        onError: (_) => setState(() => _isListening = false),
      );
      if (!_speechAvailable) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Voice input is not available.')),
        );
        return;
      }
    }
    if (_isListening) {
      await _speechToText.stop();
      setState(() => _isListening = false);
    } else {
      setState(() => _isListening = true);
      await _speechToText.listen(onResult: (result) {
        setState(() {
          _textController.text = result.recognizedWords;
          _textController.selection = TextSelection.fromPosition(
            TextPosition(offset: _textController.text.length),
          );
          if (result.finalResult) _isListening = false;
        });
      });
    }
  }

  Future<void> _pickImage() async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔒 Please blur sensitive ID numbers before uploading.'),
        duration: Duration(seconds: 4),
        backgroundColor: Color(0xFF3A2E00),
      ),
    );
    final XFile? picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      imageQuality: 85,
    );
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _attachedImageBytes = bytes;
        _attachedImageMimeType = picked.mimeType ?? 'image/jpeg';
      });
    }
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty && _attachedImageBytes == null) return;
    if (_isListening) {
      _speechToText.stop();
      setState(() => _isListening = false);
    }
    if (_attachedImageBytes != null) {
      _controller.sendMessageWithImage(
        text.trim(),
        _attachedImageBytes!.toList(),
        _attachedImageMimeType ?? 'image/jpeg',
      );
      setState(() {
        _attachedImageBytes = null;
        _attachedImageMimeType = null;
      });
    } else {
      _controller.sendMessage(text.trim(), replyToText: _replyingToText);
    }
    setState(() => _replyingToText = null);
    _textController.clear();
  }

  void _onQuickAction(QuickAction action) {
    _controller.sendMessage(action.chipText);
  }

  @override
  void dispose() {
    _textController.dispose();
    _speechToText.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Column(
        children: [
          // ── Context Bar ─────────────────────────────────────────
          ContextBar(appState: widget.appState),

          // ── Quick Actions ───────────────────────────────────────
          QuickActionsBar(
            actions: _quickActions,
            onActionTapped: _onQuickAction,
          ),

          const Divider(height: 1, color: Colors.white12),

          // ── Chat Messages ───────────────────────────────────────
          Expanded(
            child: ValueListenableBuilder<List<ChatMessage>>(
              valueListenable: _controller.messages,
              builder: (context, messages, _) {
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ValueListenableBuilder<ChatMessage?>(
                      valueListenable: _controller.currentlySpeakingMessage,
                      builder: (context, speakingMsg, _) {
                        return ChatBubble(
                          message: message,
                          language: _controller.selectedLanguage,
                          isSpeaking: speakingMsg == message,
                          onSpeakTapped: () => _controller.toggleSpeak(message),
                          onChipTapped: (index == 0 && !message.isUser)
                              ? (chipText) =>
                                  _controller.handleActionChip(chipText)
                              : null,
                          onReplyTapped: () =>
                              setState(() => _replyingToText = message.text),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),

          // ── Smart Loading ───────────────────────────────────────
          ValueListenableBuilder<bool>(
            valueListenable: _controller.isLoading,
            builder: (context, isLoading, _) {
              if (!isLoading) return const SizedBox.shrink();
              return Semantics(
                liveRegion: true,
                label: 'CivicGuide is analyzing your question',
                child: ValueListenableBuilder<String>(
                  valueListenable: _controller.loadingMessage,
                  builder: (context, msg, _) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: theme.colorScheme.primary)),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              msg.isNotEmpty ? msg : 'Analyzing…',
                              style: theme.textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),

          // ── Reply Preview ───────────────────────────────────────
          if (_replyingToText != null)
            Container(
              margin: const EdgeInsets.fromLTRB(12, 4, 12, 0),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8)),
                border:
                    Border.all(color: theme.colorScheme.primary.withAlpha(77)),
              ),
              child: Row(
                children: [
                  Icon(Icons.reply, size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(_replyingToText!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Colors.white54)),
                  ),
                  Semantics(
                    button: true,
                    label: 'Cancel reply',
                    child: GestureDetector(
                      onTap: () => setState(() => _replyingToText = null),
                      child: Icon(Icons.close,
                          size: 18, color: theme.colorScheme.onSurface),
                    ),
                  ),
                ],
              ),
            ),

          // ── Input Bar ───────────────────────────────────────────
          ChatInputBar(
            textController: _textController,
            isListening: _isListening,
            hasAttachedImage: _attachedImageBytes != null,
            onPickImage: _pickImage,
            onToggleListening: _toggleListening,
            onSubmitted: _handleSubmitted,
          ),
        ],
      ),
    );
  }
}
