import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart'; // 1. Import Gemini
import 'screens/dashboard_screen.dart';

// 2. Paste your API key here
const String GEMINI_API_KEY = 'AIzaSyB6zzao2vJUdnA0PALlX997W3TYPDEArXo';

void main() {
  // 3. Initialize Gemini
  Gemini.init(apiKey: GEMINI_API_KEY);

  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Persona',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
