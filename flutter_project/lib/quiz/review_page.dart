import 'package:flutter/material.dart';
import 'quiz.dart';
import '../theme.dart';

class ReviewPage extends StatelessWidget {
  final List<Map<String, dynamic>> userAnswers;

  const ReviewPage({super.key, required this.userAnswers});

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
                title: const Text('Review Answers'),
              ),
              body: ListView.builder(
                itemCount: userAnswers.length,
                itemBuilder: (context, index) {
                  final answerData = userAnswers[index];
                  final question = answerData['question'] as Question;
                  final userAnswer = answerData['userAnswer'];
                  final isCorrect = answerData['isCorrect'] as bool;

                  final correctColor = theme.colorScheme.tertiary;
                  final incorrectColor = theme.colorScheme.error;

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Question ${index + 1}:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            question.question,
                            style: TextStyle(
                              fontSize: 18,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Display appropriate content based on question type
                          if (question is MultipleChoice) ...[
                            Text(
                              'Choices:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            ...question.choices.map((choice) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      Icon(
                                        choice == question.answer
                                            ? Icons.check_circle
                                            : (choice == userAnswer
                                                ? Icons.cancel
                                                : Icons.circle_outlined),
                                        color: choice == question.answer
                                            ? correctColor
                                            : (choice == userAnswer &&
                                                    choice != question.answer
                                                ? incorrectColor
                                                : theme.colorScheme
                                                    .onSurfaceVariant
                                                    .withOpacity(0.6)),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        choice,
                                        style: TextStyle(
                                          color: theme.colorScheme.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ] else ...[
                            Row(
                              children: [
                                Text(
                                  'Correct answer: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                Text(
                                  question is QuestionAnswer
                                      ? (question).answer
                                      : (question is FillInTheBlank
                                          ? (question).answer
                                          : ''),
                                  style: TextStyle(color: correctColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  'Your answer: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                Text(
                                  userAnswer ?? 'Skipped',
                                  style: TextStyle(
                                    color: isCorrect
                                        ? correctColor
                                        : incorrectColor,
                                  ),
                                ),
                              ],
                            ),
                          ],

                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                isCorrect ? Icons.check_circle : Icons.cancel,
                                color:
                                    isCorrect ? correctColor : incorrectColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isCorrect ? 'Correct' : 'Incorrect',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isCorrect ? correctColor : incorrectColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        });
  }
}
