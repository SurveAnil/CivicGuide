/// Represents a single message in the chat interface.
class ChatMessage {
  /// The textual content of the message.
  final String text;
  /// True if the message was sent by the user, false if from the AI.
  final bool isUser;
  /// The time the message was created.
  final DateTime timestamp;
  /// Optional quick action chips displayed below the AI message.
  final List<String>? actionChips;
  /// Optional preview text of the message this message is replying to.
  final String? replyToText;
  /// True if the message represents an error state.
  final bool isError;

  /// Creates a [ChatMessage] with the required fields.
  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
    this.actionChips,
    this.replyToText,
    this.isError = false,
  }) : timestamp = timestamp ?? DateTime.now();
}
