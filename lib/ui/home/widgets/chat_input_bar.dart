// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController textController;
  final bool isListening;
  final bool hasAttachedImage;
  final VoidCallback onPickImage;
  final VoidCallback onToggleListening;
  final Function(String) onSubmitted;

  const ChatInputBar({
    super.key,
    required this.textController,
    required this.isListening,
    required this.hasAttachedImage,
    required this.onPickImage,
    required this.onToggleListening,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Semantics(
            button: true,
            label: 'Attach image',
            child: IconButton(
              icon: Icon(Icons.attach_file,
                  color: hasAttachedImage
                      ? theme.colorScheme.secondary
                      : theme.colorScheme.primary),
              onPressed: onPickImage,
              tooltip: 'Attach image',
            ),
          ),
          Flexible(
            child: Semantics(
              textField: true,
              label: 'Type your question to CivicGuide',
              hint: isListening
                  ? 'Listening for voice input'
                  : 'Type your question here',
              child: TextField(
                controller: textController,
                onSubmitted: onSubmitted,
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  hintText: isListening ? '🎙️ Listening…' : 'Ask CivicGuide…',
                ),
              ),
            ),
          ),
          Semantics(
            button: true,
            label: isListening ? 'Stop voice input' : 'Tap to start speaking',
            child: IconButton(
              icon: Icon(isListening ? Icons.mic : Icons.mic_none,
                  color: isListening
                      ? Colors.redAccent
                      : theme.colorScheme.primary),
              onPressed: onToggleListening,
              tooltip: isListening ? 'Stop listening' : 'Start voice input',
            ),
          ),
          Semantics(
            button: true,
            label: 'Send message',
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => onSubmitted(textController.text),
              tooltip: 'Send message',
            ),
          ),
        ],
      ),
    );
  }
}
