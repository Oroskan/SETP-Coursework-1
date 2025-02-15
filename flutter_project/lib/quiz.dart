

import 'package:flutter/material.dart';

bool answered=false; ///will find a work around for this

class QuizScreen extends StatefulWidget {

  final Color cardColor;
  final Color backgroundColor;
  final completedQuizzes;

  QuizScreen({

    required this.backgroundColor,
    required this.cardColor,
    required this.completedQuizzes,});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {

  List<MultipleChoice> questions = [
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
];


  int currentQuestionIndex = 0;

  void skipQuestion() {
    answered=false;
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        // Handle the end of the quiz
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Quiz Completed'),
            content: Text('You have finished the quiz!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),


                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  }

  void answerQuestion(int index) {
    MultipleChoice currentQuestion = questions[currentQuestionIndex];

    if (currentQuestion.choices[index] == currentQuestion.answer) {
      print('Correct!');
    } else {
      print('Incorrect!');
    }
  }

  @override
  Widget build(BuildContext context) {
    MultipleChoice currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        backgroundColor: widget.backgroundColor,

        leading: IconButton(
          onPressed: () {

            if(currentQuestionIndex==questions.length-1){
              Navigator.pop(context, widget.completedQuizzes+1);
            }
            else{
              Navigator.pop(context, widget.completedQuizzes);
            }
          },
          icon: Icon(Icons.close),
        ),
        title: SizedBox(
          height: 20,
          child: CurvedProgressBar(
            percentage: currentQuestionIndex / questions.length,
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
                    isCorrect: currentQuestion.choices[i] == currentQuestion.answer,
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

class MultipleChoice {
  final String question;
  final List<String> choices;
  final String answer;

  MultipleChoice({required this.question, required this.choices, required this.answer});
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
      answered = true;  // Mark as answered
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

  CurvedProgressBar({required  this.percentage});

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
