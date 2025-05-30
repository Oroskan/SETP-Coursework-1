import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../home.dart';
import '../notes/notes_menu.dart';
import '../theme.dart';
import '../settings_menu.dart';
import 'quiz.dart';
import 'create_quiz.dart';
import 'quiz_editor.dart';
import 'question_page.dart';

class QuizMenu extends StatefulWidget {
  const QuizMenu({super.key});

  @override
  State<QuizMenu> createState() => _QuizMenuState();
}

class _QuizMenuState extends State<QuizMenu> {
  final int _selectedIndex = 1;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late Box<Quiz> quizzesBox;

  @override
  void initState() {
    super.initState();
    quizzesBox = Hive.box<Quiz>('quizzes');

    if (quizzesBox.isEmpty) {
      _populateSampleQuizzes();
    }
  }

  void _populateSampleQuizzes() {
    final sampleQuizzes = [
      Quiz(
        title: 'Chemical Bonding Quiz',
        questions: [],
      )..title = 'Chemical Bonding Quiz',
      Quiz(
        title: 'Forces and Motion',
        questions: [],
      )..title = 'Forces and Motion',
      Quiz(
        title: 'DNA and RNA',
        questions: [],
      )..title = 'DNA and RNA',
      Quiz(
        title: 'Algorithm Analysis',
        questions: [],
      )..title = 'Algorithm Analysis',
      Quiz(
        title: 'Integration Methods',
        questions: [],
      )..title = 'Integration Methods',
      Quiz(
        title: 'Literature Analysis',
        questions: [],
      )..title = 'Literature Analysis',
      Quiz(
        title: 'World War II',
        questions: [],
      )..title = 'World War II',
      Quiz(
        title: 'Tectonic Plates',
        questions: [],
      )..title = 'Tectonic Plates',
      Quiz(
        title: 'Supply and Demand',
        questions: [],
      )..title = 'Supply and Demand',
      Quiz(
        title: 'Cognitive Development',
        questions: [],
      )..title = 'Cognitive Development',
      Quiz(
        title: 'Cultural Studies',
        questions: [],
      )..title = 'Cultural Studies',
    ];

    for (var quiz in sampleQuizzes) {
      quizzesBox.add(quiz);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Quiz> get filteredQuizzes {
    if (_searchQuery.isEmpty) {
      return quizzesBox.values.toList();
    }
    return quizzesBox.values.where((quiz) {
      final title = quiz.title.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return title.contains(query);
    }).toList();
  }

  void _addNewQuiz() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateQuizPage()),
    );

    if (result != null && result is Quiz) {
      setState(() {
        quizzesBox.add(result);
      });
    }
  }

  void _deleteQuiz(int index) {
    setState(() {
      final quiz = filteredQuizzes[index];
      quiz.delete();
    });
  }

  void _editQuiz(int index) async {
    final quiz = filteredQuizzes[index];
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizEditorPage(
          quiz: quiz,
          quizIndex: index,
        ),
      ),
    );
    if (result != null && result is Quiz) {
      setState(() {
        // Update the quiz in the box
        final boxIndex = quizzesBox.values.toList().indexOf(quiz);
        if (boxIndex >= 0) {
          quizzesBox.putAt(boxIndex, result);
        }
      });
    }
  }

  void _takeQuiz(Quiz quiz) {
    if (quiz.questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'This quiz has no questions yet. Add questions before taking the quiz.'),
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          quiz: quiz,
          completedQuizzes: 0,
        ),
      ),
    );
  }

  Future<bool> _confirmDelete() async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(
              'Delete Quiz',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            content: Text(
              'Are you sure you want to delete this quiz?',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
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
                      leading: Icon(
                        Icons.settings,
                        color: theme.colorScheme.primary,
                      ),
                      title: Text(
                        'Settings',
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
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
                        prefixIcon: Icon(
                          Icons.search,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
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
                                children: List.generate(
                                  filteredQuizzes.length,
                                  (index) => _buildQuizButton(
                                      filteredQuizzes[index], index, theme),
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: _buildAddQuizButton(theme),
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

  Widget _buildQuizButton(Quiz quiz, int index, ThemeData theme) {
    return Dismissible(
      key: Key(quiz.key.toString()),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) {
        if (direction == DismissDirection.endToStart) {
          return _confirmDelete();
        } else {
          _editQuiz(index);
          return Future.value(false);
        }
      },
      onDismissed: (_) => _deleteQuiz(index),
      background: Container(
        margin: const EdgeInsets.only(top: 16.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(8.0),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20.0),
        child: Icon(Icons.edit, color: theme.colorScheme.onPrimary),
      ),
      secondaryBackground: Container(
        margin: const EdgeInsets.only(top: 16.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(8.0),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: Icon(Icons.delete, color: theme.colorScheme.onError),
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 16.0),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            padding: const EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () => _takeQuiz(quiz),
          child: Column(
            children: [
              Icon(Icons.quiz, color: theme.colorScheme.onPrimary, size: 30),
              const SizedBox(height: 8),
              Text(
                quiz.title,
                style: TextStyle(
                  fontSize: 24,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${quiz.questions.length} questions',
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

  Widget _buildAddQuizButton(ThemeData theme) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: const EdgeInsets.only(right: 16, bottom: 70),
        height: 64,
        width: 64,
        child: FloatingActionButton(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          onPressed: _addNewQuiz,
          child: const Text('+', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
