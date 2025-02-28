import 'package:flutter/material.dart';
import 'quiz.dart';
import '../notes/summary_page.dart';

bool answered = false;

///will find a work around for this x2

class QuizScreen extends StatefulWidget {
  bool answered = false;

  final Color cardColor;
  final Color backgroundColor;
  final completedQuizzes;
  final Quiz quiz;

  QuizScreen(
      {required this.backgroundColor,
      required this.cardColor,
      required this.completedQuizzes,
      required this.quiz});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int correctCount = 0;
  int incorrectCount = 0;
  int startTime = (DateTime.now().millisecondsSinceEpoch / 1000).toInt();

  int currentQuestionIndex = 0;

  void skipQuestion() {
    setState(() {
      if (answered == false) {
        incorrectCount++;
      }
      answered = false;

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

  void answerQuestion(int index) {
    MultipleChoice currentQuestion =
        widget.quiz.questions[currentQuestionIndex];
    print(correctCount);

    if (currentQuestion.choices[index] == currentQuestion.answer) {
      correctCount++;
    } else {
      incorrectCount++;
    }
  }

  @override
  Widget build(BuildContext context) {
    MultipleChoice currentQuestion =
        widget.quiz.questions[currentQuestionIndex];

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
          icon: Icon(Icons.close),
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
              Divider(
                color: const Color.fromARGB(255, 0, 0, 0),
                thickness: 2,
                indent: 30,
                endIndent: 30,
              ),
              Aligned(
                child: Text(
                  currentQuestion.question,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    letterSpacing: 0.7,
                    fontFamily: 'Raleway',
                  ),
                ),
                amount: 30,
              ),
              SizedBox(height: 30),
              for (int i = 0; i < currentQuestion.choices.length; i++)
                Aligned(
                  child: CustomTextDisplayBox(
                    color: widget.cardColor,
                    key: ValueKey(currentQuestionIndex),
                    text: currentQuestion.choices[i],
                    hotkey: '${i + 1}',
                    onTap: () {
                      answerQuestion(i);

                      //currently no verification of answering?
                    },
                    isCorrect:
                        currentQuestion.choices[i] == currentQuestion.answer,
                  ),
                  amount: 30,
                ),
              SizedBox(height: 30),
              Aligned(
                child: CustomTextDisplayBox(
                  color: widget.cardColor,
                  key: ValueKey(-1), // Keep this key static
                  text: 'Continue',
                  onTap: skipQuestion,
                ),
                amount: 150.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Aligned extends StatelessWidget {
  final Widget child;
  final double amount;

  Aligned({required this.child, required this.amount});

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
  final VoidCallback onTap;
  final Color color;

  CustomTextDisplayBox({
    required Key key,
    required this.text,
    this.hotkey,
    this.isCorrect,
    required this.onTap,
    required this.color,
  }) : super(key: key);

  @override
  _CustomTextDisplayBoxState createState() => _CustomTextDisplayBoxState();
}

class _CustomTextDisplayBoxState extends State<CustomTextDisplayBox> {
  late Color _boxColor;

  void initState() {
    super.initState();
    _boxColor = widget.color;
  }

  bool _answered = false; // Keep track of whether the user has answered

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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleTap,
        splashColor: Colors.blue.withOpacity(0.5),
        highlightColor: Colors.blue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15.0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: _boxColor,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
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
                    padding: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(color: Colors.grey, width: 1.0),
                    ),
                    child: Text(
                      widget.hotkey!,
                      style: TextStyle(fontSize: 12.0, color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(width: 12.0),
              ],
              Expanded(
                child: Text(
                  widget.text,
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
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

  CurvedProgressBar({required this.percentage});

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
