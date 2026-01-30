import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

class GeminiService {
  static const String apiKey = 'AIzaSyACzStMaIBfQVnTQ2yBmP_V7QR7VF5jbhU'; // ← Replace with your actual API key!

  // FIX: The URL string has been combined into a single line.
  static const String apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent';

  // 🔥 CONVERT MESSAGES TO GEMINI FORMAT
  static List<Map<String, dynamic>> _formatMessages(
      List<ChatMessage> messages,
      ) {
    return messages.map((msg) {
      return {
        'role': msg.role, // "user" or "model"
        'parts': [{'text': msg.text}],
      };
    }).toList();
  }

  // 🔥 MULTI-TURN API CALL (WITH HISTORY)
  static Future<String> sendMultiTurnMessage(
      List<ChatMessage> conversationHistory,
      String newUserMessage,
      ) async {
    // Note: The newUserMessage should be added to the conversation history
    // before sending it to the API if you want it to be part of the context.
    // For this example, we assume the calling function has already added it.

    try {
      final formattedMessages = _formatMessages(conversationHistory);
      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': formattedMessages, // 🔥 Entire history!
          'generationConfig': {
            'temperature': 0.7,
            'topK': 1,
            'topP': 1,
            'maxOutputTokens': 2048,
          }
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Add robust checking to prevent runtime errors if the response format is unexpected
        if (data.containsKey('candidates') &&
            data['candidates'] is List &&
            data['candidates'].isNotEmpty &&
            data['candidates'][0].containsKey('content') &&
            data['candidates'][0]['content'].containsKey('parts') &&
            data['candidates'][0]['content']['parts'] is List &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          return data['candidates'][0]['content']['parts'][0]['text'];
        } else {
          return 'Error: Invalid response format from API.';
        }
      } else {
        // Provide more details from the response body if available
        return 'Error: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return 'Network Error: $e';
    }
  }
}
