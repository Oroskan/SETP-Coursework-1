import 'package:flutter/material.dart';
import 'home.dart';
import 'quiz_menu.dart';
import 'theme.dart';

class NotesMenu extends StatefulWidget {
  const NotesMenu({super.key});

  @override
  State<NotesMenu> createState() => _NotesMenuState();
}

class _NotesMenuState extends State<NotesMenu> {
  final int _selectedIndex = 2;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: getTheme(darkMode),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Note'),
          backgroundColor: Colors.purple[300],
        ),
        body: Container(
          color: Colors.purple[50],
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildNoteButton(1),
                  ...List.generate(10, (index) => _buildNoteButton(index + 2)),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: _buildAddNoteButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: NavigationBar(
          height: 60,
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            } else if (index == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const QuizMenu()),
              );
            }
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.quiz), label: 'Quizzes'),
            NavigationDestination(icon: Icon(Icons.note), label: 'Notes'),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteButton(int noteNumber) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/note$noteNumber');
        },
        child: Column(
          children: [
            Icon(Icons.note, color: Colors.white, size: 30), 
            const SizedBox(height: 8),
            Text(
              'Topic $noteNumber',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'description',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNoteButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: const EdgeInsets.only(right: 16, bottom: 70),
        height: 64,
        width: 64,
        child: FloatingActionButton(
          onPressed: () {/* TODO: Implement create note page */},
          child: const Text('+', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
