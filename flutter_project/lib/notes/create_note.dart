import 'package:flutter/material.dart';
import '../theme.dart';
import 'note.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key});

  @override
  CreateNotePageState createState() => CreateNotePageState();
}

class CreateNotePageState extends State<CreateNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _saveNote() {
    String title = _titleController.text.trim();
    String subject = _subtitleController.text.trim();
    String content = _contentController.text.trim();

    if (title.isEmpty && subject.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note cannot be empty')),
      );
      return;
    }

    Note note = Note(
      title: title.isEmpty ? 'Untitled' : title,
      subject: subject,
      content: content,
    );

    Navigator.pop(context, note);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: darkModeNotifier,
        builder: (context, isDarkMode, _) {
          final theme = getTheme(isDarkMode);

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, [result]) async {
              if (didPop) return;
              Navigator.pop(context, null);
            },
            child: Theme(
              data: theme,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text("New Note"),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context, null),
                  ),
                  actions: [
                    TextButton(
                      onPressed: _saveNote,
                      child: Text("Done",
                          style: TextStyle(color: theme.colorScheme.onPrimary)),
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _titleController,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Title',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                        TextField(
                          controller: _subtitleController,
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                            fontStyle: FontStyle.italic,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Subject',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                        Divider(
                          height: 32,
                          color: theme.dividerTheme.color,
                          thickness: theme.dividerTheme.thickness,
                        ),
                        TextField(
                          controller: _contentController,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Start typing your note...',
                            border: InputBorder.none,
                          ),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
