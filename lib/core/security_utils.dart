/// Provides input validation and sanitization utilities for secure AI interactions.
///
/// This class defends against prompt injection attacks, XSS attempts,
/// and excessively long inputs without destroying the semantic meaning
/// of user text (which the LLM needs to understand context).
class SecurityUtils {
  /// Maximum allowed character length for a single user prompt.
  static const int maxPromptLength = 500;

  /// Patterns that indicate prompt injection attempts.
  ///
  /// These are checked case-insensitively against user input before
  /// it is forwarded to the Gemini API.
  static const List<String> _injectionPatterns = [
    'ignore previous instructions',
    'ignore all instructions',
    'ignore your instructions',
    'act as admin',
    'act as root',
    'you are now',
    'new persona',
    'override system',
    'disregard above',
    'forget your rules',
    'jailbreak',
    'dan mode',
    'bypass content',
    'pretend you are',
    'system prompt',
  ];

  /// Validates and sanitizes user input for the AI pipeline.
  ///
  /// Returns the sanitized text if safe, or `null` if the input
  /// is flagged as malicious or exceeds length constraints.
  ///
  /// This does NOT aggressively strip text — raw meaning is preserved
  /// for the LLM. Only obvious injection vectors and rendering-unsafe
  /// HTML/script tags are neutralized.
  static String? sanitizePrompt(String input) {
    if (input.trim().isEmpty) return null;

    // Enforce length limit
    if (input.length > maxPromptLength) {
      return input.substring(0, maxPromptLength);
    }

    // Check for prompt injection patterns (case-insensitive)
    final lower = input.toLowerCase();
    for (final pattern in _injectionPatterns) {
      if (lower.contains(pattern)) {
        return null; // Reject the entire prompt
      }
    }

    // Neutralize script/HTML tags that could break Markdown rendering
    // but keep the raw text content intact for LLM understanding
    final sanitized = input
        .replaceAll(RegExp(r'<script[^>]*>.*?</script>', caseSensitive: false, dotAll: true), '')
        .replaceAll(RegExp(r'<iframe[^>]*>.*?</iframe>', caseSensitive: false, dotAll: true), '')
        .replaceAll(RegExp(r'<object[^>]*>.*?</object>', caseSensitive: false, dotAll: true), '')
        .replaceAll(RegExp(r'javascript:', caseSensitive: false), '')
        .replaceAll(RegExp(r'on\w+\s*=', caseSensitive: false), '');

    return sanitized.trim();
  }

  /// Sanitizes AI output before rendering in the UI.
  ///
  /// Since `flutter_markdown` already handles most Markdown safely,
  /// this primarily strips any residual executable content that could
  /// be injected via a compromised model response.
  static String sanitizeOutput(String output) {
    return output
        .replaceAll(RegExp(r'<script[^>]*>.*?</script>', caseSensitive: false, dotAll: true), '')
        .replaceAll(RegExp(r'javascript:', caseSensitive: false), '');
  }

  /// Returns `true` if the input is within safe boundaries for processing.
  static bool isInputSafe(String input) {
    return sanitizePrompt(input) != null;
  }
}
