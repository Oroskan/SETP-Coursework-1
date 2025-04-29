import 'package:test/test.dart';
import 'package:e/quiz/quiz.dart';

void main() {
  group('Quiz Data Models', () {
    test('Quiz object creation', () {
      final question1 = QuestionAnswer(question: 'Q1', answer: 'A1'); //
      final question2 = MultipleChoice(
          question: 'Q2', choices: ['A', 'B', 'C'], answer: 'B'); //
      final quiz =
          Quiz(title: 'Test Quiz', questions: [question1, question2]); //

      expect(quiz.title, 'Test Quiz'); //
      expect(quiz.questions.length, 2); //
      expect(quiz.questions[0], isA<QuestionAnswer>()); //
      expect(quiz.questions[1], isA<MultipleChoice>()); //
    });

    test('Question subtypes creation and properties', () {
      final qa =
          QuestionAnswer(question: 'What is Dart?', answer: 'A language'); //
      expect(qa.question, 'What is Dart?'); //
      expect(qa.answer, 'A language'); //
      expect(qa.type, 'Youtube'); //

      final mc = MultipleChoice(
          question: 'Choose B', choices: ['A', 'B', 'C'], answer: 'B'); //
      expect(mc.question, 'Choose B'); //
      expect(mc.choices, ['A', 'B', 'C']); //
      expect(mc.answer, 'B'); //
      expect(mc.type, 'multiple_choice'); //

      final fb = FillInTheBlank(
          question: 'Dart is ___', answer: 'fun', hint: 'Starts with f'); //
      expect(fb.question, 'Dart is ___'); //
      expect(fb.answer, 'fun'); //
      expect(fb.hint, 'Starts with f'); //
      expect(fb.type, 'fill_in_the_blank'); //
    });

    test('Question factory constructor', () {
      final q1 = Question(question: 'QA', type: 'Youtube', answer: 'Ans'); //
      expect(q1, isA<QuestionAnswer>()); //
      expect((q1 as QuestionAnswer).answer, 'Ans'); //

      final q2 = Question(
          question: 'MC',
          type: 'multiple_choice',
          choices: ['1', '2'],
          answer: '1'); //
      expect(q2, isA<MultipleChoice>()); //
      expect((q2 as MultipleChoice).choices, ['1', '2']); //
      expect((q2).answer, '1'); //

      final q3 = Question(
          question: 'FB',
          type: 'fill_in_the_blank',
          answer: 'Blank',
          hint: 'h'); //
      expect(q3, isA<FillInTheBlank>()); //
      expect((q3 as FillInTheBlank).answer, 'Blank'); //
      expect((q3).hint, 'h'); //
    });
  });
}
