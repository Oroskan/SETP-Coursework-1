import 'package:test/test.dart';
import 'package:e/notes/note.dart';

void main() {
  group('Note Class Tests', () {
    test('Constructor should initialize fields correctly', () {
      const title = 'Test Title';
      const subject = 'Test Subject';
      const content = 'Test Content';

      final note = Note(title: title, subject: subject, content: content);

      expect(note.title, equals(title));
      expect(note.subject, equals(subject));
      expect(note.content, equals(content));
    });

    test('copyWith should create a new instance with updated values', () {
      final originalNote = Note(
        title: 'Original Title',
        subject: 'Original Subject',
        content: 'Original Content',
      );
      const newTitle = 'New Title';
      const newSubject = 'New Subject';
      const newContent = 'New Content';

      final copiedNote = originalNote.copyWith(
        title: newTitle,
        subject: newSubject,
        content: newContent,
      );

      expect(copiedNote.title, equals(newTitle));
      expect(copiedNote.subject, equals(newSubject));
      expect(copiedNote.content, equals(newContent));

      expect(originalNote.title, equals('Original Title'));
      expect(originalNote.subject, equals('Original Subject'));
      expect(originalNote.content, equals('Original Content'));

      expect(copiedNote, isNot(same(originalNote)));
    });

    test('copyWith should create a new instance with partially updated values',
        () {
      final originalNote = Note(
        title: 'Original Title',
        subject: 'Original Subject',
        content: 'Original Content',
      );
      const newTitle = 'Updated Title Only';

      final copiedNote = originalNote.copyWith(title: newTitle);
      expect(copiedNote.title, equals(newTitle));
      expect(copiedNote.subject, equals('Original Subject'));
      expect(copiedNote.content, equals('Original Content'));
      expect(originalNote.title, equals('Original Title'));
      expect(copiedNote, isNot(same(originalNote)));
    });

    test('copyWith should create an identical copy if no values are provided',
        () {
      final originalNote = Note(
        title: 'Original Title',
        subject: 'Original Subject',
        content: 'Original Content',
      );
      final copiedNote = originalNote.copyWith();
      expect(copiedNote.title, equals('Original Title'));
      expect(copiedNote.subject, equals('Original Subject'));
      expect(copiedNote.content, equals('Original Content'));
      expect(originalNote.title, equals('Original Title'));
      expect(copiedNote, isNot(same(originalNote)));
      expect(copiedNote.title, originalNote.title);
      expect(copiedNote.subject, originalNote.subject);
      expect(copiedNote.content, originalNote.content);
    });
  });
}
