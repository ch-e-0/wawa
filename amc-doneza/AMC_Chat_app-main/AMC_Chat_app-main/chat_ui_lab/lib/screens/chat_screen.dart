import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_gemini/flutter_gemini.dart'; // 1. Import flutter_gemini

// Data model for a single chat message
class ChatMessage {
  final String text;
  final bool isUser; // True if the message is from the user, false if from the AI

  ChatMessage({required this.text, required this.isUser});
}

class ChatScreen extends StatefulWidget {
  final String personaName;
  const ChatScreen({super.key, required this.personaName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Controller to manage the text input field
  final TextEditingController _textController = TextEditingController();
  // List to hold all chat messages
  final List<ChatMessage> _messages = [];
  // Scroll controller to automatically scroll to the latest message
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false; // To show a loading indicator

  @override
  void initState() {
    super.initState();
    // Add a welcoming message from the persona when the screen loads
    _addInitialMessage();
  }

  void _addInitialMessage() {
    // This simulates the AI persona starting the conversation
    setState(() {
      _messages.add(
        ChatMessage(
          text:
          'Hello! I am the ${widget.personaName} chatbot. How can I help you today?',
          isUser: false,
        ),
      );
    });
  }

  // This function will handle sending the message
  void _handleSendPressed(String text) {
    if (text.trim().isEmpty) return; // Don't send empty messages

    _textController.clear(); // Clear the input field

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isLoading = true; // Show loading indicator
    });

    _scrollToBottom();

    // Now calls the real AI service
    _getAIResponse(text);
  }

  // 2. This is the updated function to call the real Gemini API
  Future<void> _getAIResponse(String userMessage) async {
    final gemini = Gemini.instance;

    // This prompt instructs the AI to adopt the selected persona.
    String personaPrompt =
        'You are a helpful and expert ${widget.personaName} chatbot. '
        'Provide a concise and relevant response to the user, staying within your area of expertise. '
        'User message: "$userMessage"';

    try {
      // Call the Gemini API to get a chat response
      final response = await gemini.chat(
        [
          Content(parts: [Parts(text: personaPrompt)], role: 'user'),
        ],
      );

      // Extract the AI's response text from the output.
      String? aiResponse = response?.output;

      if (aiResponse != null && aiResponse.isNotEmpty) {
        setState(() {
          _messages.add(ChatMessage(text: aiResponse, isUser: false));
        });
      } else {
        // Handle cases where the API returns an empty response
        _addErrorResponse();
      }
    } catch (e) {
      // Handle potential errors like network issues or API failures
      print('Error fetching AI response: $e');
      _addErrorResponse();
    } finally {
      // Ensure the loading indicator is always hidden after the call
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  // 3. (Recommended) A helper method to show an error message in the chat
  void _addErrorResponse() {
    setState(() {
      _messages.add(ChatMessage(
        text: 'Sorry, something went wrong. Please try again later.',
        isUser: false,
      ));
    });
  }

  // A helper to scroll the list to the bottom
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // --- No changes needed for the build methods below this line ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.personaName} Chatbot'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(strokeWidth: 3),
                  SizedBox(width: 12),
                  Text('AI is typing...'),
                ],
              ),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    final align = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color =
    isUser ? Theme.of(context).colorScheme.primary : Colors.grey.shade300;
    final textColor = isUser ? Colors.white : Colors.black87;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: align,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(message.text, style: TextStyle(color: textColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1),
            blurRadius: 3,
            color: Colors.grey.withOpacity(0.1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration.collapsed(
                hintText: 'Type your message...',
              ),
              onSubmitted: _isLoading ? null : _handleSendPressed,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _isLoading
                ? null
                : () => _handleSendPressed(_textController.text),
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
