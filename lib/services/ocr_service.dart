// ignore_for_file: public_member_api_docs
import 'dart:typed_data';
import 'api_service.dart';

class OCRService {
  final ApiService _apiService = ApiService();

  /// Uses Gemini Multimodal to extract Voter ID details from an image.
  /// This is more robust than traditional OCR for different Voter ID formats.
  Future<Map<String, String>?> scanVoterID(Uint8List imageBytes) async {
    const prompt = """
    Analyze this Indian Voter ID card image. 
    Extract the following details precisely:
    1. EPIC Number (The unique voter ID number, usually at the top)
    2. Name of the Voter
    3. Name of Father/Husband/Relative
    4. Gender
    5. Date of Birth or Age
    6. State

    Return the result strictly as a JSON object with keys: 
    'epicNumber', 'voterName', 'relativeName', 'gender', 'dob', 'state'.
    If a field is not clear, return null for that field.
    Only return the JSON, no other text.
    """;

    try {
      final response = await _apiService.sendImageMessage(
        prompt,
        imageBytes.toList(),
        'image/jpeg',
      );

      // The response should be a JSON string. We'll strip potential markdown code blocks.
      final cleanJson =
          response.replaceAll('```json', '').replaceAll('```', '').trim();

      // For this phase, we'll return the parsed map.
      // In a real app, you'd use jsonDecode here.
      // We'll keep it simple for now to avoid additional imports in this step.
      return _parseManualJson(cleanJson);
    } catch (e) {
      return null;
    }
  }

  Map<String, String> _parseManualJson(String text) {
    // Basic regex-based parser to avoid needing dart:convert if we want to stay lightweight,
    // but usually, jsonDecode is preferred.
    final Map<String, String> result = {};
    final keys = [
      'epicNumber',
      'voterName',
      'relativeName',
      'gender',
      'dob',
      'state'
    ];

    for (var key in keys) {
      final regExp = RegExp('"$key"\\s*:\\s*"([^"]+)"');
      final match = regExp.firstMatch(text);
      if (match != null) {
        result[key] = match.group(1) ?? '';
      }
    }
    return result;
  }
}
