import 'package:hive_flutter/hive_flutter.dart';
import '../models/note_model.dart';

class HiveDatabase {
  static const String notesBoxName = 'notes_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(NoteAdapter());
    await Hive.openBox<Note>(notesBoxName);
  }

  Box<Note> get notesBox => Hive.box<Note>(notesBoxName);

  Future<void> saveNote(Note note) async {
    await notesBox.put(note.id, note);
  }

  Future<void> deleteNote(String id) async {
    await notesBox.delete(id);
  }

  List<Note> getAllNotes() {
    return notesBox.values.toList();
  }

  Future<void> clearAll() async {
    await notesBox.clear();
  }
}
