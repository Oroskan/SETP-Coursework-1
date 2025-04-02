import 'package:flutter/material.dart';
import 'dart:math';
import '/quiz/quiz.dart';
import '/quiz/review_page.dart';
import '/quiz/quiz_menu.dart';
import '../theme.dart';

class _PurpleRowItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _PurpleRowItem({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: theme.colorScheme.onSecondaryContainer,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: theme.colorScheme.secondary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class QuizSummary extends StatefulWidget {
  final int correctAnswers;
  final int incorrectAnswers;
  final String message;
  final double timeTaken;
  final List<Map<String, dynamic>>? userAnswers;
  final Quiz? quiz;

  const QuizSummary({
    super.key,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.message,
    required this.timeTaken,
    this.userAnswers,
    this.quiz,
  });

  @override
  State<QuizSummary> createState() => _QuizSummary();
}

class _QuizSummary extends State<QuizSummary> {
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
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.message,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 20),
                  SummaryWidget(
                    timeTaken: widget.timeTaken,
                    numberCorrect: widget.correctAnswers.toDouble(),
                    numberIncorrect: widget.incorrectAnswers.toDouble(),
                    theme: theme,
                  ),
                  const SizedBox(height: 70),
                  _PurpleRowItem(
                    title: 'Take a new test',
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuizMenu(),
                        ),
                        (Route<dynamic> route) =>
                            false, // Remove all previous routes
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _PurpleRowItem(
                    title: 'Review answers',
                    onTap: () {
                      if (widget.userAnswers != null &&
                          widget.userAnswers!.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReviewPage(
                              userAnswers: widget.userAnswers!,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('No answers to review'),
                            backgroundColor: theme.colorScheme.error,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SummaryWidget extends StatelessWidget {
  final double timeTaken;
  final double numberCorrect;
  final double numberIncorrect;
  final ThemeData? theme;

  const SummaryWidget({
    super.key,
    required this.timeTaken,
    required this.numberCorrect,
    required this.numberIncorrect,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final currentTheme = theme ?? Theme.of(context);
    double total = numberCorrect + numberIncorrect;

    double correctPercentage = (total > 0) ? (numberCorrect / total) : 0;

    final correctPrimaryColor = currentTheme.colorScheme.tertiary;
    final correctSecondaryColor =
        currentTheme.colorScheme.tertiary.withOpacity(0.2);
    final incorrectPrimaryColor = currentTheme.colorScheme.error;
    final incorrectSecondaryColor =
        currentTheme.colorScheme.error.withOpacity(0.1);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: currentTheme.cardTheme.color ??
                currentTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(15), // Curved corners
            border: Border.all(
              color: currentTheme.colorScheme.outline,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Completed in $timeTaken seconds.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: currentTheme.colorScheme.primary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Custom circle for correct percentage
                  CustomPaint(
                    size: const Size(100, 100),
                    painter: CirclePainter(
                      correctPercentage,
                      theme: currentTheme,
                    ),
                  ),
                  const SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Correct Section
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              'Correct',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: correctPrimaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 10),
                          ScoreBubble(
                            score: numberCorrect.toInt(),
                            innerColor: correctSecondaryColor,
                            outerColor: correctPrimaryColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              'Incorrect',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: incorrectPrimaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 10),
                          ScoreBubble(
                            score: numberIncorrect.toInt(),
                            innerColor: incorrectSecondaryColor,
                            outerColor: incorrectPrimaryColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double percentage;
  final ThemeData? theme;

  CirclePainter(
    this.percentage, {
    this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final currentTheme = theme ?? ThemeData.light();
    final backgroundColor = currentTheme.colorScheme.surfaceContainerHighest;
    final correctColor = currentTheme.colorScheme.tertiary;
    final incorrectColor = currentTheme.colorScheme.error;
    final textColor = currentTheme.colorScheme.onSurface;

    Paint backgroundCirclePaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    Paint progressPaint = Paint()
      ..color = correctColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    Paint incompletePaint = Paint()
      ..color = incorrectColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2,
        backgroundCirclePaint);

    double correctAngle = 2 * pi * percentage;
    Rect rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2);
    canvas.drawArc(rect, -pi / 2, correctAngle, false, progressPaint);

    double incorrectAngle = 2 * pi * (1 - percentage);
    canvas.drawArc(
        rect, -pi / 2 + correctAngle, incorrectAngle, false, incompletePaint);

    String percentageText = '${(percentage * 100).toStringAsFixed(0)}%';
    TextSpan textSpan = TextSpan(
      text: percentageText,
      style: TextStyle(
        color: textColor,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );

    TextPainter textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false; // No need to repaint unless the data changes
  }
}

class ScoreBubble extends StatelessWidget {
  final int score;
  final Color innerColor;
  final Color outerColor;

  const ScoreBubble({
    super.key,
    required this.score,
    required this.innerColor,
    required this.outerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: innerColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: outerColor,
          width: 3,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Text(
        '$score',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: outerColor,
        ),
      ),
    );
  }
}
