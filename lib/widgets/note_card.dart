import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';
import '../constants/app_constants.dart';

class NoteCard extends StatefulWidget {
  final Note note;

  const NoteCard({
    super.key,
    required this.note,
  });

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        decoration: BoxDecoration(
          color: Color(widget.note.colorValue),
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _editNote(),
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with title and actions
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.note.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (_isHovered) _buildActionButtons(),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Content
                  Expanded(
                    child: Text(
                      widget.note.content,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Labels
                  if (widget.note.labels.isNotEmpty) ...[
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: widget.note.labels.take(3).map((label) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            label,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                  ],
                  
                  // Reminder
                  if (widget.note.reminderDate != null) ...[
                    Row(
                      children: [
                        Icon(
                          MdiIcons.clockOutline,
                          size: 16,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM d, h:mm a').format(widget.note.reminderDate!),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  
                  // Footer with timestamp
                  Text(
                    DateFormat('MMM d').format(widget.note.updatedAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          icon: widget.note.isPinned ? MdiIcons.pin : MdiIcons.pinOutline,
          onPressed: () => _togglePin(),
          tooltip: widget.note.isPinned ? 'Unpin' : 'Pin',
        ),
        _buildActionButton(
          icon: MdiIcons.archiveOutline,
          onPressed: () => _archiveNote(),
          tooltip: 'Archive',
        ),
        _buildActionButton(
          icon: MdiIcons.deleteOutline,
          onPressed: () => _deleteNote(),
          tooltip: 'Delete',
        ),
      ],
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
            size: 18,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  void _editNote() {
    // TODO: Navigate to edit note screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.note.title),
        content: Text(widget.note.content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _togglePin() {
    context.read<NoteProvider>().togglePin(widget.note.id);
  }

  void _archiveNote() {
    context.read<NoteProvider>().archiveNote(widget.note.id);
  }

  void _deleteNote() {
    context.read<NoteProvider>().softDeleteNote(widget.note.id);
  }
}
