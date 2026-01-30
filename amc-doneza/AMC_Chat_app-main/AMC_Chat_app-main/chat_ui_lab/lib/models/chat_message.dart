class ChatMessage {
  final String text;
  final String role; // "user" or "model" (Gemini format)
  final DateTime timestamp;
  ChatMessage({
    required this.text,
    required this.role,
    required this.timestamp,
  });
// Helper: Is this a user message?
  bool get isUserMessage => role == "user";
}