import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/note.dart';
import '../models/task.dart';

class NotesProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Note> _notes = [];
  List<Task> _tasks = [];
  String? _userId;

  List<Note> get notes => _notes;
  List<Task> get tasks => _tasks;
  String? get userId => _userId;

  void setUserId(String userId) {
    _userId = userId;
    fetchNotes();
    fetchTasks();
  }

  Future<void> fetchNotes() async {
    if (_userId == null) return;

    final querySnapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('notes')
        .get();

    _notes = querySnapshot.docs
        .map((doc) => Note.fromFirestore(doc.data(), doc.id))
        .toList();
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    if (_userId == null) return;

    final docRef = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('notes')
        .add(note.toMap());

    note.id = docRef.id;
    _notes.add(note);
    notifyListeners();
  }

  Future<void> updateNote(Note note) async {
    if (_userId == null || note.id == null) return;

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('notes')
        .doc(note.id)
        .update(note.toMap());

    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes[index] = note;
      notifyListeners();
    }
  }

  Future<void> deleteNote(String noteId) async {
    if (_userId == null) return;

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('notes')
        .doc(noteId)
        .delete();

    _notes.removeWhere((note) => note.id == noteId);
    notifyListeners();
  }

  Future<void> fetchTasks() async {
    if (_userId == null) return;

    final querySnapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('tasks')
        .get();

    _tasks = querySnapshot.docs
        .map((doc) => Task.fromFirestore(doc.data(), doc.id))
        .toList();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    if (_userId == null) return;

    final docRef = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('tasks')
        .add(task.toMap());

    task.id = docRef.id;
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    if (_userId == null || task.id == null) return;

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('tasks')
        .doc(task.id)
        .update(task.toMap());

    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  Future<void> deleteTask(String taskId) async {
    if (_userId == null) return;

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('tasks')
        .doc(taskId)
        .delete();

    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  void searchNotes(String query) {
    _notes = _notes
        .where((note) => note.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }
}
