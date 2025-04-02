import 'package:flutter/material.dart';
import 'quiz.dart';
import 'summary_page.dart';
import '../theme.dart';

bool answered = false;

class QuizScreen extends StatefulWidget {
  final Quiz quiz;
  final int completedQuizzes;

  const QuizScreen({
    super.key,
    required this.quiz,
    required this.completedQuizzes,
  });

  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends State<QuizScreen> {
  int correctCount = 0;
  int incorrectCount = 0;
  int startTime = (DateTime.now().millisecondsSinceEpoch / 1000).toInt();

  int currentQuestionIndex = 0;
  bool answered = false;
  String? userAnswer;
  final textController = TextEditingController();

  // Track user answers for review
  List<Map<String, dynamic>> userAnswers = [];

  void skipQuestion() {
    setState(() {
      if (!answered) {
        incorrectCount++;
        // Record skipped question
        userAnswers.add({
          'question': widget.quiz.questions[currentQuestionIndex],
          'userAnswer': null,
          'isCorrect': false
        });
      }
      answered = false;
      userAnswer = null;
      textController.clear();

      if (currentQuestionIndex < widget.quiz.questions.length - 1) {
        currentQuestionIndex++;
      } else {
        Navigator.pop(context);

        Navigator.push<int>(
          context,
          MaterialPageRoute(
            builder: (context) => QuizSummary(
              correctAnswers: correctCount,
              incorrectAnswers: incorrectCount,
              message: "You're learning",
              timeTaken: double.parse(
                  ((DateTime.now().millisecondsSinceEpoch / 1000) - (startTime))
                      .toStringAsFixed(2)),
              userAnswers: userAnswers,
              quiz: widget.quiz,
            ),
          ),
        );
      }
    });
  }

  void answerMultipleChoice(int index) {
    if (answered) return;

    setState(() {
      MultipleChoice currentQuestion =
          widget.quiz.questions[currentQuestionIndex] as MultipleChoice;
      answered = true;
      String selectedAnswer = currentQuestion.choices[index];
      userAnswer = selectedAnswer;
      bool isCorrect = selectedAnswer == currentQuestion.answer;

      if (isCorrect) {
        correctCount++;
      } else {
        incorrectCount++;
      }

      // Record the answer
      userAnswers.add({
        'question': currentQuestion,
        'userAnswer': selectedAnswer,
        'isCorrect': isCorrect
      });
    });
  }

  void answerQuestionAnswer() {
    if (answered) return;

    setState(() {
      QuestionAnswer currentQuestion =
          widget.quiz.questions[currentQuestionIndex] as QuestionAnswer;
      answered = true;
      userAnswer = textController.text;
      bool isCorrect = textController.text.trim().toLowerCase() ==
          currentQuestion.answer.toLowerCase();

      if (isCorrect) {
        correctCount++;
      } else {
        incorrectCount++;
      }

      // Record the answer
      userAnswers.add({
        'question': currentQuestion,
        'userAnswer': textController.text,
        'isCorrect': isCorrect
      });
    });
  }

  void answerFillInTheBlank() {
    if (answered) return;

    setState(() {
      FillInTheBlank currentQuestion =
          widget.quiz.questions[currentQuestionIndex] as FillInTheBlank;
      answered = true;
      userAnswer = textController.text;
      bool isCorrect = textController.text.trim().toLowerCase() ==
          currentQuestion.answer.toLowerCase();

      if (isCorrect) {
        correctCount++;
      } else {
        incorrectCount++;
      }

      // Record the answer
      userAnswers.add({
        'question': currentQuestion,
        'userAnswer': textController.text,
        'isCorrect': isCorrect
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: darkModeNotifier,
      builder: (context, isDarkMode, _) {
        final theme = getTheme(isDarkMode);

        // Safety check for quizzes with no questions
        if (widget.quiz.questions.isEmpty) {
          return Theme(
            data: theme,
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
                title: const Text('Error'),
                centerTitle: true,
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 80,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'This quiz has no questions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please add questions before taking this quiz',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        Question currentQuestion = widget.quiz.questions[currentQuestionIndex];

        return Theme(
          data: theme,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  if (currentQuestionIndex ==
                      widget.quiz.questions.length - 1) {
                    Navigator.pop(context, widget.completedQuizzes + 1);
                  } else {
                    Navigator.pop(context, widget.completedQuizzes);
                  }
                },
                icon: const Icon(Icons.close),
              ),
              title: SizedBox(
                height: 20,
                child: CurvedProgressBar(
                  percentage:
                      currentQuestionIndex / widget.quiz.questions.length,
                  progressColor: theme.colorScheme.primary,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                ),
              ),
              centerTitle: true,
            ),
            body: Stack(
              children: [
                Column(
                  children: <Widget>[
                    Divider(
                      color: theme.dividerTheme.color,
                      thickness: theme.dividerTheme.thickness,
                      indent: 30,
                      endIndent: 30,
                    ),
                    Aligned(
                      amount: 30,
                      child: Text(
                        currentQuestion.question,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                          letterSpacing: 0.7,
                          fontFamily: 'Raleway',
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Different question types require different UI
                    if (currentQuestion is MultipleChoice)
                      _buildMultipleChoiceQuestion(currentQuestion, theme)
                    else if (currentQuestion is QuestionAnswer)
                      _buildQuestionAnswerQuestion(currentQuestion, theme)
                    else if (currentQuestion is FillInTheBlank)
                      _buildFillInTheBlankQuestion(currentQuestion, theme),

                    const SizedBox(height: 30),

                    Aligned(
                      amount: 150.0,
                      child: CustomTextDisplayBox(
                        color:
                            theme.cardTheme.color ?? theme.colorScheme.surface,
                        key: const ValueKey(-1),
                        text: answered ? 'Continue' : 'Skip',
                        onTap: skipQuestion,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMultipleChoiceQuestion(
      MultipleChoice question, ThemeData theme) {
    return Column(
      children: [
        for (int i = 0; i < question.choices.length; i++)
          Aligned(
            amount: 30,
            child: CustomTextDisplayBox(
              color: theme.cardTheme.color ?? theme.colorScheme.surface,
              key: ValueKey('$currentQuestionIndex-$i'),
              text: question.choices[i],
              hotkey: '${i + 1}',
              onTap: () => answerMultipleChoice(i),
              isCorrect:
                  answered ? question.choices[i] == question.answer : null,
              isSelected: false,
              theme: theme,
            ),
          ),
      ],
    );
  }

  Widget _buildQuestionAnswerQuestion(
      QuestionAnswer question, ThemeData theme) {
    return Aligned(
      amount: 30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              controller: textController,
              enabled: !answered,
              decoration: InputDecoration(
                hintText: 'Type your answer here',
                filled: true,
                fillColor: theme.cardTheme.color ?? theme.colorScheme.surface,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: answered ? null : answerQuestionAnswer,
            child: const Text('Submit Answer'),
          ),
          if (answered)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                userAnswer == question.answer
                    ? 'Correct! The answer is: ${question.answer}'
                    : 'Incorrect. The correct answer is: ${question.answer}',
                style: TextStyle(
                  color: userAnswer == question.answer
                      ? theme.colorScheme.tertiary
                      : theme.colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFillInTheBlankQuestion(
      FillInTheBlank question, ThemeData theme) {
    return Aligned(
      amount: 30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (question.hint.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Hint: ${question.hint}',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              controller: textController,
              enabled: !answered,
              decoration: InputDecoration(
                hintText: 'Fill in the blank',
                filled: true,
                fillColor: theme.cardTheme.color ?? theme.colorScheme.surface,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: answered ? null : answerFillInTheBlank,
            child: const Text('Submit Answer'),
          ),
          if (answered)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                userAnswer == question.answer
                    ? 'Correct! The answer is: ${question.answer}'
                    : 'Incorrect. The correct answer is: ${question.answer}',
                style: TextStyle(
                  color: userAnswer == question.answer
                      ? theme.colorScheme.tertiary
                      : theme.colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}

class Aligned extends StatelessWidget {
  final Widget child;
  final double amount;

  const Aligned({super.key, required this.child, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: amount),
        child: child,
      ),
    );
  }
}

class CustomTextDisplayBox extends StatefulWidget {
  final String text;
  final String? hotkey;
  final bool? isCorrect;
  final bool? isSelected;
  final VoidCallback onTap;
  final Color color;
  final ThemeData? theme;

  const CustomTextDisplayBox({
    required Key key,
    required this.text,
    this.hotkey,
    this.isCorrect,
    this.isSelected,
    required this.onTap,
    required this.color,
    this.theme,
  }) : super(key: key);

  @override
  CustomTextDisplayBoxState createState() => CustomTextDisplayBoxState();
}

class CustomTextDisplayBoxState extends State<CustomTextDisplayBox> {
  late Color _boxColor;

  @override
  void initState() {
    super.initState();
    _boxColor = widget.color;
  }

  void _handleTap() {
    if (!answered && widget.isCorrect != null) {
      final theme = widget.theme ?? Theme.of(context);
      setState(() {
        _boxColor = widget.isCorrect!
            ? theme.colorScheme.tertiary.withOpacity(0.2)
            : theme.colorScheme.error.withOpacity(0.2);
        answered = true;
      });
    }

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? Theme.of(context);

    // Update color based on correct/incorrect status
    if (widget.isCorrect != null) {
      _boxColor = widget.isCorrect!
          ? theme.colorScheme.tertiary.withOpacity(0.2)
          : theme.colorScheme.error.withOpacity(0.2);
    } else if (widget.isSelected == true) {
      _boxColor = theme.colorScheme.primary.withOpacity(0.2);
    } else {
      _boxColor = widget.color;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleTap,
        splashColor: theme.colorScheme.primary.withOpacity(0.3),
        highlightColor: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: _boxColor,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.2),
                blurRadius: 10.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.hotkey != null) ...[
                InkWell(
                  onTap: _handleTap,
                  splashColor: theme.colorScheme.primary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4.0),
                  child: Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                        color: theme.colorScheme.outline,
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      widget.hotkey!,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
              ],
              Expanded(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CurvedProgressBar extends StatelessWidget {
  final double percentage;
  final Color? progressColor;
  final Color? backgroundColor;

  const CurvedProgressBar({
    super.key,
    required this.percentage,
    this.progressColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressColorToUse = progressColor ?? theme.colorScheme.primary;
    final backgroundColorToUse =
        backgroundColor ?? theme.colorScheme.surfaceContainerHighest;

    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth * 0.8;
        return Container(
          width: width,
          height: 20.0,
          decoration: BoxDecoration(
            color: backgroundColorToUse,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: progressColorToUse,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        );
      },
    );
  }
}
