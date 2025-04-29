import 'package:flutter_test/flutter_test.dart';
import 'package:e/notes/note.dart';

void main() {
  // Group tests related to the Note class
  group('Note Class Tests', () {
    // Test case 1: Verify that a Note object can be created correctly
    test('Note object should be created with correct properties', () {
      // Arrange: Define the input values
      const title = 'Test Title';
      const subject = 'Test Subject';
      const content = 'Test Content';

      // Act: Create the Note instance
      final note = Note(
        title: title,
        subject: subject,
        content: content,
      );

      // Assert: Check if the properties match the input values
      expect(note.title, equals(title));
      expect(note.subject, equals(subject));
      expect(note.content, equals(content));
      // Note extends HiveObject, so it might have other properties or methods
      // inherited, but we focus on the ones defined in the class itself for unit tests.
    });

    // Test case 2: Verify the copyWith method creates a copy with updated title
    test('copyWith should update title correctly', () {
      // Arrange: Create an initial Note object
      final originalNote = Note(
        title: 'Original Title',
        subject: 'Original Subject',
        content: 'Original Content',
      );
      const newTitle = 'Updated Title';

      // Act: Use copyWith to update the title
      final updatedNote = originalNote.copyWith(title: newTitle);

      // Assert: Check if the new note has the updated title and original other fields
      expect(updatedNote.title, equals(newTitle));
      expect(updatedNote.subject, equals(originalNote.subject));
      expect(updatedNote.content, equals(originalNote.content));
      // Ensure the original note wasn't modified
      expect(originalNote.title, isNot(equals(newTitle)));
    });

    // Test case 3: Verify the copyWith method creates a copy with updated subject
    test('copyWith should update subject correctly', () {
      // Arrange
      final originalNote = Note(
        title: 'Original Title',
        subject: 'Original Subject',
        content: 'Original Content',
      );
      const newSubject = 'Updated Subject';

      // Act
      final updatedNote = originalNote.copyWith(subject: newSubject);

      // Assert
      expect(updatedNote.title, equals(originalNote.title));
      expect(updatedNote.subject, equals(newSubject));
      expect(updatedNote.content, equals(originalNote.content));
      expect(originalNote.subject, isNot(equals(newSubject)));
    });

    // Test case 4: Verify the copyWith method creates a copy with updated content
    test('copyWith should update content correctly', () {
      // Arrange
      final originalNote = Note(
        title: 'Original Title',
        subject: 'Original Subject',
        content: 'Original Content',
      );
      const newContent = 'Updated Content';

      // Act
      final updatedNote = originalNote.copyWith(content: newContent);

      // Assert
      expect(updatedNote.title, equals(originalNote.title));
      expect(updatedNote.subject, equals(originalNote.subject));
      expect(updatedNote.content, equals(newContent));
      expect(originalNote.content, isNot(equals(newContent)));
    });

    // Test case 5: Verify copyWith works when updating multiple fields
    test('copyWith should update multiple fields correctly', () {
      // Arrange
      final originalNote = Note(
        title: 'Title 1',
        subject: 'Subject 1',
        content: 'Content 1',
      );
      const newTitle = 'Title 2';
      const newContent = 'Content 2';

      // Act
      final updatedNote = originalNote.copyWith(
        title: newTitle,
        content: newContent,
      );

      // Assert
      expect(updatedNote.title, equals(newTitle));
      expect(updatedNote.subject,
          equals(originalNote.subject)); // Subject should remain unchanged
      expect(updatedNote.content, equals(newContent));
    });

    // Test case 6: Verify copyWith returns an identical object if no parameters are provided
    test('copyWith should return identical object when no fields are updated',
        () {
      // Arrange
      final originalNote = Note(
        title: 'Same Title',
        subject: 'Same Subject',
        content: 'Same Content',
      );

      // Act: Call copyWith without arguments
      final updatedNote = originalNote.copyWith();

      // Assert: Check if all fields are identical
      expect(updatedNote.title, equals(originalNote.title));
      expect(updatedNote.subject, equals(originalNote.subject));
      expect(updatedNote.content, equals(originalNote.content));
      // Optionally, check if they are different instances but equal value
      // expect(identical(originalNote, updatedNote), isFalse); // This depends on the implementation details of copyWith
      expect(
          updatedNote,
          equals(
              originalNote)); // If Note implements == operator correctly based on values
    });
  });
}
