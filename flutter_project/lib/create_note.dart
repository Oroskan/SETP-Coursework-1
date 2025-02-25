import 'package:flutter/material.dart';
import 'theme.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key});

  @override
  CreateNotePageState createState() => CreateNotePageState();
}

class CreateNotePageState extends State<CreateNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool darkMode = false;

  void _saveNote() {
    String title = _titleController.text.trim();
    String subtitle = _subtitleController.text.trim();
    String content = _contentController.text.trim();

    if (title.isEmpty && subtitle.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note cannot be empty')),
      );
      return;
    }

    // Create a Map with non-null values
    Map<String, String> noteData = {
      'title': title.isEmpty ? 'Untitled' : title,
      'subtitle': subtitle.isEmpty ? '' : subtitle,
      'content': content.isEmpty ? '' : content,
    };

    Navigator.pop(context, noteData);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        Navigator.pop(context, null);
      },
      child: Theme(
        data: getTheme(darkMode),
        child: Scaffold(
          backgroundColor: darkMode ? Colors.black87 : Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.purple[300],
            title: const Text("New Note"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, null),
            ),
            actions: [
              TextButton(
                onPressed: _saveNote,
                child:
                    const Text("Done", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          body: Container(
            color: darkMode ? Colors.black87 : const Color(0xFFFAFAFA),
            child: SingleChildScrollView(
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
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Subject',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                    const Divider(height: 32),
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
      ),
    );
  }
}
