import 'package:flutter/material.dart';
import 'home.dart';
import 'notes_menu.dart';

class QuizMenu extends StatefulWidget {
  const QuizMenu({super.key});

  @override
  State<QuizMenu> createState() => _QuizMenuState();
}

class _QuizMenuState extends State<QuizMenu> {
  final int _selectedIndex = 1; // Quiz tab selected by default

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: const Center(
        child: Text(
          'Quiz Page',
          style: TextStyle(fontSize: 20),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 60,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          if (index == 0) {
            // Home
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else if (index == 2) {
            // Notes
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const NotesMenu()),
            );
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.quiz), label: 'Quizzes'),
          NavigationDestination(icon: Icon(Icons.note), label: 'Notes'),
        ],
      ),
    );
  }
}
