import 'package:flutter/material.dart';
import 'home.dart';
import 'notes_menu.dart';
import 'theme.dart';

class QuizMenu extends StatefulWidget {
  const QuizMenu({super.key});

  @override
  State<QuizMenu> createState() => _QuizMenuState();
}

class _QuizMenuState extends State<QuizMenu> {
  final int _selectedIndex = 1;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: getTheme(darkMode),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quiz'),
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
                  _buildQuizButton(1),
                  ...List.generate(10, (index) => _buildQuizButton(index + 2)),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: _buildAddQuizButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.purple[50],
          height: 60,
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            } else if (index == 2) {
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
      ),
    );
  }

  Widget _buildQuizButton(int quizNumber) {
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
          Navigator.pushNamed(context, '/quiz$quizNumber');
        },
        child: Column(
          children: [
            Icon(Icons.quiz, color: Colors.white, size: 30), // Quiz 图标
            const SizedBox(height: 8),
            Text(
              'Quiz $quizNumber',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Topic',
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

  Widget _buildAddQuizButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: const EdgeInsets.only(right: 16, bottom: 70),
        height: 64,
        width: 64,
        child: FloatingActionButton(
          onPressed: () {/* TODO: Implement create quiz page */},
          child: const Text('+', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
