import 'package:flutter/material.dart';
import '../theme.dart';
import 'quiz.dart';

class CreateQuizPage extends StatefulWidget {
  const CreateQuizPage({super.key});

  @override
  State<CreateQuizPage> createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
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
                title: const Text('Create New Quiz'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Quiz Title',
                      ),
                      maxLength: 50,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (_titleController.text.trim().isNotEmpty) {
                          // Create a new quiz with no questions yet
                          final quiz = Quiz(
                            title: _titleController.text.trim(),
                            questions: [],
                          );
                          Navigator.pop(context, quiz);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Please enter a quiz title'),
                              backgroundColor: theme.colorScheme.error,
                            ),
                          );
                        }
                      },
                      child: const Text('Create Quiz'),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
