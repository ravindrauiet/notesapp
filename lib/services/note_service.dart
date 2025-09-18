import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';
import '../constants/app_constants.dart';
import 'firebase_service.dart';

class NoteService {
  static final FirebaseFirestore _firestore = FirebaseService.firestore;
  static const String _collectionName = AppConstants.notesCollection;

  // Create a new note
  Future<Note> createNote(CreateNoteData noteData) async {
    try {
      final now = DateTime.now();
      final firestoreData = {
        'title': noteData.title,
        'content': noteData.content,
        'source': noteData.source,
        'isPinned': noteData.isPinned,
        'color': noteData.color.name,
        'labels': noteData.labels,
        'isArchived': false,
        'isDeleted': false,
        'reminderDate': noteData.reminderDate != null 
            ? Timestamp.fromDate(noteData.reminderDate!)
            : null,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      };

      print('Creating note with data: $firestoreData');

      final docRef = await _firestore.collection(_collectionName).add(firestoreData);

      return Note(
        id: docRef.id,
        title: noteData.title,
        content: noteData.content,
        source: noteData.source,
        isPinned: noteData.isPinned,
        color: noteData.color,
        labels: noteData.labels,
        isArchived: false,
        isDeleted: false,
        reminderDate: noteData.reminderDate,
        createdAt: now,
        updatedAt: now,
      );
    } catch (error) {
      print('Error creating note: $error');
      throw Exception('Failed to create note');
    }
  }

  // Get all notes
  Future<List<Note>> getNotes() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) => Note.fromFirestore(doc)).toList();
    } catch (error) {
      print('Error fetching notes: $error');
      throw Exception('Failed to fetch notes');
    }
  }

  // Update a note
  Future<void> updateNote(String noteId, UpdateNoteData updateData) async {
    try {
      final noteRef = _firestore.collection(_collectionName).doc(noteId);
      final firestoreData = <String, dynamic>{
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      };

      if (updateData.title != null) firestoreData['title'] = updateData.title;
      if (updateData.content != null) firestoreData['content'] = updateData.content;
      if (updateData.source != null) firestoreData['source'] = updateData.source;
      if (updateData.isPinned != null) firestoreData['isPinned'] = updateData.isPinned;
      if (updateData.color != null) firestoreData['color'] = updateData.color!.name;
      if (updateData.labels != null) firestoreData['labels'] = updateData.labels;
      if (updateData.isArchived != null) firestoreData['isArchived'] = updateData.isArchived;
      if (updateData.isDeleted != null) firestoreData['isDeleted'] = updateData.isDeleted;
      if (updateData.reminderDate != null) {
        firestoreData['reminderDate'] = Timestamp.fromDate(updateData.reminderDate!);
      } else if (updateData.reminderDate == null && updateData.reminderDate != false) {
        firestoreData['reminderDate'] = null;
      }

      print('Updating note with data: $firestoreData');

      await noteRef.update(firestoreData);
    } catch (error) {
      print('Error updating note: $error');
      throw Exception('Failed to update note');
    }
  }

  // Delete a note permanently
  Future<void> deleteNote(String noteId) async {
    try {
      await _firestore.collection(_collectionName).doc(noteId).delete();
    } catch (error) {
      print('Error deleting note: $error');
      throw Exception('Failed to delete note');
    }
  }

  // Toggle pin status
  Future<void> togglePin(String noteId, bool isPinned) async {
    try {
      await updateNote(noteId, UpdateNoteData(isPinned: isPinned));
    } catch (error) {
      print('Error toggling pin: $error');
      throw Exception('Failed to toggle pin');
    }
  }

  // Change note color
  Future<void> changeColor(String noteId, NoteColor color) async {
    try {
      await updateNote(noteId, UpdateNoteData(color: color));
    } catch (error) {
      print('Error changing color: $error');
      throw Exception('Failed to change color');
    }
  }

  // Search notes
  Future<List<Note>> searchNotes(String searchQuery) async {
    try {
      final allNotes = await getNotes();
      return allNotes.where((note) =>
          note.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          note.content.toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    } catch (error) {
      print('Error searching notes: $error');
      throw Exception('Failed to search notes');
    }
  }

  // Get notes by status
  Future<List<Note>> getNotesByStatus(String status) async {
    try {
      final allNotes = await getNotes();
      
      switch (status) {
        case 'active':
          return allNotes.where((note) => !note.isArchived && !note.isDeleted).toList();
        case 'archived':
          return allNotes.where((note) => note.isArchived && !note.isDeleted).toList();
        case 'deleted':
          return allNotes.where((note) => note.isDeleted).toList();
        default:
          return allNotes;
      }
    } catch (error) {
      print('Error fetching notes by status: $error');
      throw Exception('Failed to fetch notes by status');
    }
  }

  // Get notes with reminders
  Future<List<Note>> getNotesWithReminders() async {
    try {
      final allNotes = await getNotes();
      return allNotes.where((note) => 
          note.reminderDate != null && !note.isArchived && !note.isDeleted
      ).toList();
    } catch (error) {
      print('Error fetching notes with reminders: $error');
      throw Exception('Failed to fetch notes with reminders');
    }
  }

  // Archive a note
  Future<void> archiveNote(String noteId) async {
    try {
      await updateNote(noteId, UpdateNoteData(isArchived: true));
    } catch (error) {
      print('Error archiving note: $error');
      throw Exception('Failed to archive note');
    }
  }

  // Unarchive a note
  Future<void> unarchiveNote(String noteId) async {
    try {
      await updateNote(noteId, UpdateNoteData(isArchived: false));
    } catch (error) {
      print('Error unarchiving note: $error');
      throw Exception('Failed to unarchive note');
    }
  }

  // Soft delete a note
  Future<void> softDeleteNote(String noteId) async {
    try {
      await updateNote(noteId, UpdateNoteData(isDeleted: true));
    } catch (error) {
      print('Error soft deleting note: $error');
      throw Exception('Failed to delete note');
    }
  }

  // Restore a note from trash
  Future<void> restoreNote(String noteId) async {
    try {
      await updateNote(noteId, UpdateNoteData(isDeleted: false));
    } catch (error) {
      print('Error restoring note: $error');
      throw Exception('Failed to restore note');
    }
  }

  // Permanently delete a note
  Future<void> permanentDeleteNote(String noteId) async {
    try {
      await deleteNote(noteId);
    } catch (error) {
      print('Error permanently deleting note: $error');
      throw Exception('Failed to permanently delete note');
    }
  }

  // Add label to note
  Future<void> addLabel(String noteId, String label) async {
    try {
      final notes = await getNotes();
      final targetNote = notes.firstWhere((n) => n.id == noteId);
      
      final currentLabels = List<String>.from(targetNote.labels);
      if (!currentLabels.contains(label)) {
        currentLabels.add(label);
        await updateNote(noteId, UpdateNoteData(labels: currentLabels));
      }
    } catch (error) {
      print('Error adding label: $error');
      throw Exception('Failed to add label');
    }
  }

  // Remove label from note
  Future<void> removeLabel(String noteId, String label) async {
    try {
      final notes = await getNotes();
      final targetNote = notes.firstWhere((n) => n.id == noteId);
      
      final currentLabels = List<String>.from(targetNote.labels);
      currentLabels.remove(label);
      await updateNote(noteId, UpdateNoteData(labels: currentLabels));
    } catch (error) {
      print('Error removing label: $error');
      throw Exception('Failed to remove label');
    }
  }

  // Get all unique labels
  Future<List<String>> getAllLabels() async {
    try {
      final allNotes = await getNotes();
      final labels = <String>{};
      
      for (final note in allNotes) {
        labels.addAll(note.labels);
      }
      
      return labels.toList()..sort();
    } catch (error) {
      print('Error fetching labels: $error');
      throw Exception('Failed to fetch labels');
    }
  }

  // Set reminder for note
  Future<void> setReminder(String noteId, DateTime reminderDate) async {
    try {
      await updateNote(noteId, UpdateNoteData(reminderDate: reminderDate));
    } catch (error) {
      print('Error setting reminder: $error');
      throw Exception('Failed to set reminder');
    }
  }

  // Remove reminder from note
  Future<void> removeReminder(String noteId) async {
    try {
      await updateNote(noteId, UpdateNoteData(reminderDate: null));
    } catch (error) {
      print('Error removing reminder: $error');
      throw Exception('Failed to remove reminder');
    }
  }
}
