import 'package:flutter/foundation.dart';
import '../models/note.dart';
import '../services/note_service.dart';

class NoteProvider with ChangeNotifier {
  final NoteService _noteService = NoteService();
  
  List<Note> _notes = [];
  bool _loading = false;
  String? _error;
  String _searchQuery = '';

  // Getters
  List<Note> get notes => _notes;
  bool get loading => _loading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  // Get filtered notes based on search query
  List<Note> get filteredNotes {
    if (_searchQuery.isEmpty) {
      return _notes.where((note) => note.isActive).toList();
    }
    return _notes.where((note) => 
      note.isActive && 
      (note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
       note.content.toLowerCase().contains(_searchQuery.toLowerCase()))
    ).toList();
  }

  // Get pinned notes
  List<Note> get pinnedNotes => filteredNotes.where((note) => note.isPinned).toList();

  // Get unpinned notes
  List<Note> get unpinnedNotes => filteredNotes.where((note) => !note.isPinned).toList();

  // Get archived notes
  List<Note> get archivedNotes => _notes.where((note) => note.isArchived && !note.isDeleted).toList();

  // Get deleted notes
  List<Note> get deletedNotes => _notes.where((note) => note.isDeleted).toList();

  // Get notes with reminders
  List<Note> get notesWithReminders => _notes.where((note) => 
    note.reminderDate != null && note.isActive
  ).toList();

  // Initialize and load notes
  Future<void> loadNotes() async {
    try {
      _setLoading(true);
      _setError(null);
      _notes = await _noteService.getNotes();
      notifyListeners();
    } catch (e) {
      _setError('Firebase not available. Please check your internet connection.');
      print('Error loading notes: $e');
      // Add some sample notes for demo
      _notes = _getSampleNotes();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Sample notes for demo when Firebase is not available
  List<Note> _getSampleNotes() {
    return [
      Note(
        id: '1',
        title: 'Welcome to Keep Clone!',
        content: 'This is a sample note. Firebase is not connected, so you\'re seeing demo data.',
        color: NoteColor.yellow,
        isPinned: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Note(
        id: '2',
        title: 'Features',
        content: 'Create, edit, delete, pin, archive, and color-code your notes just like Google Keep!',
        color: NoteColor.blue,
        labels: ['demo', 'features'],
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      Note(
        id: '3',
        title: 'Firebase Setup',
        content: 'To use real data, make sure Firebase is properly configured for web.',
        color: NoteColor.green,
        labels: ['setup', 'firebase'],
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ];
  }

  // Create a new note
  Future<void> createNote(CreateNoteData noteData) async {
    try {
      _setError(null);
      final newNote = await _noteService.createNote(noteData);
      _notes.insert(0, newNote);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      print('Error creating note: $e');
      // Create note locally for demo
      final localNote = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: noteData.title,
        content: noteData.content,
        source: noteData.source,
        isPinned: noteData.isPinned,
        color: noteData.color,
        labels: noteData.labels,
        reminderDate: noteData.reminderDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _notes.insert(0, localNote);
      notifyListeners();
    }
  }

  // Update a note
  Future<void> updateNote(String noteId, UpdateNoteData updateData) async {
    try {
      _setError(null);
      await _noteService.updateNote(noteId, updateData);
      
      final index = _notes.indexWhere((note) => note.id == noteId);
      if (index != -1) {
        _notes[index] = _notes[index].copyWith(
          title: updateData.title,
          content: updateData.content,
          source: updateData.source,
          isPinned: updateData.isPinned,
          color: updateData.color,
          labels: updateData.labels,
          isArchived: updateData.isArchived,
          isDeleted: updateData.isDeleted,
          reminderDate: updateData.reminderDate,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
      print('Error updating note: $e');
      rethrow;
    }
  }

  // Delete a note permanently
  Future<void> deleteNote(String noteId) async {
    try {
      _setError(null);
      await _noteService.deleteNote(noteId);
      _notes.removeWhere((note) => note.id == noteId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      print('Error deleting note: $e');
      rethrow;
    }
  }

  // Toggle pin status
  Future<void> togglePin(String noteId) async {
    try {
      _setError(null);
      final note = _notes.firstWhere((n) => n.id == noteId);
      final newPinStatus = !note.isPinned;
      
      await _noteService.togglePin(noteId, newPinStatus);
      
      final index = _notes.indexWhere((n) => n.id == noteId);
      if (index != -1) {
        _notes[index] = _notes[index].copyWith(
          isPinned: newPinStatus,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
      print('Error toggling pin: $e');
      rethrow;
    }
  }

  // Change note color
  Future<void> changeColor(String noteId, NoteColor color) async {
    try {
      _setError(null);
      await _noteService.changeColor(noteId, color);
      
      final index = _notes.indexWhere((note) => note.id == noteId);
      if (index != -1) {
        _notes[index] = _notes[index].copyWith(
          color: color,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
      print('Error changing color: $e');
      rethrow;
    }
  }

  // Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Clear search query
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // Archive a note
  Future<void> archiveNote(String noteId) async {
    try {
      _setError(null);
      await _noteService.archiveNote(noteId);
      
      final index = _notes.indexWhere((note) => note.id == noteId);
      if (index != -1) {
        _notes[index] = _notes[index].copyWith(
          isArchived: true,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
      print('Error archiving note: $e');
      rethrow;
    }
  }

  // Unarchive a note
  Future<void> unarchiveNote(String noteId) async {
    try {
      _setError(null);
      await _noteService.unarchiveNote(noteId);
      
      final index = _notes.indexWhere((note) => note.id == noteId);
      if (index != -1) {
        _notes[index] = _notes[index].copyWith(
          isArchived: false,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
      print('Error unarchiving note: $e');
      rethrow;
    }
  }

  // Soft delete a note
  Future<void> softDeleteNote(String noteId) async {
    try {
      _setError(null);
      await _noteService.softDeleteNote(noteId);
      
      final index = _notes.indexWhere((note) => note.id == noteId);
      if (index != -1) {
        _notes[index] = _notes[index].copyWith(
          isDeleted: true,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
      print('Error soft deleting note: $e');
      rethrow;
    }
  }

  // Restore a note from trash
  Future<void> restoreNote(String noteId) async {
    try {
      _setError(null);
      await _noteService.restoreNote(noteId);
      
      final index = _notes.indexWhere((note) => note.id == noteId);
      if (index != -1) {
        _notes[index] = _notes[index].copyWith(
          isDeleted: false,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
      print('Error restoring note: $e');
      rethrow;
    }
  }

  // Permanently delete a note
  Future<void> permanentDeleteNote(String noteId) async {
    try {
      _setError(null);
      await _noteService.permanentDeleteNote(noteId);
      _notes.removeWhere((note) => note.id == noteId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      print('Error permanently deleting note: $e');
      rethrow;
    }
  }

  // Add label to note
  Future<void> addLabel(String noteId, String label) async {
    try {
      _setError(null);
      await _noteService.addLabel(noteId, label);
      
      final index = _notes.indexWhere((note) => note.id == noteId);
      if (index != -1) {
        final currentLabels = List<String>.from(_notes[index].labels);
        if (!currentLabels.contains(label)) {
          currentLabels.add(label);
          _notes[index] = _notes[index].copyWith(
            labels: currentLabels,
            updatedAt: DateTime.now(),
          );
          notifyListeners();
        }
      }
    } catch (e) {
      _setError(e.toString());
      print('Error adding label: $e');
      rethrow;
    }
  }

  // Remove label from note
  Future<void> removeLabel(String noteId, String label) async {
    try {
      _setError(null);
      await _noteService.removeLabel(noteId, label);
      
      final index = _notes.indexWhere((note) => note.id == noteId);
      if (index != -1) {
        final currentLabels = List<String>.from(_notes[index].labels);
        currentLabels.remove(label);
        _notes[index] = _notes[index].copyWith(
          labels: currentLabels,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
      print('Error removing label: $e');
      rethrow;
    }
  }

  // Get all unique labels
  Future<List<String>> getAllLabels() async {
    try {
      _setError(null);
      return await _noteService.getAllLabels();
    } catch (e) {
      _setError(e.toString());
      print('Error fetching labels: $e');
      rethrow;
    }
  }

  // Set reminder for note
  Future<void> setReminder(String noteId, DateTime reminderDate) async {
    try {
      _setError(null);
      await _noteService.setReminder(noteId, reminderDate);
      
      final index = _notes.indexWhere((note) => note.id == noteId);
      if (index != -1) {
        _notes[index] = _notes[index].copyWith(
          reminderDate: reminderDate,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
      print('Error setting reminder: $e');
      rethrow;
    }
  }

  // Remove reminder from note
  Future<void> removeReminder(String noteId) async {
    try {
      _setError(null);
      await _noteService.removeReminder(noteId);
      
      final index = _notes.indexWhere((note) => note.id == noteId);
      if (index != -1) {
        _notes[index] = _notes[index].copyWith(
          reminderDate: null,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
      print('Error removing reminder: $e');
      rethrow;
    }
  }

  // Refresh all data
  Future<void> refreshAllData() async {
    await loadNotes();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }
}
