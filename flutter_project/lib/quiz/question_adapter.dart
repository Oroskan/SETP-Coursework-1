import 'package:hive/hive.dart';
import 'quiz.dart';

class CustomQuestionAdapter extends TypeAdapter<Question> {
  @override
  final int typeId = 1;

  @override
  Question read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    final type = fields[1] as String;
    final question = fields[0] as String;

    switch (type) {
      case 'multiple_choice':
        return MultipleChoice(
          question: question,
          choices: (fields[2] as List).cast<String>(),
          answer: fields[3] as String,
        );
      case 'question_answer':
        return QuestionAnswer(
          question: question,
          answer: fields[2] as String,
        );
      case 'fill_in_the_blank':
        return FillInTheBlank(
          question: question,
          answer: fields[2] as String,
          hint: fields[3] as String,
        );
      default:
        throw Exception('Unknown question type: $type');
    }
  }

  @override
  void write(BinaryWriter writer, Question obj) {
    if (obj is MultipleChoice) {
      writer
        ..writeByte(4)
        ..writeByte(0)
        ..write(obj.question)
        ..writeByte(1)
        ..write(obj.type)
        ..writeByte(2)
        ..write(obj.choices)
        ..writeByte(3)
        ..write(obj.answer);
    } else if (obj is QuestionAnswer) {
      writer
        ..writeByte(3)
        ..writeByte(0)
        ..write(obj.question)
        ..writeByte(1)
        ..write(obj.type)
        ..writeByte(2)
        ..write(obj.answer);
    } else if (obj is FillInTheBlank) {
      writer
        ..writeByte(4)
        ..writeByte(0)
        ..write(obj.question)
        ..writeByte(1)
        ..write(obj.type)
        ..writeByte(2)
        ..write(obj.answer)
        ..writeByte(3)
        ..write(obj.hint);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomQuestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
