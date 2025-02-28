import 'package:flutter/material.dart';
import 'dart:math';
import '/quiz/quiz.dart';
import '/quiz/question_page.dart';

class _PurpleRowItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  
  const _PurpleRowItem({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFEADDFF),
          borderRadius: BorderRadius.only(
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
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF65558F),
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

  const QuizSummary({
    Key? key,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.message,
    required this.timeTaken,
  }) : super(key: key);

  @override
  State<QuizSummary> createState() => _QuizSummary();
}

class _QuizSummary extends State<QuizSummary> {
  final int correctAnswers = 5;
  final int totalQuestions = 11;

  double get percentage => correctAnswers / totalQuestions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(


        leading: IconButton(
          onPressed: () {

      
            Navigator.pop(context);
          },
          icon: Icon(Icons.close),
        ),
        
        
      ),
   
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                              "${widget.message}",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                            ),
                            SizedBox(height: 20,),
        SummaryWidget(
          timeTaken: widget.timeTaken, 
          numberCorrect: widget.correctAnswers.toDouble(), 
          numberIncorrect: widget.incorrectAnswers.toDouble(), 
          correctPrimaryColor: Color(0xFF2FB273),
          correctSecondaryColor: Color(0xFFE1FDF5),
          incorrectPrimaryColor:Color(0xFFDD4300),
          incorrectSecondaryColor: Color(0xFFFFF6EE),
          ),
          SizedBox(height: 70,),

          _PurpleRowItem(
      title: 'Take a new test',
      onTap: () {
        Navigator.pop(context);
        Navigator.push<int>(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(
                    completedQuizzes: 2,
                    cardColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 239, 239, 239),
                    quiz: Quiz(questions: [
  MultipleChoice(
    question: 'Which planet in our solar system has the most moons?',
    choices: ['Earth', 'Mars', 'Jupiter', 'Saturn'],
    answer: 'Saturn',
  ),
  MultipleChoice(
    question: 'What is the rarest blood type in humans?',
    choices: ['O+', 'A-', 'B+', 'AB-'],
    answer: 'AB-',
  ),
  MultipleChoice(
    question: 'Which element has the highest melting point?',
    choices: ['Iron', 'Tungsten', 'Gold', 'Platinum'],
    answer: 'Tungsten',
  ),
  MultipleChoice(
    question: 'Who developed the theory of general relativity?',
    choices: ['Isaac Newton', 'Albert Einstein', 'Nikola Tesla', 'Galileo Galilei'],
    answer: 'Albert Einstein',
  ),
  MultipleChoice(
    question: 'What is the only mammal capable of sustained flight?',
    choices: ['Bat', 'Flying Squirrel', 'Eagle', 'Sugar Glider'],
    answer: 'Bat',
  ),
  MultipleChoice(
    question: 'Which country has won the most FIFA World Cup titles?',
    choices: ['Germany', 'Argentina', 'Brazil', 'France'],
    answer: 'Brazil',
  ),
  MultipleChoice(
    question: 'What is the longest river in the world?',
    choices: ['Amazon River', 'Yangtze River', 'Mississippi River', 'Nile River'],
    answer: 'Nile River',
  ),
  MultipleChoice(
    question: 'What is the smallest unit of matter?',
    choices: ['Molecule', 'Atom', 'Proton', 'Quark'],
    answer: 'Quark',
  ),
  MultipleChoice(
    question: 'Which programming language is known as the "language of the web"?',
    choices: ['Python', 'C++', 'JavaScript', 'Java'],
    answer: 'JavaScript',
  ),
  MultipleChoice(
    question: 'What is the main ingredient in traditional Japanese miso soup?',
    choices: ['Tofu', 'Soybeans', 'Seaweed', 'Rice'],
    answer: 'Soybeans',
  ),
]),
                  ),
                ),
              );
      },
      
          ),
          SizedBox(height: 20,),
          _PurpleRowItem(
      title: 'Review answers',
      onTap: () {
        
      },),

          ],
        ),
      ),
    );
  }


}


class SummaryWidget extends StatelessWidget {
  final double timeTaken;
  final double numberCorrect;
  final double numberIncorrect;
  final Color correctPrimaryColor;
  final Color correctSecondaryColor;
  final Color incorrectPrimaryColor;
  final Color incorrectSecondaryColor;

  SummaryWidget({
    required this.timeTaken,
    required this.numberCorrect,
    required this.numberIncorrect,
    required this.correctPrimaryColor,
    required this.correctSecondaryColor,
    required this.incorrectPrimaryColor,
    required this.incorrectSecondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    double total = numberCorrect + numberIncorrect;

    // Calculate percentages
    double correctPercentage = (total > 0) ? (numberCorrect / total) : 0;

    return Center( 
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 400, 
        ),
        child: Container(
          padding: const EdgeInsets.all(20), 
          decoration: BoxDecoration(
            color: Color(0xFFF6F7FB), 
            borderRadius: BorderRadius.circular(15), // Curved corners
            border: Border.all(
              color: Colors.grey, // Grey border color
              width: 2, // Border width
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              Text(
                'Completed in ${timeTaken} seconds.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF556385),
                ),
                overflow: TextOverflow.ellipsis, 
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, 
                children: [
                  // Custom circle for correct percentage
                  CustomPaint(
                    size: const Size(100, 100), // Circle size
                    painter: CirclePainter(correctPercentage),
                  ),
                  const SizedBox(width: 30), 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Correct Section
                      Row(
                        mainAxisSize: MainAxisSize.min, 
                        children: [
                          Container(
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
                          SizedBox(width: 10), 

                          ScoreBubble(
                            score: numberCorrect.toInt(),
                            innerColor: correctSecondaryColor,
                            outerColor: correctPrimaryColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20), // Spacer between correct and incorrect rows

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 100, // Fixed width to ensure consistency
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
                          SizedBox(width: 10), // Spacer between label and bubble

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

  CirclePainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundCirclePaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20; // Set stroke width for the background circle

    Paint progressPaint = Paint()
      ..color = const Color(0xFF45ECB1) // Green portion representing correct answers
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20; // Set stroke width for the progress arc

    Paint incompletePaint = Paint()
      ..color = const Color(0xFFF8910B) // Orange portion representing incorrect answers
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20; // Set stroke width for the incomplete arc

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, backgroundCirclePaint);

    double correctAngle = 2 * pi * percentage; // Angle for the green section
    Rect rect = Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2);
    canvas.drawArc(rect, -pi / 2, correctAngle, false, progressPaint); // Draw the arc without filling the middle

    double incorrectAngle = 2 * pi * (1 - percentage);
    canvas.drawArc(rect, -pi / 2 + correctAngle, incorrectAngle, false, incompletePaint); 

    String percentageText = '${(percentage * 100).toStringAsFixed(0)}%';
    TextSpan textSpan = TextSpan(
      text: percentageText,
      style: TextStyle(
        color: const Color(0xFF909BB6), 
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

  ScoreBubble({
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
          width: 3, // Border width
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


