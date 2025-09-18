import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';
import 'color_picker_widget.dart';

class EditNoteDialog extends StatefulWidget {
  final Note note;

  const EditNoteDialog({
    super.key,
    required this.note,
  });

  @override
  State<EditNoteDialog> createState() => _EditNoteDialogState();
}

class _EditNoteDialogState extends State<EditNoteDialog> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late NoteColor _selectedColor;
  late List<String> _selectedLabels;
  DateTime? _reminderDate;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
    _selectedColor = widget.note.color;
    _selectedLabels = List.from(widget.note.labels);
    _reminderDate = widget.note.reminderDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Edit Note',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Title input
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            
            // Content input
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Note content...',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
            const SizedBox(height: 16),
            
            // Color picker
            ColorPickerWidget(
              selectedColor: _selectedColor,
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Labels and reminder
            Row(
              children: [
                _buildActionButton(
                  icon: MdiIcons.labelOutline,
                  onPressed: _showLabelPicker,
                  tooltip: 'Add Labels',
                ),
                _buildActionButton(
                  icon: MdiIcons.clockOutline,
                  onPressed: _showReminderPicker,
                  tooltip: 'Set Reminder',
                ),
                if (_reminderDate != null)
                  _buildActionButton(
                    icon: MdiIcons.close,
                    onPressed: _removeReminder,
                    tooltip: 'Remove Reminder',
                  ),
                const Spacer(),
                // Action buttons
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _saveNote,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 20,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
    );
  }

  void _showLabelPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Labels'),
        content: const Text('Label management will be implemented in the full version.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showReminderPicker() {
    showDatePicker(
      context: context,
      initialDate: _reminderDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((date) {
      if (date != null) {
        showTimePicker(
          context: context,
          initialTime: _reminderDate != null
              ? TimeOfDay.fromDateTime(_reminderDate!)
              : TimeOfDay.now(),
        ).then((time) {
          if (time != null) {
            setState(() {
              _reminderDate = DateTime(
                date.year,
                date.month,
                date.day,
                time.hour,
                time.minute,
              );
            });
          }
        });
      }
    });
  }

  void _removeReminder() {
    setState(() {
      _reminderDate = null;
    });
  }

  Future<void> _saveNote() async {
    if (_titleController.text.trim().isEmpty && _contentController.text.trim().isEmpty) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final updateData = UpdateNoteData(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        color: _selectedColor,
        labels: _selectedLabels,
        reminderDate: _reminderDate,
      );

      await context.read<NoteProvider>().updateNote(widget.note.id, updateData);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating note: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
