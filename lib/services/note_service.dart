import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note.dart';

class NoteService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  NoteService({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Query<Map<String, dynamic>> get _notes {
    final user = _auth.currentUser;
    if (user == null) throw StateError('You must be signed in to view notes.');
    return _firestore.collection('notes').where('uid', isEqualTo: user.uid);
  }

  Stream<List<Note>> watchNotes() {
    // Keep the query to a single where clause so a composite Firestore index
    // is not required. Sorting locally produces the same user experience.
    return _notes.snapshots().map((snapshot) {
      final notes = snapshot.docs
          .map((doc) => Note.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
      notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return notes;
    });
  }

  Future<void> addNote(Note note) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('You must be signed in to add a note.');
    await _firestore.collection('notes').add({
      ...note.toMap(),
      'uid': user.uid,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateNote(Note note) async {
    if (note.id.isEmpty) return addNote(note);
    await _firestore.collection('notes').doc(note.id).update({
      ...note.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteNote(String noteId) {
    return _firestore.collection('notes').doc(noteId).delete();
  }
}
