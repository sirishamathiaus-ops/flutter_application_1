import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTogglePin;

  const NoteCard({
    super.key,
    required this.note,
    required this.onEdit,
    required this.onDelete,
    required this.onTogglePin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: note.color,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (note.isPinned)
                        const Icon(Icons.push_pin,
                            size: 16, color: Colors.deepOrange),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          note.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        note.isPinned
                            ? Icons.push_pin
                            : Icons.push_pin_outlined,
                        size: 18,
                        color: note.isPinned ? Colors.deepOrange : Colors.grey,
                      ),
                      onPressed: onTogglePin,
                      tooltip: note.isPinned ? 'Unpin' : 'Pin',
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18),
                      onPressed: onEdit,
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete,
                          size: 18, color: Colors.red),
                      onPressed: onDelete,
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: Text(
                note.content,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.fade,
              ),
            ),
            Text(
              '${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}