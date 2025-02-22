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
        if (didPop) {
          return;
        }
        Navigator.pop(context, null);
      },
      child: Theme(
        data: getTheme(darkMode),
        child: Scaffold(
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
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "Topic",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _subtitleController,
                  decoration: const InputDecoration(
                    labelText: "Subject",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      labelText: "Content",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}