/// Defines the supported country modes for CivicGuide.
enum CountryMode { 
  /// Represents the India country mode.
  india, 
  /// Represents the United States country mode.
  us 
}

/// Configuration settings for a specific country mode.
class CountryConfig {
  /// The underlying country mode enum.
  final CountryMode mode;
  /// The display name of the country.
  final String name;
  /// The emoji flag for the country.
  final String flag;
  /// The label used for the location code (e.g., ZIP Code or PIN Code).
  final String codeLabel;
  /// The expected length of the location code.
  final int codeLength;

  /// Creates a [CountryConfig] with the given properties.
  const CountryConfig({
    required this.mode,
    required this.name,
    required this.flag,
    required this.codeLabel,
    required this.codeLength,
  });

  /// Pre-configured settings for the India country mode.
  static const india = CountryConfig(
    mode: CountryMode.india,
    name: 'India',
    flag: '🇮🇳',
    codeLabel: 'PIN Code',
    codeLength: 6,
  );

  /// Pre-configured settings for the United States country mode.
  static const us = CountryConfig(
    mode: CountryMode.us,
    name: 'United States',
    flag: '🇺🇸',
    codeLabel: 'ZIP Code',
    codeLength: 5,
  );
}
