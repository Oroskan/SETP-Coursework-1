import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../theme.dart';

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

  void _shareNote() {
    String title = _titleController.text.trim();
    String subject = _subtitleController.text.trim();
    String content = _contentController.text.trim();

    if (title.isEmpty && subject.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note is empty, cannot share')),
      );
      return;
    }

    String shareText =
        "Title: $title\n\nSubject: $subject\n\nContent: $content";
    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: getTheme(darkMode),
      child: PopScope(
        canPop: !_hasUnsavedChanges,
        onPopInvokedWithResult: (didPop, [result]) async {
          if (didPop) return;

          await showDialog<bool>(
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
        },
        child: Scaffold(
          backgroundColor: darkMode ? Colors.black87 : Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.purple[300],
            title: const Text('Edit Note'),
            actions: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: _shareNote,
              ),
              TextButton(
                onPressed: _saveNote,
                child:
                    const Text('Save', style: TextStyle(color: Colors.white)),
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

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
