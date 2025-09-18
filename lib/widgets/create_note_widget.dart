import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';
import '../constants/app_constants.dart';

class CreateNoteWidget extends StatefulWidget {
  const CreateNoteWidget({super.key});

  @override
  State<CreateNoteWidget> createState() => _CreateNoteWidgetState();
}

class _CreateNoteWidgetState extends State<CreateNoteWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();
  
  bool _isExpanded = false;
  bool _isSubmitting = false;
  NoteColor _selectedColor = NoteColor.yellow;
  List<String> _selectedLabels = [];
  DateTime? _reminderDate;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Title input
          TextField(
            controller: _titleController,
            focusNode: _titleFocusNode,
            onTap: () {
              if (!_isExpanded) {
                setState(() => _isExpanded = true);
              }
            },
            decoration: const InputDecoration(
              hintText: AppStrings.takeANote,
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
            style: const TextStyle(fontSize: 16),
          ),
          
          // Expanded content
          if (_isExpanded) ...[
            // Content input
            TextField(
              controller: _contentController,
              focusNode: _contentFocusNode,
              decoration: const InputDecoration(
                hintText: AppStrings.addANote,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              maxLines: 3,
              style: const TextStyle(fontSize: 14),
            ),
            
            const SizedBox(height: 16),
            
            // Color picker
            _buildColorPicker(),
            
            const SizedBox(height: 16),
            
            // Labels and reminder
            Row(
              children: [
                _buildActionButton(
                  icon: MdiIcons.palette,
                  onPressed: _showColorPicker,
                  tooltip: 'Color',
                ),
                _buildActionButton(
                  icon: MdiIcons.labelOutline,
                  onPressed: _showLabelPicker,
                  tooltip: 'Labels',
                ),
                _buildActionButton(
                  icon: MdiIcons.clockOutline,
                  onPressed: _showReminderPicker,
                  tooltip: 'Reminder',
                ),
                const Spacer(),
                // Action buttons
                TextButton(
                  onPressed: _cancel,
                  child: const Text(AppStrings.cancel),
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
                      : const Text(AppStrings.save),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildColorPicker() {
    return Row(
      children: NoteColor.values.map((color) {
        return GestureDetector(
          onTap: () => setState(() => _selectedColor = color),
          child: Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Color(AppConstants.noteColors[color.name]!.value),
              shape: BoxShape.circle,
              border: Border.all(
                color: _selectedColor == color ? Colors.black : Colors.transparent,
                width: 2,
              ),
            ),
          ),
        );
      }).toList(),
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

  void _showColorPicker() {
    // Color picker is already visible in expanded state
  }

  void _showLabelPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Labels'),
        content: const Text('Label picker functionality will be implemented'),
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
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((date) {
      if (date != null) {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
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

  void _cancel() {
    setState(() {
      _isExpanded = false;
      _titleController.clear();
      _contentController.clear();
      _selectedLabels.clear();
      _reminderDate = null;
    });
  }

  Future<void> _saveNote() async {
    if (_titleController.text.trim().isEmpty && _contentController.text.trim().isEmpty) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final noteData = CreateNoteData(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        color: _selectedColor,
        labels: _selectedLabels,
        reminderDate: _reminderDate,
      );

      await context.read<NoteProvider>().createNote(noteData);
      
      _cancel();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating note: $e'),
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
