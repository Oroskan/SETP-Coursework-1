
// multipleChoice
// textAnswer
// trueFalse
// fillInTheBlank


import 'package:flutter/material.dart';
import 'dart:math';

//renders the logical component
class MultipleChoiceWidget {

  

  final MultipleChoice multipleChoice;

  MultipleChoiceWidget({this.multipleChoice});


  correctIndex = Random().nextInt(multipleChoice.choices.length);



  return Widget;
} 

//logical component of quesiton
class MultipleChoice{

  final String question;
  final List<String> choices;
  final String answer;

  MultipleChoice({this.question, this.choices, this.answer});

} 




// class TextAnswer {

// }

// class TrueFalse {

// }

// class FillInTheBlank {

// }