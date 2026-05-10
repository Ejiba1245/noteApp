import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/firestore_service.dart';
import '../database/hive_database.dart';
import '../services/gemini_service.dart';
import 'package:uuid/uuid.dart';

class NotesProvider with ChangeNotifier {
  final HiveDatabase _hiveDb = HiveDatabase();
  final FirestoreService _firestoreService = FirestoreService();
  final GeminiService _geminiService = GeminiService();

  List<Note> _notes = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<Note> get notes {
    var filtered = _notes.where((n) => !n.isArchived).toList();
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((n) => 
        n.title.toLowerCase().contains(_searchQuery.toLowerCase()) || 
        n.content.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    if (_selectedCategory != 'All') {
      filtered = filtered.where((n) => n.category == _selectedCategory).toList();
    }
    filtered.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return filtered;
  }

  List<Note> get pinnedNotes => notes.where((n) => n.isPinned).toList();
  List<Note> get recentNotes => notes.where((n) => !n.isPinned).toList();

  NotesProvider() {
    _loadLocalNotes();
  }

  void _loadLocalNotes() {
    _notes = _hiveDb.getAllNotes();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> addNote(String title, String content, {String category = 'All'}) async {
    final note = Note(
      id: const Uuid().v4(),
      title: title.isEmpty ? 'Untitled Note' : title,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      category: category,
    );
    
    await _hiveDb.saveNote(note);
    _notes.add(note);
    notifyListeners();
    
    // Background tasks
    _processAI(note.id);
    _syncToCloud(note);
  }

  Future<void> updateNote(Note note) async {
    final updatedNote = note.copyWith(updatedAt: DateTime.now());
    await _hiveDb.saveNote(updatedNote);
    int index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes[index] = updatedNote;
      notifyListeners();
      _syncToCloud(updatedNote);
    }
  }

  Future<void> deleteNote(String id) async {
    await _hiveDb.deleteNote(id);
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
    _firestoreService.deleteNote(id);
  }

  Future<void> togglePin(Note note) async {
    await updateNote(note.copyWith(isPinned: !note.isPinned));
  }

  Future<void> _processAI(String id) async {
    int index = _notes.indexWhere((n) => n.id == id);
    if (index == -1) return;
    
    Note note = _notes[index];
    if (note.content.length < 10) return;

    final summary = await _geminiService.summarizeNote(note.content);
    final keywords = await _geminiService.extractKeywords(note.content);
    
    if (summary != null) {
      await updateNote(note.copyWith(aiSummary: summary, keywords: keywords));
    }
  }

  Future<void> _syncToCloud(Note note) async {
    try {
      await _firestoreService.saveNote(note);
      await _hiveDb.saveNote(note.copyWith(isSynced: true));
    } catch (e) {
      print('Sync failed: $e');
    }
  }
}
