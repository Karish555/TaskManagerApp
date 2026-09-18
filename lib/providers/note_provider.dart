import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/note_service.dart';

class NoteProvider extends ChangeNotifier {
  final NoteService _noteService;
  List<Note> _notes = [];
  bool _loading = false;
  String? _error;

  NoteProvider(this._noteService);

  List<Note> get notes => List.unmodifiable(_notes);
  bool get isLoading => _loading;
  String? get error => _error;

  void watchNotes() {
    _noteService.watchNotes().listen((notes) {
      _notes = notes;
      _error = null;
      notifyListeners();
    }, onError: (Object error) {
      _error = error.toString();
      notifyListeners();
    });
  }

  Future<void> addNote(Note note) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _noteService.addNote(note);
    } catch (error) {
      _error = error.toString();
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> updateNote(Note note) async {
    _error = null;
    try {
      await _noteService.updateNote(note);
    } catch (error) {
      _error = error.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteNote(String noteId) async {
    _error = null;
    try {
      await _noteService.deleteNote(noteId);
    } catch (error) {
      _error = error.toString();
      notifyListeners();
      rethrow;
    }
  }
}
