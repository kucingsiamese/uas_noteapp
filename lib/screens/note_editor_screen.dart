import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note; // Note bisa null jika membuat catatan baru

  const NoteEditorScreen({this.note, super.key});

  @override
  _NoteEditorScreenState createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;
  late String _category;
  int? _color;
  late DateTime _createdAt;

  @override
  void initState() {
    super.initState();
    // Inisialisasi nilai jika sedang mengedit
    _title = widget.note?.title ?? '';
    _content = widget.note?.content ?? '';
    _category = widget.note?.category ?? 'Others';
    _color = widget.note?.color;
    _createdAt = widget.note?.createdAt ?? DateTime.now();
  }

  Future<void> _saveNote() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Buat objek Note baru berdasarkan input
      final newNote = Note(
        id: widget.note?.id, // ID ada jika sedang mengedit
        title: _title,
        content: _content,
        category: _category,
        color: _color,
        createdAt: _createdAt,
      );

      final notesProvider = Provider.of<NotesProvider>(context, listen: false);

      // Simpan catatan baru atau perbarui yang sudah ada
      if (widget.note == null) {
        await notesProvider.addNote(newNote); // Tambahkan catatan baru
      } else {
        await notesProvider.updateNote(newNote); // Perbarui catatan yang ada
      }

      Navigator.pop(context); // Kembali ke layar sebelumnya
    }
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (value) => _title = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _content,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 5,
                onSaved: (value) => _content = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
