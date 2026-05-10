import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  CollectionReference get _notesRef => _db.collection('users').doc(uid).collection('notes');

  Future<void> saveNote(Note note) async {
    await _notesRef.doc(note.id).set(note.toMap());
  }

  Future<void> deleteNote(String noteId) async {
    await _notesRef.doc(noteId).delete();
  }

  Stream<List<Note>> getNotes() {
    return _notesRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Note.fromMap(doc.data() as Map<String, dynamic>)).toList();
    });
  }

  Future<void> syncBatch(List<Note> notes) async {
    final batch = _db.batch();
    for (var note in notes) {
      batch.set(_notesRef.doc(note.id), note.toMap());
    }
    await batch.commit();
  }
}
