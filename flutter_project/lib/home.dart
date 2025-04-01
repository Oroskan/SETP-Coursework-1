import 'package:flutter/material.dart';
import 'settings_menu.dart';
import 'quiz/quiz_menu.dart';
import 'notes/notes_menu.dart';
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
        getTheme(isDarkMode);

        return Container(
          margin: const EdgeInsets.only(bottom: 70),
          height: 64,
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuizMenu()),
              );
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
