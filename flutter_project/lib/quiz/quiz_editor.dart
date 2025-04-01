import 'package:flutter/material.dart';
import '../theme.dart';
import 'quiz.dart';
import 'question_editor.dart';

class QuizEditorPage extends StatefulWidget {
  final Quiz quiz;
  final int quizIndex;

  const QuizEditorPage({
    super.key,
    required this.quiz,
    required this.quizIndex,
  });

  @override
  State<QuizEditorPage> createState() => _QuizEditorPageState();
}

class _QuizEditorPageState extends State<QuizEditorPage> {
  late TextEditingController _titleController;
  late Quiz _editedQuiz;

  @override
  void initState() {
    super.initState();
    // Create a deep copy of the quiz to edit
    _editedQuiz = Quiz(
      title: widget.quiz.title,
      questions: List.from(widget.quiz.questions),
    );
    _titleController = TextEditingController(text: _editedQuiz.title);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_titleController.text.trim().isNotEmpty) {
      _editedQuiz.title = _titleController.text.trim();
      Navigator.pop(context, _editedQuiz);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Quiz title cannot be empty'),
        ),
      );
    }
  }

  Future<void> _editQuestion(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionEditorPage(
          question: _editedQuiz.questions[index],
          questionIndex: index,
        ),
      ),
    );

    if (result != null && result is Question) {
      setState(() {
        _editedQuiz.questions[index] = result;
      });
    }
  }

  Future<void> _addQuestion() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QuestionEditorPage(),
      ),
    );

    if (result != null && result is Question) {
      setState(() {
        _editedQuiz.questions.add(result);
      });
    }
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
                title: const Text('Edit Quiz'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: _saveChanges,
                  ),
                ],
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
                        border: OutlineInputBorder(),
                      ),
                      maxLength: 50,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Questions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _editedQuiz.questions.isEmpty
                          ? const Center(
                              child: Text(
                                  'No questions yet. Tap + to add a question.'),
                            )
                          : ListView.builder(
                              itemCount: _editedQuiz.questions.length,
                              itemBuilder: (context, index) {
                                final question = _editedQuiz.questions[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8.0),
                                  child: ListTile(
                                    title: Text(question.question),
                                    subtitle: Text(question is MultipleChoice
                                        ? 'Multiple Choice'
                                        : question is QuestionAnswer
                                            ? 'Question & Answer'
                                            : 'Fill in the Blank'),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          _editedQuiz.questions.removeAt(index);
                                        });
                                      },
                                    ),
                                    onTap: () => _editQuestion(index),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: _addQuestion,
                child: const Icon(Icons.add),
              ),
            ),
          );
        });
  }
}
