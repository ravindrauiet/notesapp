import 'package:flutter/material.dart';

class AppConstants {
  // App Information
  static const String appName = 'Keep';
  static const String appVersion = '1.0.0';

  // Firebase Collections
  static const String notesCollection = 'notes';

  // Note Colors
  static const Map<String, Color> noteColors = {
    'yellow': Color(0xFFFFF59D),
    'pink': Color(0xFFF8BBD9),
    'blue': Color(0xFFBBDEFB),
    'green': Color(0xFFC8E6C9),
    'orange': Color(0xFFFFCC80),
    'purple': Color(0xFFE1BEE7),
  };

  // Theme Colors
  static const Color lightPrimary = Color(0xFFF8F9FA);
  static const Color lightSecondary = Color(0xFFFFFFFF);
  static const Color lightTertiary = Color(0xFFF1F3F4);
  static const Color lightTextPrimary = Color(0xFF202124);
  static const Color lightTextSecondary = Color(0xFF5F6368);
  static const Color lightTextTertiary = Color(0xFF9AA0A6);
  static const Color lightBorder = Color(0xFFDADCE0);

  static const Color darkPrimary = Color(0xFF202124);
  static const Color darkSecondary = Color(0xFF303134);
  static const Color darkTertiary = Color(0xFF3C4043);
  static const Color darkTextPrimary = Color(0xFFE8EAED);
  static const Color darkTextSecondary = Color(0xFF9AA0A6);
  static const Color darkTextTertiary = Color(0xFF5F6368);
  static const Color darkBorder = Color(0xFF5F6368);

  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Grid Layout
  static const int gridColumnsMobile = 1;
  static const int gridColumnsTablet = 2;
  static const int gridColumnsDesktop = 3;
  static const int gridColumnsLargeDesktop = 4;

  // Note Limits
  static const int maxTitleLength = 100;
  static const int maxContentLength = 1000;
  static const int maxLabelsPerNote = 10;
  static const int maxLabelLength = 50;

  // Search
  static const int searchDebounceMs = 300;
  static const int minSearchLength = 1;

  // Reminders
  static const int reminderNotificationId = 1000;
  static const int maxRemindersPerNote = 1;
}

class AppStrings {
  // General
  static const String appName = 'Keep';
  static const String searchHint = 'Search';
  static const String takeANote = 'Take a note...';
  static const String addANote = 'Add a note...';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String archive = 'Archive';
  static const String unarchive = 'Unarchive';
  static const String restore = 'Restore';
  static const String pin = 'Pin';
  static const String unpin = 'Unpin';
  static const String addLabel = 'Add a label';
  static const String setReminder = 'Set reminder';
  static const String removeReminder = 'Remove reminder';
  static const String clear = 'Clear';

  // Navigation
  static const String notes = 'Notes';
  static const String reminders = 'Reminders';
  static const String editLabels = 'Edit labels';
  static const String archiveTitle = 'Archive';
  static const String trash = 'Trash';

  // Sections
  static const String pinned = 'PINNED';
  static const String others = 'OTHERS';

  // Empty States
  static const String noNotesYet = 'No notes yet';
  static const String createFirstNote = 'Create your first note to get started!';
  static const String loadingNotes = 'Loading notes...';
  static const String pleaseWait = 'Please wait while we fetch your notes';

  // Errors
  static const String errorLoadingNotes = 'Failed to load notes';
  static const String errorCreatingNote = 'Failed to create note';
  static const String errorUpdatingNote = 'Failed to update note';
  static const String errorDeletingNote = 'Failed to delete note';
  static const String errorArchivingNote = 'Failed to archive note';
  static const String errorRestoringNote = 'Failed to restore note';
  static const String errorTogglingPin = 'Failed to toggle pin';
  static const String errorChangingColor = 'Failed to change color';
  static const String errorAddingLabel = 'Failed to add label';
  static const String errorRemovingLabel = 'Failed to remove label';
  static const String errorSettingReminder = 'Failed to set reminder';
  static const String errorRemovingReminder = 'Failed to remove reminder';
  static const String errorFetchingLabels = 'Failed to fetch labels';
  static const String errorFetchingNotesByStatus = 'Failed to fetch notes by status';
  static const String errorFetchingNotesWithReminders = 'Failed to fetch notes with reminders';

  // Success Messages
  static const String noteCreated = 'Note created successfully';
  static const String noteUpdated = 'Note updated successfully';
  static const String noteDeleted = 'Note deleted successfully';
  static const String noteArchived = 'Note archived successfully';
  static const String noteRestored = 'Note restored successfully';
  static const String notePinned = 'Note pinned successfully';
  static const String noteUnpinned = 'Note unpinned successfully';
  static const String colorChanged = 'Color changed successfully';
  static const String labelAdded = 'Label added successfully';
  static const String labelRemoved = 'Label removed successfully';
  static const String reminderSet = 'Reminder set successfully';
  static const String reminderRemoved = 'Reminder removed successfully';
}
