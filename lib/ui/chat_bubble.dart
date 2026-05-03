// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/message.dart';

class ChatBubble extends StatefulWidget {
  final ChatMessage message;
  final String language;
  final bool isSpeaking;
  final VoidCallback? onSpeakTapped;
  final Function(String)? onChipTapped;
  final VoidCallback? onReplyTapped;

  const ChatBubble({
    super.key,
    required this.message,
    required this.language,
    this.isSpeaking = false,
    this.onSpeakTapped,
    this.onChipTapped,
    this.onReplyTapped,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  bool _isHovering = false;

  void _copyText() {
    Clipboard.setData(ClipboardData(text: widget.message.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Copied to clipboard'), duration: Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUser = widget.message.isUser;
    final theme = Theme.of(context);

    return Semantics(
      liveRegion: !isUser, // AI responses announced as live region
      label: isUser
          ? 'You said: ${widget.message.text}'
          : 'CivicGuide says: ${widget.message.text}',
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment:
                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              // Quoted replied-to message block
              if (widget.message.replyToText != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                    border: Border(
                        left: BorderSide(
                            color: theme.colorScheme.primary, width: 4)),
                  ),
                  child: Text(
                    widget.message.replyToText!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),

              // Main Bubble and Reply Icon
              Row(
                mainAxisAlignment:
                    isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Reply button on left for user messages
                  if (isUser && _isHovering && widget.onReplyTapped != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                      child: Semantics(
                        button: true,
                        label: 'Reply to this message',
                        child: IconButton(
                          icon: Icon(Icons.reply,
                              size: 20,
                              color: theme.colorScheme.onSurfaceVariant),
                          onPressed: widget.onReplyTapped,
                          tooltip: 'Reply',
                        ),
                      ),
                    ),

                  // Main text container
                  Flexible(
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width > 800
                              ? 600
                              : MediaQuery.of(context).size.width * 0.75),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isUser
                            ? theme.colorScheme.primary
                            : (widget.message.isError
                                ? theme.colorScheme.error.withAlpha(20)
                                : theme.colorScheme.surface),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft:
                              isUser ? const Radius.circular(16) : Radius.zero,
                          bottomRight:
                              isUser ? Radius.zero : const Radius.circular(16),
                        ),
                        border: widget.message.isError
                            ? Border.all(color: theme.colorScheme.error.withAlpha(50))
                            : Border.all(color: Colors.white10),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: MarkdownBody(
                        data: widget.message.text,
                        styleSheet: MarkdownStyleSheet(
                          p: theme.textTheme.bodyLarge?.copyWith(
                            color: isUser
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface,
                          ),
                          a: TextStyle(
                            color: theme.colorScheme.secondary,
                            decoration: TextDecoration.underline,
                          ),
                          h1: theme.textTheme.headlineMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          h2: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          h3: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          listBullet: theme.textTheme.bodyLarge?.copyWith(
                            color: isUser
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                        onTapLink: (text, href, title) async {
                          if (href != null) {
                            final url = Uri.parse(href);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            }
                          }
                        },
                      ),
                    ),
                  ),

                  // Reply button on right for AI messages
                  if (!isUser && _isHovering && widget.onReplyTapped != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                      child: Semantics(
                        button: true,
                        label: 'Reply to this message',
                        child: IconButton(
                          icon: Icon(Icons.reply,
                              size: 20,
                              color: theme.colorScheme.onSurfaceVariant),
                          onPressed: widget.onReplyTapped,
                          tooltip: 'Reply',
                        ),
                      ),
                    ),
                ],
              ),

              // Copy and Speak buttons for AI response
              if (!isUser)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Semantics(
                        button: true,
                        label: 'Copy response text',
                        child: IconButton(
                          icon: const Icon(Icons.copy, size: 18),
                          onPressed: _copyText,
                          tooltip: 'Copy text',
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Semantics(
                        button: true,
                        label: widget.isSpeaking
                            ? 'Stop reading aloud'
                            : 'Read response aloud',
                        child: IconButton(
                          icon: Icon(
                              widget.isSpeaking ? Icons.stop : Icons.volume_up,
                              size: 18),
                          onPressed: widget.onSpeakTapped,
                          tooltip: widget.isSpeaking ? 'Stop' : 'Read aloud',
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

              // Action Chips
              if (widget.message.actionChips != null &&
                  widget.message.actionChips!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.message.actionChips!.map((chipText) {
                    return Semantics(
                      button: true,
                      label: 'Select: $chipText',
                      child: ActionChip(
                        label: Text(chipText),
                        backgroundColor: theme.colorScheme.surface,
                        labelStyle: TextStyle(
                            color: theme.colorScheme.secondary, fontSize: 13),
                        onPressed: widget.onChipTapped != null
                            ? () => widget.onChipTapped!(chipText)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
