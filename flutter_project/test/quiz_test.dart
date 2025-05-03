import 'package:test/test.dart';
import 'package:e/quiz/quiz.dart';

void main() {
  group('Quiz Class Tests', () {
    test('Constructor should initialize fields correctly', () {
      const title = 'My Quiz';
      final questions = [
        MultipleChoice(
            question: 'What continent is Hungary in?',
            choices: ['Europe', 'Asia', 'Africa'],
            answer: 'Europe'),
        QuestionAnswer(question: 'Who created macOS?', answer: 'Apple'),
      ];

      final quiz = Quiz(title: title, questions: questions);

      expect(quiz.title, equals(title));
      expect(quiz.questions, equals(questions));
      expect(quiz.questions.length, equals(2));
    });

    test('Constructor should use default title if not provided', () {
      final questions = [
        QuestionAnswer(question: 'What country is Mumbai in?', answer: 'India'),
      ];

      final quiz = Quiz(questions: questions);

      expect(quiz.title, equals(""));
      expect(quiz.questions, equals(questions));
    });
  });

  group('Question Factory Tests', () {
    test('Factory should create MultipleChoice question correctly', () {
      const qText = 'Select the capital of France';
      final choices = ['London', 'Paris', 'Berlin'];
      const answer = 'Paris';

      final question = Question(
        question: qText,
        type: 'multiple_choice',
        choices: choices,
        answer: answer,
      );

      expect(question, isA<MultipleChoice>());
      expect(question.question, equals(qText));
      expect((question as MultipleChoice).choices, equals(choices));
      expect(question.answer, equals(answer));
      expect(question.type, equals('multiple_choice'));
    });

    test('Factory should create QuestionAnswer question correctly', () {
      const qText = 'What is 2 + 2?';
      const answer = '4';

      final question = Question(
        question: qText,
        type: 'question_answer',
        answer: answer,
      );

      expect(question, isA<QuestionAnswer>(),
          reason: "Factory did not return QuestionAnswer instance.");

      expect(question.question, equals(qText));
      expect((question as QuestionAnswer).answer, equals(answer));
      expect(question.type, equals('question_answer'));
    });

    test('Factory should create FillInTheBlank question correctly with hint',
        () {
      const qText = 'The ______ code was cracked by Alan Turing.';
      const answer = 'Enigma';
      const hint = 'It was a German cipher machine used during WW2.';

      final question = Question(
        question: qText,
        type: 'fill_in_the_blank',
        answer: answer,
        hint: hint,
      );

      expect(question, isA<FillInTheBlank>());
      expect(question.question, equals(qText));
      expect((question as FillInTheBlank).answer, equals(answer));
      expect(question.hint, equals(hint));
      expect(question.type, equals('fill_in_the_blank'));
    });

    test('Factory should create FillInTheBlank question correctly without hint',
        () {
      const qText =
          'The American commander during the Korean war was General Douglas _____';
      const answer = 'MacArthur';

      final question = Question(
        question: qText,
        type: 'fill_in_the_blank',
        answer: answer,
      );

      expect(question, isA<FillInTheBlank>());
      expect(question.question, equals(qText));
      expect((question as FillInTheBlank).answer, equals(answer));
      expect(question.hint, equals(""));
      expect(question.type, equals('fill_in_the_blank'));
    });

    test('Factory should handle unspecified type (fallback case)', () {
      const qText = 'A base question';
      final question = Question(
        question: qText,
      );

      expect(question, isA<Question>());
      expect(question, isNot(isA<MultipleChoice>()));
      expect(question, isNot(isA<QuestionAnswer>()));
      expect(question, isNot(isA<FillInTheBlank>()));
      expect(question.question, equals(qText));
      expect(question.type, equals('base'));
    });
  });

  group('MultipleChoice Class Tests', () {
    test('Constructor initializes fields correctly and sets type', () {
      const qText = 'Which of these countries is not in Asia?';
      final choices = ['India', 'Qatar', 'China', 'Venezuela'];
      const answer = 'Venezuela';

      final mcQuestion = MultipleChoice(
        question: qText,
        choices: choices,
        answer: answer,
      );

      expect(mcQuestion.question, equals(qText));
      expect(mcQuestion.choices, equals(choices));
      expect(mcQuestion.answer, equals(answer));
      expect(mcQuestion.type, equals('multiple_choice'));
    });
  });

  group('QuestionAnswer Class Tests', () {
    test('Constructor initializes fields correctly and sets type', () {
      const qText = 'What country is Gnocchi from?';
      const answer = 'Italy';

      final qaQuestion = QuestionAnswer(
        question: qText,
        answer: answer,
      );

      expect(qaQuestion.question, equals(qText));
      expect(qaQuestion.answer, equals(answer));
      expect(qaQuestion.type, equals('question_answer'));
    });
  });

  group('FillInTheBlank Class Tests', () {
    test('Constructor initializes fields correctly with hint and sets type',
        () {
      const qText =
          'The Latin phrase ____ __ ___ refers to an exchange of goods or services.';
      const answer = 'quid pro quo';
      const hint = 'It literally means "something for something".';

      final fitbQuestion = FillInTheBlank(
        question: qText,
        answer: answer,
        hint: hint,
      );

      expect(fitbQuestion.question, equals(qText));
      expect(fitbQuestion.answer, equals(answer));
      expect(fitbQuestion.hint, equals(hint));
      expect(fitbQuestion.type, equals('fill_in_the_blank'));
    });

    test('Constructor initializes fields correctly without hint and sets type',
        () {
      const qText = 'Genghis Khan was the founder of the ____ Empire.';
      const answer = 'Mongol';

      final fitbQuestion = FillInTheBlank(
        question: qText,
        answer: answer,
      );

      expect(fitbQuestion.question, equals(qText));
      expect(fitbQuestion.answer, equals(answer));
      expect(fitbQuestion.hint, equals(""));
      expect(fitbQuestion.type, equals('fill_in_the_blank'));
    });
  });
}
