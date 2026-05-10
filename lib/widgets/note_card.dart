import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../themes/app_theme.dart';
import '../screens/note_detail_screen.dart';
import 'glass_card.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final bool isSmall;

  const NoteCard({super.key, required this.note, this.isSmall = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NoteDetailScreen(note: note)),
      ),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isSmall && note.aiSummary != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('AI Summary Available', style: TextStyle(color: AppTheme.secondary, fontSize: 12)),
                  Text('${DateTime.now().difference(note.updatedAt).inHours}h ago', style: const TextStyle(color: Colors.white24, fontSize: 10)),
                ],
              ),
            if (!isSmall) const SizedBox(height: 8),
            Text(
              note.title,
              style: TextStyle(
                fontSize: isSmall ? 16 : 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              note.content,
              style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14),
              maxLines: isSmall ? 2 : 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (!isSmall) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: [
                  _tag(note.category, AppTheme.secondary),
                  if (note.isPinned) _tag('Urgent', AppTheme.primary),
                ],
              ),
            ]
          ],
        ),
      ).copyWithBorder(note.isPinned ? AppTheme.secondary : Colors.white10),
    );
  }

  Widget _tag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}

extension on GlassCard {
  Widget copyWithBorder(Color borderColor) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border(left: BorderSide(color: borderColor, width: 4)),
      ),
      child: this,
    );
  }
}
