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

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: getTheme(darkMode),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quizzes'),
          backgroundColor: Colors.purple[300],
          leading: Builder(
            builder: (context) => IconButton(
              padding: EdgeInsets.zero,
              icon: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/profilepic.jpg'),
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
                  color: Colors.purple[300],
                ),
                child: const Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  // TODO: Implement settings navigation
                },
              ),
              // Add more drawer items here
            ],
          ),
        ),
        body: Container(
          color: Colors.purple[50],
          child: Column(
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
                    fillColor: Colors.white,
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
                              const Text(
                                'We searched far and wide, but no results were found.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: filteredQuizzes
                                .map((quiz) => _buildQuizButton(quiz))
                                .toList(),
                          ),
                  ),
                ),
              ),
            ],
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

  Widget _buildQuizButton(Map<String, String> quiz) {
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
          Navigator.pushNamed(context,
              '/quiz/${quiz['subject']?.toLowerCase().replaceAll(' ', '_')}/${quiz['title']?.toLowerCase().replaceAll(' ', '_')}');
        },
        child: Column(
          children: [
            const Icon(Icons.quiz, color: Colors.white, size: 30),
            const SizedBox(height: 8),
            Text(
              quiz['title']!,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              quiz['subject']!,
              style: const TextStyle(
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
