import 'package:flutter/material.dart';
import 'settings_menu.dart';
import 'quiz/quiz_menu.dart';
import 'notes/notes_menu.dart';
import 'quiz/question_page.dart';
import 'quiz/quiz.dart';
import 'theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final String username = 'a';

  // Add variables for stats
  int streakDays = 7;
  int completedQuizzes = 12;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: darkModeNotifier,
      builder: (context, isDarkMode, _) {
        return Theme(
          data: getTheme(isDarkMode),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('QuizApp'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsMenu()),
                    );
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildProfileSection(),
                    const SizedBox(height: 24),
                    _buildStatsSection(),
                    const SizedBox(height: 24),
                    _buildLeaderboardCard(),
                  ],
                ),
              ),
            ),
            floatingActionButton: _buildQuizButton(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: _buildNavigationBar(),
          ),
        );
      },
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 80,
          backgroundImage: AssetImage('assets/images/profilepic.jpg'),
        ),
        const SizedBox(height: 24),
        const Text('Welcome back,', style: TextStyle(fontSize: 24)),
        Text(username,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatCard('Streak', '$streakDays days', Icons.whatshot),
        _buildStatCard(
            'Quizzes', '$completedQuizzes completed', Icons.psychology),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return SizedBox(
      width: 180,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeaderboardCard() {
    final leaderboardData = [
      ('a', '1200'),
      ('b', '1100'),
      ('c', '1000'),
      ('d', '950'),
      ('e', '900'),
      ('f', '850'),
      ('g', '800'),
      ('h', '750'),
      ('i', '700'),
      ('j', '650'),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Leaderboard',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...leaderboardData.asMap().entries.map((entry) =>
                _buildLeaderboardItem('${entry.key + 1}. ${entry.value.$1}',
                    '${entry.value.$2} points')),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardItem(String name, String score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          Text(score),
        ],
      ),
    );
  }

  Widget _buildQuizButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: darkModeNotifier,
      builder: (context, isDarkMode, _) {
        final theme = getTheme(isDarkMode);

        return Container(
          margin: const EdgeInsets.only(bottom: 70),
          height: 64,
          child: FloatingActionButton.extended(
            onPressed: () async {
              final result = await Navigator.push<int>(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(
                    completedQuizzes: completedQuizzes,
                    cardColor: theme.cardTheme.color!,
                    backgroundColor: theme.scaffoldBackgroundColor,
                    quiz: Quiz(questions: [
                      MultipleChoice(
                        question:
                            'Which planet in our solar system has the most moons?',
                        choices: ['Earth', 'Mars', 'Jupiter', 'Saturn'],
                        answer: 'Saturn',
                      ),
                      MultipleChoice(
                        question: 'What is the rarest blood type in humans?',
                        choices: ['O+', 'A-', 'B+', 'AB-'],
                        answer: 'AB-',
                      ),
                      MultipleChoice(
                        question:
                            'Which element has the highest melting point?',
                        choices: ['Iron', 'Tungsten', 'Gold', 'Platinum'],
                        answer: 'Tungsten',
                      ),
                      MultipleChoice(
                        question:
                            'Who developed the theory of general relativity?',
                        choices: [
                          'Isaac Newton',
                          'Albert Einstein',
                          'Nikola Tesla',
                          'Galileo Galilei'
                        ],
                        answer: 'Albert Einstein',
                      ),
                      MultipleChoice(
                        question:
                            'What is the only mammal capable of sustained flight?',
                        choices: [
                          'Bat',
                          'Flying Squirrel',
                          'Eagle',
                          'Sugar Glider'
                        ],
                        answer: 'Bat',
                      ),
                      MultipleChoice(
                        question:
                            'Which country has won the most FIFA World Cup titles?',
                        choices: ['Germany', 'Argentina', 'Brazil', 'France'],
                        answer: 'Brazil',
                      ),
                      MultipleChoice(
                        question: 'What is the longest river in the world?',
                        choices: [
                          'Amazon River',
                          'Yangtze River',
                          'Mississippi River',
                          'Nile River'
                        ],
                        answer: 'Nile River',
                      ),
                      MultipleChoice(
                        question: 'What is the smallest unit of matter?',
                        choices: ['Molecule', 'Atom', 'Proton', 'Quark'],
                        answer: 'Quark',
                      ),
                      MultipleChoice(
                        question:
                            'Which programming language is known as the "language of the web"?',
                        choices: ['Python', 'C++', 'JavaScript', 'Java'],
                        answer: 'JavaScript',
                      ),
                      MultipleChoice(
                        question:
                            'What is the main ingredient in traditional Japanese miso soup?',
                        choices: ['Tofu', 'Soybeans', 'Seaweed', 'Rice'],
                        answer: 'Soybeans',
                      ),
                    ]),
                  ),
                ),
              );
              if (result != null) {
                setState(() {
                  completedQuizzes = result; // Update the state with the result
                });
              }
            },
            label: const Text('Take Quiz', style: TextStyle(fontSize: 18)),
            icon: const Icon(Icons.play_arrow, size: 28),
          ),
        );
      },
    );
  }

  Widget _buildNavigationBar() {
    return NavigationBar(
      height: 60,
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() => _selectedIndex = index);

        // Handle navigation based on index
        if (index == 1) {
          // Quizzes
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QuizMenu()),
          );
        } else if (index == 2) {
          // Notes
          Navigator.push(
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
    );
  }
}
