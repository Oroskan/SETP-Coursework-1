import 'package:hive/hive.dart';
part 'quiz.g.dart';

@HiveType(typeId: 6)
class Quiz extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late List<Question> questions;

  Quiz({this.title = "", required this.questions});
}

@HiveType(typeId: 7)
class Question {
  @HiveField(0)
  late String question;

  @HiveField(1)
  String type = 'base';

  // Factory constructor to handle creating the appropriate subtype
  factory Question(
      {required String question,
      String? type,
      List<String>? choices,
      String? answer,
      String? hint}) {
    if (type == 'multiple_choice' && choices != null && answer != null) {
      return MultipleChoice(
          question: question, choices: choices, answer: answer);
    } else if (type == 'question_answer' && answer != null) {
      return QuestionAnswer(question: question, answer: answer);
    } else if (type == 'fill_in_the_blank' && answer != null) {
      return FillInTheBlank(
          question: question, answer: answer, hint: hint ?? "");
    } else {
      // This should not happen in normal operation
      Question q = Question._internal();
      q.question = question;
      return q;
    }
  }

  // Internal constructor for the base class
  Question._internal();

  // Constructor for subclasses to use
  Question.fromSubclass({required this.question});
}

@HiveType(typeId: 8)
class MultipleChoice extends Question {
  @HiveField(2)
  late List<String> choices;

  @HiveField(3)
  late String answer;

  @override
  String get type => 'multiple_choice';

  @override
  set type(String _) {} // Setter to satisfy Hive, but do nothing

  MultipleChoice(
      {required super.question, required this.choices, required this.answer})
      : super.fromSubclass() {
    type = 'multiple_choice'; // Set the type for serialization
  }
}

@HiveType(typeId: 9)
class QuestionAnswer extends Question {
  @HiveField(2)
  late String answer;

  @override
  String get type => 'question_answer';

  @override
  set type(String _) {} // Setter to satisfy Hive, but do nothing

  QuestionAnswer({required super.question, required this.answer})
      : super.fromSubclass() {
    type = 'question_answer'; // Set the type for serialization
  }
}

@HiveType(typeId: 10)
class FillInTheBlank extends Question {
  @HiveField(2)
  late String answer;

  @HiveField(3)
  late String hint;

  @override
  String get type => 'fill_in_the_blank';

  @override
  set type(String _) {} // Setter to satisfy Hive, but do nothing

  FillInTheBlank(
      {required super.question, required this.answer, this.hint = ""})
      : super.fromSubclass() {
    type = 'fill_in_the_blank'; // Set the type for serialization
  }
}
