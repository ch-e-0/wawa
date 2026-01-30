import 'package:flutter/material.dart';
import 'chat_screen.dart'; // Assuming your chat screen is in the same folder

// A data model for our personas
class Persona {
  final String name;
  final IconData icon;
  final Color color;

  const Persona({
    required this.name,
    required this.icon,
    required this.color,
  });
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // List of available personas
  static const List<Persona> personas = [
    Persona(name: 'Math', icon: Icons.calculate, color: Colors.orange),
    Persona(name: 'English', icon: Icons.spellcheck, color: Colors.blue),
    Persona(name: 'Science', icon: Icons.science_outlined, color: Colors.green),
    Persona(name: 'Bible', icon: Icons.biotech, color: Colors.purple),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Persona'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        // Creates a grid with 2 columns
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.2, // Adjust the card's aspect ratio
        ),
        itemCount: personas.length,
        itemBuilder: (context, index) {
          final persona = personas[index];
          return PersonaCard(persona: persona);
        },
      ),
    );
  }
}

class PersonaCard extends StatelessWidget {
  final Persona persona;

  const PersonaCard({
    super.key,
    required this.persona,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      clipBehavior: Clip.antiAlias, // Ensures the ink splash is contained
      child: InkWell(
        onTap: () {
          // Navigate to the chat screen, passing the selected persona's name
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(personaName: persona.name),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(persona.icon, size: 50, color: persona.color),
            const SizedBox(height: 12),
            Text(
              persona.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
