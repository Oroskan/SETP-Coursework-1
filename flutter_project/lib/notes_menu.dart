import 'package:flutter/material.dart';
import 'home.dart';
import 'quiz_menu.dart';
import 'theme.dart';
import 'create_note.dart';
import 'settings_menu.dart';

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

  List<Map<String, String>> notes = [
    {
      'title': 'Introduction to Atomic Structure',
      'subject': 'Chemistry',
      'content': ''
    },
    {'title': 'Understanding Gravity', 'subject': 'Physics', 'content': ''},
    {'title': 'Basics of Genetics', 'subject': 'Biology', 'content': ''},
    {
      'title': 'Data Structures Overview',
      'subject': 'Computer Science',
      'content': ''
    },
    {'title': 'Calculus Fundamentals', 'subject': 'Mathematics', 'content': ''},
    {'title': 'Advanced Grammar', 'subject': 'English', 'content': ''},
    {'title': 'Medieval History', 'subject': 'History', 'content': ''},
    {'title': 'Climate Patterns', 'subject': 'Geography', 'content': ''},
    {'title': 'Market Economics', 'subject': 'Economics', 'content': ''},
    {'title': 'Human Behavior', 'subject': 'Psychology', 'content': ''},
    {'title': 'Social Structures', 'subject': 'Sociology', 'content': ''},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get filteredNotes {
    if (_searchQuery.isEmpty) return notes;
    return notes.where((note) {
      final title = note['title']!.toLowerCase();
      final subject = note['subject']!.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return title.contains(query) || subject.contains(query);
    }).toList();
  }

  void _addNewNote() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateNotePage()),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        notes.add({
          'title': result['title'] ?? 'Untitled',
          'subject': result['subtitle'] ?? '',
          'content': result['content'] ?? '',
        });
      });
    }
  }

  void _deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
    });
  }

  Future<bool> _confirmDelete() async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Note'),
              content: const Text('Are you sure you want to delete this note?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsMenu()));
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
                            children: filteredNotes
                                .map((note) => _buildNoteButton(note))
                                .toList(),
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

  Widget _buildNoteButton(Map<String, String> note) {
    final index = notes.indexOf(note);
    return Dismissible(
      key: Key(note['title']!),
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
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 134, 115, 255),
                  padding: const EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context,
                      '/notes/${note['subject']?.toLowerCase().replaceAll(' ', '_')}/${note['title']?.toLowerCase().replaceAll(' ', '_')}');
                },
                child: Column(
                  children: [
                    const Icon(Icons.note, color: Colors.white, size: 30),
                    const SizedBox(height: 8),
                    Text(
                      note['title']!,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      note['subject']!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ), 
              ),
            ),
            IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/edit_note',
                arguments: note,
              );
            },
          ),
          ],
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
