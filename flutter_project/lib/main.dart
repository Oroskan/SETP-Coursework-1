import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'theme.dart'; // Import the theme file
import 'splash_screen.dart';
import 'notes/note.dart';
import 'quiz/quiz.dart';
import 'quiz/question_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(QuizAdapter());
  Hive.registerAdapter(CustomQuestionAdapter());
  Hive.registerAdapter(MultipleChoiceAdapter());
  Hive.registerAdapter(QuestionAnswerAdapter());
  Hive.registerAdapter(FillInTheBlankAdapter());

  // Open the boxes
  await Hive.openBox<Note>('notes');
  await Hive.openBox<Quiz>('quizzes');

  // Initialize settings
  await Settings.init(cacheProvider: SharePreferenceCache());

  // Load saved dark mode preference
  final savedDarkMode =
      Settings.getValue<bool>(keyDarkMode, defaultValue: false);
  darkModeNotifier.value = savedDarkMode ?? false;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: darkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Quiz App',
          theme: getTheme(false), // Light mode theme
          darkTheme: getTheme(true), // Dark mode theme
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const SplashScreen(),
        );
      },
    );
  }
}
