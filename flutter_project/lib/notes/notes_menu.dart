import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../home.dart';
import '../quiz_menu.dart';
import '../theme.dart';
import 'create_note.dart';
import '../settings_menu.dart';
import 'note_editor.dart';
import 'note.dart';

class NotesMenu extends StatefulWidget {
  const NotesMenu({super.key});

  @override
  State<NotesMenu> createState() => _NotesMenuState();
}

class _NotesMenuState extends State<NotesMenu> {
  final int _selectedIndex = 2;
  bool darkMode = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late Box<Note> notesBox;

  @override
  void initState() {
    super.initState();
    notesBox = Hive.box<Note>('notes');

    if (notesBox.isEmpty) {
      _populateSampleNotes();
    }
  }

  void _populateSampleNotes() {
    final sampleNotes = [
      Note(
          title: 'Introduction to Atomic Structure',
          subject: 'Chemistry',
          content: ''),
      Note(title: 'Understanding Gravity', subject: 'Physics', content: ''),
      Note(title: 'Basics of Genetics', subject: 'Biology', content: ''),
      Note(
          title: 'Data Structures Overview',
          subject: 'Computer Science',
          content: ''),
      Note(title: 'Calculus Fundamentals', subject: 'Mathematics', content: ''),
      Note(title: 'Advanced Grammar', subject: 'English', content: ''),
      Note(title: 'Medieval History', subject: 'History', content: ''),
      Note(title: 'Climate Patterns', subject: 'Geography', content: ''),
      Note(title: 'Market Economics', subject: 'Economics', content: ''),
      Note(title: 'Human Behavior', subject: 'Psychology', content: ''),
      Note(title: 'Social Structures', subject: 'Sociology', content: ''),
    ];

    for (var note in sampleNotes) {
      notesBox.add(note);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Note> get filteredNotes {
    if (_searchQuery.isEmpty) {
      return notesBox.values.toList();
    }
    return notesBox.values.where((note) {
      final title = note.title.toLowerCase();
      final subject = note.subject.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return title.contains(query) || subject.contains(query);
    }).toList();
  }

  void _addNewNote() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateNotePage()),
    );

    if (result != null && result is Note) {
      setState(() {
        notesBox.add(result);
      });
    }
  }

  void _deleteNote(int index) {
    setState(() {
      final note = filteredNotes[index];
      note.delete();
    });
  }

  Future<bool> _confirmDelete() async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Delete Note'),
            content: const Text('Are you sure you want to delete this note?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: getTheme(darkMode),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notes'),
          backgroundColor: Colors.purple[300],
          leading: Builder(
            builder: (context) => IconButton(
              padding: EdgeInsets.zero,
              icon: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/profilepic.jpg'),
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.purple[300],
                ),
                child: const Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsMenu()));
                },
              ),
            ],
          ),
        ),
        body: Container(
          color: Colors.purple[50],
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search notes...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: filteredNotes.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/notfound.webp',
                                height: 200,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'We searched far and wide, but no results were found.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: List.generate(
                              filteredNotes.length,
                              (index) =>
                                  _buildNoteButton(filteredNotes[index], index),
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _buildAddNoteButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: NavigationBar(
          height: 60,
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            } else if (index == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const QuizMenu()),
              );
            }
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.quiz), label: 'Quizzes'),
            NavigationDestination(icon: Icon(Icons.note), label: 'Notes'),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteButton(Note note, int index) {
    return Dismissible(
      key: Key(note.key.toString()),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(),
      onDismissed: (_) => _deleteNote(index),
      background: Container(
        margin: const EdgeInsets.only(top: 16.0),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8.0),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 16.0),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 134, 115, 255),
            padding: const EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteEditorPage(
                  note: note,
                  noteIndex: index,
                ),
              ),
            );
            if (result != null && result is Note) {
              setState(() {
                // Update the note in the box
                final boxIndex = notesBox.values.toList().indexOf(note);
                if (boxIndex >= 0) {
                  notesBox.putAt(boxIndex, result);
                }
              });
            }
          },
          child: Column(
            children: [
              const Icon(Icons.note, color: Colors.white, size: 30),
              const SizedBox(height: 8),
              Text(
                note.title,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                note.subject,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddNoteButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: const EdgeInsets.only(right: 16, bottom: 70),
        height: 64,
        width: 64,
        child: FloatingActionButton(
          onPressed: _addNewNote,
          child: const Text('+', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
