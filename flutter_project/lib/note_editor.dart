import 'package:flutter/material.dart';
import 'theme.dart';

class NoteEditorPage extends StatefulWidget {
  final String initialTitle;
  final String initialSubject;
  final String initialContent;
  final int noteIndex;

  const NoteEditorPage({
    super.key,
    required this.initialTitle,
    required this.initialSubject,
    required this.initialContent,
    required this.noteIndex,
  });

  @override
  NoteEditorPageState createState() => NoteEditorPageState();
}

class NoteEditorPageState extends State<NoteEditorPage> {
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _contentController;
  bool _hasUnsavedChanges = false;
  bool darkMode = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _subtitleController = TextEditingController(text: widget.initialSubject);
    _contentController = TextEditingController(text: widget.initialContent);

    _titleController.addListener(_markAsUnsaved);
    _subtitleController.addListener(_markAsUnsaved);
    _contentController.addListener(_markAsUnsaved);
  }

  void _markAsUnsaved() {
    setState(() => _hasUnsavedChanges = true);
  }

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

    Navigator.pop(context, {
      'noteIndex': widget.noteIndex,
      'title': title.isEmpty ? 'Untitled' : title,
      'subject': subject,
      'content': content,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: getTheme(darkMode),
      child: PopScope(
        canPop: !_hasUnsavedChanges,
        onPopInvoked: (didPop) async {
          if (didPop) return;

          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Unsaved Changes'),
              content: const Text('Do you want to save your changes?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    _saveNote();
                  },
                  child: const Text('Save'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Discard'),
                ),
              ],
            ),
          );

          if (shouldPop ?? false) {
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.purple[300],
            title: const Text('Edit Note'),
            actions: [
              TextButton(
                onPressed: _saveNote,
                child:
                    const Text('Save', style: TextStyle(color: Colors.white)),
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
                    labelText: 'Topic',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _subtitleController,
                  decoration: const InputDecoration(
                    labelText: 'Subject',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      labelText: 'Content',
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

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
