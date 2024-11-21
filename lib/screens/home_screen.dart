import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../models/note.dart';
import '../screens/note_editor_screen.dart';
import '../widgets/note_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  void _onSearch(String query) {
    Provider.of<NotesProvider>(context, listen: false).searchNotes(query);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final notesProvider = Provider.of<NotesProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: _onSearch,
              decoration: const InputDecoration(
                labelText: 'Search notes',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notesProvider.notes.length,
              itemBuilder: (context, index) {
                final note = notesProvider.notes[index];
                return NoteItem(note: note);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NoteEditorScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
