/// Utility class for validating and extracting location codes.
class LocationUtils {
  /// Extracts a valid 5-digit US ZIP code from text, or returns empty string.
  static String extractZipCode(String text) {
    final t = text.trim();
    if (RegExp(r'^\d{5}$').hasMatch(t)) return t;
    final match = RegExp(r'^(\d{5})\s+\(.*?\)$').firstMatch(t);
    if (match != null) return match.group(1)!;
    return "";
  }

  /// Extracts a valid 6-digit Indian PIN code from text, or returns empty string.
  static String extractPinCode(String text) {
    final t = text.trim();
    if (RegExp(r'^\d{6}$').hasMatch(t)) return t;
    final match = RegExp(r'^(\d{6})\s+\(.*?\)$').firstMatch(t);
    if (match != null) return match.group(1)!;
    return "";
  }
}
