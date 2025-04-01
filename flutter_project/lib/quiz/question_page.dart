import 'package:flutter/material.dart';
import 'quiz.dart';
import 'summary_page.dart';

bool answered = false;

class QuizScreen extends StatefulWidget {
  final Color cardColor;
  final Color backgroundColor;
  final int completedQuizzes;
  final Quiz quiz;

  const QuizScreen({
    super.key,
    required this.backgroundColor,
    required this.cardColor,
    required this.completedQuizzes,
    required this.quiz,
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

  void skipQuestion() {
    setState(() {
      if (!answered) {
        incorrectCount++;
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

      if (currentQuestion.choices[index] == currentQuestion.answer) {
        correctCount++;
      } else {
        incorrectCount++;
      }
    });
  }

  void answerQuestionAnswer() {
    if (answered) return;

    setState(() {
      QuestionAnswer currentQuestion =
          widget.quiz.questions[currentQuestionIndex] as QuestionAnswer;
      answered = true;
      userAnswer = textController.text;

      if (textController.text.trim().toLowerCase() ==
          currentQuestion.answer.toLowerCase()) {
        correctCount++;
      } else {
        incorrectCount++;
      }
    });
  }

  void answerFillInTheBlank() {
    if (answered) return;

    setState(() {
      FillInTheBlank currentQuestion =
          widget.quiz.questions[currentQuestionIndex] as FillInTheBlank;
      answered = true;
      userAnswer = textController.text;

      if (textController.text.trim().toLowerCase() ==
          currentQuestion.answer.toLowerCase()) {
        correctCount++;
      } else {
        incorrectCount++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Question currentQuestion = widget.quiz.questions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        backgroundColor: widget.backgroundColor,
        leading: IconButton(
          onPressed: () {
            if (currentQuestionIndex == widget.quiz.questions.length - 1) {
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
            percentage: currentQuestionIndex / widget.quiz.questions.length,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              const Divider(
                color: Color.fromARGB(255, 0, 0, 0),
                thickness: 2,
                indent: 30,
                endIndent: 30,
              ),
              Aligned(
                amount: 30,
                child: Text(
                  currentQuestion.question,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    letterSpacing: 0.7,
                    fontFamily: 'Raleway',
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Different question types require different UI
              if (currentQuestion is MultipleChoice)
                _buildMultipleChoiceQuestion(currentQuestion)
              else if (currentQuestion is QuestionAnswer)
                _buildQuestionAnswerQuestion(currentQuestion)
              else if (currentQuestion is FillInTheBlank)
                _buildFillInTheBlankQuestion(currentQuestion),

              const SizedBox(height: 30),

              Aligned(
                amount: 150.0,
                child: CustomTextDisplayBox(
                  color: widget.cardColor,
                  key: const ValueKey(-1),
                  text: answered ? 'Continue' : 'Skip',
                  onTap: skipQuestion,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMultipleChoiceQuestion(MultipleChoice question) {
    return Column(
      children: [
        for (int i = 0; i < question.choices.length; i++)
          Aligned(
            amount: 30,
            child: CustomTextDisplayBox(
              color: widget.cardColor,
              key: ValueKey('$currentQuestionIndex-$i'),
              text: question.choices[i],
              hotkey: '${i + 1}',
              onTap: () => answerMultipleChoice(i),
              isCorrect:
                  answered ? question.choices[i] == question.answer : null,
              isSelected: false,
            ),
          ),
      ],
    );
  }

  Widget _buildQuestionAnswerQuestion(QuestionAnswer question) {
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                filled: true,
                fillColor: widget.cardColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: answered ? null : answerQuestionAnswer,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
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
                  color:
                      userAnswer == question.answer ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFillInTheBlankQuestion(FillInTheBlank question) {
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
                  color: Colors.grey[700],
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                filled: true,
                fillColor: widget.cardColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: answered ? null : answerFillInTheBlank,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
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
                  color:
                      userAnswer == question.answer ? Colors.green : Colors.red,
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

  const CustomTextDisplayBox({
    required Key key,
    required this.text,
    this.hotkey,
    this.isCorrect,
    this.isSelected,
    required this.onTap,
    required this.color,
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
      setState(() {
        _boxColor = widget.isCorrect! ? Colors.green : Colors.red;
        answered = true;
      });
    }

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    // Update color based on correct/incorrect status
    if (widget.isCorrect != null) {
      _boxColor =
          widget.isCorrect! ? Colors.green.shade200 : Colors.red.shade200;
    } else if (widget.isSelected == true) {
      _boxColor = Colors.blue.shade200;
    } else {
      _boxColor = widget.color;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleTap,
        splashColor: Colors.blue.withOpacity(0.5),
        highlightColor: Colors.blue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: _boxColor,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.hotkey != null) ...[
                InkWell(
                  onTap: _handleTap,
                  splashColor: Colors.blue.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4.0),
                  child: Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(color: Colors.grey, width: 1.0),
                    ),
                    child: Text(
                      widget.hotkey!,
                      style:
                          const TextStyle(fontSize: 12.0, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
              ],
              Expanded(
                child: Text(
                  widget.text,
                  style: const TextStyle(fontSize: 18.0, color: Colors.black),
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

  const CurvedProgressBar({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth * 0.8;
        return Container(
          width: width,
          height: 20.0,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 99, 174, 116),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        );
      },
    );
  }
}
