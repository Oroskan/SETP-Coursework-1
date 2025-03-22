import 'package:flutter/material.dart';
import 'home.dart';
import 'notes/notes_menu.dart';
import 'theme.dart';
import 'settings_menu.dart';

class QuizMenu extends StatefulWidget {
  const QuizMenu({super.key});

  @override
  State<QuizMenu> createState() => _QuizMenuState();
}

class _QuizMenuState extends State<QuizMenu> {
  final int _selectedIndex = 1;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> quizzes = [
    {'title': 'Chemical Bonding Quiz', 'subject': 'Chemistry'},
    {'title': 'Forces and Motion', 'subject': 'Physics'},
    {'title': 'DNA and RNA', 'subject': 'Biology'},
    {'title': 'Algorithm Analysis', 'subject': 'Computer Science'},
    {'title': 'Integration Methods', 'subject': 'Mathematics'},
    {'title': 'Literature Analysis', 'subject': 'English'},
    {'title': 'World War II', 'subject': 'History'},
    {'title': 'Tectonic Plates', 'subject': 'Geography'},
    {'title': 'Supply and Demand', 'subject': 'Economics'},
    {'title': 'Cognitive Development', 'subject': 'Psychology'},
    {'title': 'Cultural Studies', 'subject': 'Sociology'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get filteredQuizzes {
    if (_searchQuery.isEmpty) return quizzes;
    return quizzes.where((quiz) {
      final title = quiz['title']!.toLowerCase();
      final subject = quiz['subject']!.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return title.contains(query) || subject.contains(query);
    }).toList();
  }

  void _deleteQuiz(int index) {
    setState(() {
      quizzes.removeAt(index);
    });
  }

  Future<bool> _confirmDelete() async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Quiz'),
              content: const Text('Are you sure you want to delete this quiz?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: darkModeNotifier,
        builder: (context, isDarkMode, _) {
          final theme = getTheme(isDarkMode);

          return Theme(
            data: theme,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Quizzes'),
                leading: Builder(
                  builder: (context) => IconButton(
                    padding: EdgeInsets.zero,
                    icon: const CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/profilepic.jpg'),
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
              ),
              drawer: Drawer(
                child: ListView(
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                      ),
                      child: Text(
                        'Menu',
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Settings'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsMenu()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search quizzes...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: theme.cardTheme.color,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: filteredQuizzes.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/notfound.webp',
                                    height: 200,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'We searched far and wide, but no results were found.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: filteredQuizzes
                                    .map(
                                        (quiz) => _buildQuizButton(quiz, theme))
                                    .toList(),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: _buildAddQuizButton(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: NavigationBar(
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
                      MaterialPageRoute(
                          builder: (context) => const NotesMenu()),
                    );
                  }
                },
                destinations: const [
                  NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                  NavigationDestination(
                      icon: Icon(Icons.quiz), label: 'Quizzes'),
                  NavigationDestination(icon: Icon(Icons.note), label: 'Notes'),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildQuizButton(Map<String, String> quiz, ThemeData theme) {
    final index = quizzes.indexOf(quiz);
    return Dismissible(
      key: Key(quiz['title']!),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(),
      onDismissed: (_) => _deleteQuiz(index),
      background: Container(
        margin: const EdgeInsets.only(top: 16.0),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8.0),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 16.0),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            padding: const EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context,
                '/quiz/${quiz['subject']?.toLowerCase().replaceAll(' ', '_')}/${quiz['title']?.toLowerCase().replaceAll(' ', '_')}');
          },
          child: Column(
            children: [
              Icon(Icons.quiz, color: theme.colorScheme.onPrimary, size: 30),
              const SizedBox(height: 8),
              Text(
                quiz['title']!,
                style: TextStyle(
                  fontSize: 24,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                quiz['subject']!,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
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
