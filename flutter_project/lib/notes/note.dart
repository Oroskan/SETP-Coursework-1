import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String subject;

  @HiveField(2)
  String content;

  Note({
    required this.title,
    required this.subject,
    required this.content,
  });

  Note copyWith({
    String? title,
    String? subject,
    String? content,
  }) {
    return Note(
      title: title ?? this.title,
      subject: subject ?? this.subject,
      content: content ?? this.content,
    );
  }
}
