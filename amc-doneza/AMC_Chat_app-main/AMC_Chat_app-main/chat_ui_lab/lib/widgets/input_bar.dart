import 'package:flutter/material.dart';

// 1. Corrected: Changed StatelessWidget to StatefulWidget
class InputBar extends StatefulWidget {
  final Function(String) onSendMessage;

  const InputBar({Key? key, required this.onSendMessage}) : super(key: key);

  @override
  State<InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 2. Corrected: Added const for better performance
    return Padding(
      padding: const EdgeInsets.all(8.0), // It's good practice to use const
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: "Type a message",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24)),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (value) => _sendMessage(),
            ),
          ),
          SizedBox(width: 8),
          FloatingActionButton(
            onPressed: _sendMessage,
            mini:true,
            backgroundColor: Colors.blue,
            child: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}