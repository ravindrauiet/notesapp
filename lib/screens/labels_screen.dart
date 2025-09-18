import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../providers/note_provider.dart';
import '../widgets/note_card.dart';
import '../constants/app_constants.dart';

class LabelsScreen extends StatefulWidget {
  const LabelsScreen({super.key});

  @override
  State<LabelsScreen> createState() => _LabelsScreenState();
}

class _LabelsScreenState extends State<LabelsScreen> {
  List<String> _labels = [];
  String? _selectedLabel;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLabels();
    });
  }

  Future<void> _loadLabels() async {
    setState(() => _loading = true);
    try {
      final labels = await context.read<NoteProvider>().getAllLabels();
      setState(() {
        _labels = labels;
      });
    } catch (e) {
      print('Error loading labels: $e');
      // Add some sample labels for demo
      setState(() {
        _labels = ['Personal', 'Work', 'Ideas', 'Shopping'];
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Labels'),
        actions: [
          IconButton(
            onPressed: _showCreateLabelDialog,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _labels.isEmpty
              ? _buildEmptyState()
              : _buildLabelsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Icon(
              MdiIcons.pencilOutline,
              size: 32,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No labels yet',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Create labels to organize your notes',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _showCreateLabelDialog,
            icon: const Icon(Icons.add),
            label: const Text('Create Label'),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _labels.length,
      itemBuilder: (context, index) {
        final label = _labels[index];
        return Card(
          child: ListTile(
            leading: Icon(
              MdiIcons.labelOutline,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(label),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () => _showNotesForLabel(label),
                  child: const Text('View Notes'),
                ),
                IconButton(
                  onPressed: () => _deleteLabel(label),
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                ),
              ],
            ),
            onTap: () => _showNotesForLabel(label),
          ),
        );
      },
    );
  }

  void _showCreateLabelDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Label'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter label name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                _createLabel(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<void> _createLabel(String labelName) async {
    // For demo purposes, just add to local list
    setState(() {
      _labels.add(labelName);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Label "$labelName" created')),
    );
  }

  Future<void> _deleteLabel(String labelName) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Label'),
        content: Text('Are you sure you want to delete "$labelName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _labels.remove(labelName);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Label "$labelName" deleted')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showNotesForLabel(String label) {
    // This would show notes filtered by label
    // For now, just show a placeholder
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Notes with label "$label"'),
        content: const Text('This feature will show notes filtered by the selected label.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
