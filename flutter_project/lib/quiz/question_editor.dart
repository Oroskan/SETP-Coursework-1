import 'package:flutter/material.dart';
import 'quiz.dart';
import '../theme.dart';

class QuestionEditorPage extends StatefulWidget {
  final Question? question;
  final int? questionIndex;

  const QuestionEditorPage({
    super.key,
    this.question,
    this.questionIndex,
  });

  @override
  State<QuestionEditorPage> createState() => _QuestionEditorPageState();
}

class _QuestionEditorPageState extends State<QuestionEditorPage> {
  late TextEditingController _questionController;
  late String _selectedType;
  late TextEditingController _answerController;
  late TextEditingController _hintController;
  late List<TextEditingController> _choiceControllers;

  final List<String> _questionTypes = [
    'multiple_choice',
    'question_answer',
    'fill_in_the_blank',
  ];

  @override
  void initState() {
    super.initState();

    // Initialize all controllers with default values first
    _questionController = TextEditingController();
    _answerController = TextEditingController();
    _hintController = TextEditingController();
    _choiceControllers = List.generate(
      4, // Start with 4 choices by default
      (_) => TextEditingController(),
    );

    // Default type for new questions
    _selectedType = 'question_answer';

    // Then populate with existing question data if available
    if (widget.question != null) {
      _questionController.text = widget.question!.question;

      if (widget.question is MultipleChoice) {
        _selectedType = 'multiple_choice';
        final multipleChoice = widget.question as MultipleChoice;
        _answerController.text = multipleChoice.answer;

        // Clear default controllers and create new ones for each choice
        for (var controller in _choiceControllers) {
          controller.dispose();
        }
        _choiceControllers = multipleChoice.choices
            .map((choice) => TextEditingController(text: choice))
            .toList();
      } else if (widget.question is QuestionAnswer) {
        _selectedType = 'question_answer';
        _answerController.text = (widget.question as QuestionAnswer).answer;
      } else if (widget.question is FillInTheBlank) {
        _selectedType = 'fill_in_the_blank';
        final fillInBlank = widget.question as FillInTheBlank;
        _answerController.text = fillInBlank.answer;
        _hintController.text = fillInBlank.hint;
      }
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    _hintController.dispose();
    for (var controller in _choiceControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addChoice() {
    setState(() {
      _choiceControllers.add(TextEditingController());
    });
  }

  void _removeChoice(int index) {
    setState(() {
      _choiceControllers[index].dispose();
      _choiceControllers.removeAt(index);
    });
  }

  Question _buildQuestion() {
    switch (_selectedType) {
      case 'multiple_choice':
        return MultipleChoice(
          question: _questionController.text,
          choices: _choiceControllers
              .map((controller) => controller.text)
              .where((text) => text.isNotEmpty)
              .toList(),
          answer: _answerController.text,
        );
      case 'fill_in_the_blank':
        return FillInTheBlank(
          question: _questionController.text,
          answer: _answerController.text,
          hint: _hintController.text,
        );
      case 'question_answer':
      default:
        return QuestionAnswer(
          question: _questionController.text,
          answer: _answerController.text,
        );
    }
  }

  void _saveQuestion() {
    if (_questionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Question text cannot be empty'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (_answerController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Answer cannot be empty'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (_selectedType == 'multiple_choice') {
      // Check if we have at least 2 non-empty choices
      final nonEmptyChoices = _choiceControllers
          .map((c) => c.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      if (nonEmptyChoices.length < 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                const Text('Multiple choice questions need at least 2 options'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }

      // Check if the answer is among the choices
      if (!nonEmptyChoices.contains(_answerController.text.trim())) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                const Text('The answer must be one of the provided choices'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }
    }

    // All validation passed, return the question
    Navigator.pop(context, _buildQuestion());
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
                title: Text(
                    widget.question == null ? 'Add Question' : 'Edit Question'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: _saveQuestion,
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question text field
                    TextField(
                      controller: _questionController,
                      decoration: const InputDecoration(
                        labelText: 'Question',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Question type dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Question Type',
                      ),
                      items: _questionTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type == 'multiple_choice'
                              ? 'Multiple Choice'
                              : type == 'question_answer'
                                  ? 'Question & Answer'
                                  : 'Fill in the Blank'),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedType = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Type-specific fields
                    if (_selectedType == 'multiple_choice') ...[
                      Text(
                        'Answer Choices',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Choices list
                      ...List.generate(_choiceControllers.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _choiceControllers[index],
                                  decoration: InputDecoration(
                                    labelText: 'Choice ${index + 1}',
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: theme.colorScheme.error,
                                ),
                                onPressed: _choiceControllers.length > 2
                                    ? () => _removeChoice(index)
                                    : null,
                              ),
                            ],
                          ),
                        );
                      }),

                      // Add choice button
                      TextButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Add Choice'),
                        onPressed: _addChoice,
                      ),
                      const SizedBox(height: 16),

                      // Correct answer for multiple choice
                      TextField(
                        controller: _answerController,
                        decoration: const InputDecoration(
                          labelText:
                              'Correct Answer (must match one of the choices)',
                        ),
                      ),
                    ] else if (_selectedType == 'fill_in_the_blank') ...[
                      // Answer field
                      TextField(
                        controller: _answerController,
                        decoration: const InputDecoration(
                          labelText: 'Answer',
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Hint field
                      TextField(
                        controller: _hintController,
                        decoration: const InputDecoration(
                          labelText: 'Hint (optional)',
                        ),
                      ),
                    ] else ...[
                      // Simple answer field for question & answer
                      TextField(
                        controller: _answerController,
                        decoration: const InputDecoration(
                          labelText: 'Answer',
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        });
  }
}
