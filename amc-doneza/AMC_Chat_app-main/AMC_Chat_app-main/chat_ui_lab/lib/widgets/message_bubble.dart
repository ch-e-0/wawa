import 'package:flutter/material.dart';
import '/models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUserMessage
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUserMessage
              ? Colors.blue[300] // User: Brighter blue
              : Colors.green[100], // AI: Green (Gemini!)
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(message.text, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}