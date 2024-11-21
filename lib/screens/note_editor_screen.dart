import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;

  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class Note {
  final String? id;
  final String userId;
  final String title;
  final String content;
  final String category;
  final Color color;

  Note({
    this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.category = 'Others', // Nilai default untuk category
    required this.color,
  });
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String? _selectedCategory;
  Color _selectedColor = Colors.white;

  final List<String> _categories = ['Personal', 'Work', 'Study', 'Others'];
  final List<Color> _colors = [
    Colors.white,
    Colors.yellow.shade100,
    Colors.green.shade100,
    Colors.blue.shade100,
    Colors.red.shade100,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedCategory = widget.note!.category;
      _selectedColor = widget.note!.color ?? Colors.white;
    }
  }

  void _saveNote() async {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    final userId =
        notesProvider.userId; // Assumes userId is stored in provider.

    if (_titleController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and content cannot be empty.')),
      );
      return;
    }

    final newNote = Note(
      id: widget.note?.id,
      userId: userId!,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      category: _selectedCategory ?? 'Others',
      color: _selectedColor,
    );

    if (widget.note == null) {
      await notesProvider.addNote(newNote);
    } else {
      await notesProvider.updateNote(newNote);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Content',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              onChanged: (value) => setState(() => _selectedCategory = value),
              items: _categories
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 16),
            const Text('Select Background Color:'),
            Wrap(
              spacing: 8.0,
              children: _colors
                  .map(
                    (color) => GestureDetector(
                      onTap: () => setState(() => _selectedColor = color),
                      child: CircleAvatar(
                        backgroundColor: color,
                        radius: 20,
                        child: _selectedColor == color
                            ? const Icon(Icons.check, color: Colors.black)
                            : null,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
