import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class NotesProvider extends ChangeNotifier {
  final CollectionReference _notesCollection =
      FirebaseFirestore.instance.collection('notes');

  List<Note> _notes = [];
  List<Note> get notes => _notes;

  Future<void> fetchNotes(String userId) async {
    final snapshot =
        await _notesCollection.where('userId', isEqualTo: userId).get();
    _notes = snapshot.docs
        .map((doc) =>
            Note.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    final doc = await _notesCollection.add(note.toMap());
    note.id = doc.id;
    _notes.add(note);
    notifyListeners();
  }

  Future<void> updateNote(Note note) async {
    await _notesCollection.doc(note.id).update(note.toMap());
    final index = _notes.indexWhere((n) => n.id == note.id);
    _notes[index] = note;
    notifyListeners();
  }

  Future<void> deleteNote(String id) async {
    await _notesCollection.doc(id).delete();
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}
