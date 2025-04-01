// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuizAdapter extends TypeAdapter<Quiz> {
  @override
  final int typeId = 6;

  @override
  Quiz read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Quiz(
      title: fields[0] as String,
      questions: (fields[1] as List).cast<Question>(),
    );
  }

  @override
  void write(BinaryWriter writer, Quiz obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.questions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuestionAdapter extends TypeAdapter<Question> {
  @override
  final int typeId = 7;

  @override
  Question read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Question(
      question: fields[0] as String,
      type: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Question obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.question)
      ..writeByte(1)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MultipleChoiceAdapter extends TypeAdapter<MultipleChoice> {
  @override
  final int typeId = 8;

  @override
  MultipleChoice read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MultipleChoice(
      question: fields[0] as String,
      choices: (fields[2] as List).cast<String>(),
      answer: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MultipleChoice obj) {
    writer
      ..writeByte(3)
      ..writeByte(2)
      ..write(obj.choices)
      ..writeByte(3)
      ..write(obj.answer)
      ..writeByte(0)
      ..write(obj.question);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MultipleChoiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuestionAnswerAdapter extends TypeAdapter<QuestionAnswer> {
  @override
  final int typeId = 9;

  @override
  QuestionAnswer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuestionAnswer(
      question: fields[0] as String,
      answer: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, QuestionAnswer obj) {
    writer
      ..writeByte(2)
      ..writeByte(2)
      ..write(obj.answer)
      ..writeByte(0)
      ..write(obj.question);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionAnswerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FillInTheBlankAdapter extends TypeAdapter<FillInTheBlank> {
  @override
  final int typeId = 10;

  @override
  FillInTheBlank read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FillInTheBlank(
      question: fields[0] as String,
      answer: fields[2] as String,
      hint: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FillInTheBlank obj) {
    writer
      ..writeByte(3)
      ..writeByte(2)
      ..write(obj.answer)
      ..writeByte(3)
      ..write(obj.hint)
      ..writeByte(0)
      ..write(obj.question);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FillInTheBlankAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
