// ignore_for_file: public_member_api_docs
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../core/constants.dart';
import '../models/message.dart';

class ApiService {
  // Pipeline A: United States Logic (Google Civic Information API + Gemini Parser)
  Future<String> fetchUSCivicData(String zipCode, List<ChatMessage> history,
      {String languageInstruction = ''}) async {
    if (AppConstants.googleCloudApiKey.isEmpty ||
        AppConstants.geminiApiKey.isEmpty) {
      return "Error: API Keys are missing. Please configure them in constants.dart.";
    }

    final civicUrl = Uri.parse(
        'https://www.googleapis.com/civicinfo/v2/elections?key=${AppConstants.googleCloudApiKey}');

    try {
      final civicResponse = await http.get(civicUrl);
      String rawCivicData = "";

      if (civicResponse.statusCode == 200) {
        rawCivicData = civicResponse.body;
      } else {
        rawCivicData =
            "Failed to retrieve direct data (Status: ${civicResponse.statusCode}). Fallback to general knowledge.";
      }

      final geminiUrl = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${AppConstants.geminiApiKey}');

      final systemPrompt =
          """${languageInstruction}You are CivicGuide. You have been provided with JSON data from the Google Civic Information API for the user's ZIP code. You MUST base your answers on this JSON. CRITICAL: If the user asks for 'Polling locations', explain that a 5-digit ZIP code is too broad to find a specific polling building. Tell them they need to use their exact street address, and direct them to the official state election administration website provided in your JSON context data. Do not give generic advice like 'check vote.org'; use the specific state data provided.

Your task:
1. Parse this data to answer the user's question directly.
2. Maintain a friendly, non-partisan, 8th-grade reading level.
3. CRITICAL: Only append the [HAS_DATES] tag at the very end of your response IF AND ONLY IF you have provided a specific, actionable, upcoming date (e.g., 'May 5th, 2026'). Do NOT append this tag for generic advice or if no specific dates are found.
""";

      List<Map<String, dynamic>> mappedContents = [];
      var chronological = history.reversed.toList();

      for (int i = 0; i < chronological.length; i++) {
        var msg = chronological[i];
        String text = msg.text;

        if (i == chronological.length - 1 && msg.isUser) {
          text =
              "Raw Civic Information API Data:\n```json\n$rawCivicData\n```\n\nUser's Question: $text";
        }

        mappedContents.add({
          "role": msg.isUser ? "user" : "model",
          "parts": [
            {"text": text}
          ]
        });
      }

      final geminiResponse = await http.post(
        geminiUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "systemInstruction": {
            "parts": [
              {"text": systemPrompt}
            ]
          },
          "contents": mappedContents
        }),
      );

      if (geminiResponse.statusCode == 200) {
        final data = json.decode(geminiResponse.body);
        return data['candidates']?[0]?['content']?['parts']?[0]?['text'] ??
            "No response generated.";
      } else {
        // print("Gemini US Pipeline Error Body: ${geminiResponse.body}");
        return "Failed to parse data with Gemini. (Status: ${geminiResponse.statusCode})";
      }
    } catch (e) {
      return "An error occurred in the US Pipeline: $e";
    }
  }

  // Pipeline B: India Logic (Gemini API)
  Future<String> fetchIndiaCivicData(String pinCode, List<ChatMessage> history,
      {String languageInstruction = ''}) async {
    if (AppConstants.geminiApiKey.isEmpty) {
      return "Error: Gemini API Key is missing. Please configure it in constants.dart.";
    }

    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${AppConstants.geminiApiKey}');

    final systemPrompt =
        """${languageInstruction}You are CivicGuide, an expert on the Election Commission of India (ECI).
The user is in PIN Code $pinCode.

Your task:
1. Provide exact details on Form 6 (registration), Form 8 (shifting), and NVSP portal links relevant to their query.
2. Maintain a friendly, non-partisan, 8th-grade reading level. Do not provide any political opinions.
3. CRITICAL: Only append the [HAS_DATES] tag at the very end of your response IF AND ONLY IF you have provided a specific, actionable, upcoming date (e.g., 'May 5th, 2026'). Do NOT append this tag for generic advice or if no specific dates are found.
""";

    List<Map<String, dynamic>> mappedContents = [];
    var chronological = history.reversed.toList();

    for (var msg in chronological) {
      mappedContents.add({
        "role": msg.isUser ? "user" : "model",
        "parts": [
          {"text": msg.text}
        ]
      });
    }

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "systemInstruction": {
            "parts": [
              {"text": systemPrompt}
            ]
          },
          "contents": mappedContents
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['candidates']?[0]?['content']?['parts']?[0]?['text'] ??
            "No response generated.";
      } else {
        // print("Gemini India Pipeline Error Body: ${response.body}");
        return "Failed to retrieve India civic data from Gemini. (Status: ${response.statusCode})";
      }
    } catch (e) {
      return "An error occurred while communicating with Gemini: $e";
    }
  }

  // Pipeline C: Multimodal — Vision / Image Upload (Gemini inline image)
  Future<String> fetchMultimodalCivicData({
    required String locationCode,
    required bool isUS,
    required String prompt,
    required List<int> imageBytes,
    required String mimeType,
    String languageInstruction = '',
  }) async {
    if (AppConstants.geminiApiKey.isEmpty) {
      return "Error: Gemini API Key is missing.";
    }

    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${AppConstants.geminiApiKey}');

    final context = isUS
        ? 'US voter in ZIP code $locationCode'
        : 'Indian voter in PIN code $locationCode';

    final systemPrompt =
        """${languageInstruction}You are CivicGuide assisting a $context.
The user has uploaded an image — it may be official election mail, a sample ballot, a voter registration form, or a government document.

Your task:
1. Read and describe the key information visible in the image.
2. Answer the user's specific question about it if one is provided.
3. Maintain a friendly, non-partisan, 8th-grade reading level.
4. If sensitive personal data (like SSN, Aadhaar number) is visible, remind the user to protect it and do NOT repeat it back.
5. Only append [HAS_DATES] if a specific actionable date is mentioned.
""";

    final base64Image = base64Encode(imageBytes);

    final body = json.encode({
      "systemInstruction": {
        "parts": [
          {"text": systemPrompt}
        ]
      },
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": prompt},
            {
              "inline_data": {
                "mime_type": mimeType,
                "data": base64Image,
              }
            }
          ]
        }
      ]
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['candidates']?[0]?['content']?['parts']?[0]?['text'] ??
            "No response generated.";
      } else {
        return "Multimodal request failed. (Status: ${response.statusCode})";
      }
    } catch (e) {
      return "An error occurred during image analysis: $e";
    }
  }

  // Shared Utility: Save to Calendar
  Future<void> openCalendarEvent({
    required String title,
    required String details,
    required DateTime date,
  }) async {
    final dateStr =
        '${date.toIso8601String().replaceAll('-', '').replaceAll(':', '').split('.').first}Z';
    final nextDayStr =
        '${date.add(const Duration(days: 1)).toIso8601String().replaceAll('-', '').replaceAll(':', '').split('.').first}Z';

    final url = Uri.parse(
        'https://calendar.google.com/calendar/render?action=TEMPLATE&text=${Uri.encodeComponent(title)}&details=${Uri.encodeComponent(details)}&dates=$dateStr/$nextDayStr');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch calendar link';
    }
  }

  /// Simple image processing wrapper for OCR
  Future<String> sendImageMessage(
      String prompt, List<int> imageBytes, String mimeType) async {
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${AppConstants.geminiApiKey}');

    final base64Image = base64Encode(imageBytes);
    final body = json.encode({
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": prompt},
            {
              "inline_data": {
                "mime_type": mimeType,
                "data": base64Image,
              }
            }
          ]
        }
      ]
    });

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? "";
    }
    throw "API Error: ${response.statusCode}";
  }
}
