import 'package:flutter/material.dart';
import 'theme.dart';

class CreateNotePage extends StatefulWidget {
  @override
  _CreateNotePageState createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
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
        SnackBar(content: Text('Note cannot be empty')),
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, null);
        return false;
      },
      child: Theme(
        data: getTheme(darkMode),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.purple[300],
            title: Text("New Note"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, null),
            ),
            actions: [
              TextButton(
                onPressed: _saveNote,
                child: Text("Done", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Topic",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _subtitleController,
                  decoration: InputDecoration(
                    labelText: "Subject",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    decoration: InputDecoration(
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
