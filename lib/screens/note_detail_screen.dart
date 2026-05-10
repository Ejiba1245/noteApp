import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note_model.dart';
import '../providers/notes_provider.dart';
import '../themes/app_theme.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note? note;
  const NoteDetailScreen({super.key, this.note});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.note != null;
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _save() {
    final provider = Provider.of<NotesProvider>(context, listen: false);
    if (_isEditing) {
      provider.updateNote(widget.note!.copyWith(
        title: _titleController.text,
        content: _contentController.text,
      ));
    } else {
      if (_titleController.text.isNotEmpty || _contentController.text.isNotEmpty) {
        provider.addNote(_titleController.text, _contentController.text);
      }
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () {
                Provider.of<NotesProvider>(context, listen: false).deleteNote(widget.note!.id);
                Navigator.pop(context);
              },
            ),
          IconButton(
            icon: const Icon(Icons.check, color: AppTheme.primary),
            onPressed: _save,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (widget.note?.aiSummary != null)
              Container(
                margin: const EdgeInsets.bottom(24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: const Border(left: BorderSide(color: AppTheme.secondary, width: 4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.auto_awesome, size: 16, color: AppTheme.secondary),
                        SizedBox(width: 8),
                        Text('AI SUMMARY', style: TextStyle(color: AppTheme.secondary, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(widget.note!.aiSummary!, style: const TextStyle(color: AppTheme.onSurfaceVariant, fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.onSurface),
              decoration: const InputDecoration(
                hintText: 'Note Title',
                hintStyle: TextStyle(color: Colors.white10),
                border: InputBorder.none,
              ),
            ),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                style: const TextStyle(fontSize: 18, color: AppTheme.onSurfaceVariant, height: 1.5),
                decoration: const InputDecoration(
                  hintText: 'Start typing...',
                  hintStyle: TextStyle(color: Colors.white10),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildToolbar(),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 10, left: 20, right: 20, top: 10),
      decoration: BoxDecoration(
        color: AppTheme.surface.withOpacity(0.9),
        border: const Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(icon: const Icon(Icons.format_bold), onPressed: () {}),
              IconButton(icon: const Icon(Icons.format_italic), onPressed: () {}),
              IconButton(icon: const Icon(Icons.format_list_bulleted), onPressed: () {}),
            ],
          ),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.mic_none, color: AppTheme.secondary), onPressed: () {}),
              IconButton(icon: const Icon(Icons.camera_alt_outlined), onPressed: () {}),
            ],
          )
        ],
      ),
    );
  }
}
