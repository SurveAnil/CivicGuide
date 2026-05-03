/// Global constants used throughout the CivicGuide application.
class AppConstants {
  /// The global title of the application.
  static const String appTitle = 'CivicGuide';
  
  /// The initial greeting message displayed in the chat.
  static const String initialGreeting =
      'Hello! I am your non-partisan CivicGuide. I can help you understand local election processes. To get started, where will you be voting?';

  /// Google Civic Information API Key.
  static const String googleCloudApiKey = 'YOUR_GOOGLE_CLOUD_API_KEY';
      
  /// Gemini AI API Key for chat and OCR capabilities.
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY';

  /// Google Client ID for Web (Required for Sign-In)
  static const String googleWebClientId = 'YOUR_GOOGLE_WEB_CLIENT_ID';
}
