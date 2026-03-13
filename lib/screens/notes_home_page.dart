import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/storage_service.dart';
import '../widgets/note_card.dart';
import '../widgets/note_dialog.dart';

class NotesHomePage extends StatefulWidget {
  const NotesHomePage({super.key});

  @override
  State<NotesHomePage> createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  List<Note> _notes = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final StorageService _storageService = StorageService();

  final List<Color> _noteColors = [
    const Color(0xFFFFF9C4),
    const Color(0xFFBBDEFB),
    const Color(0xFFC8E6C9),
    const Color(0xFFFFCCBC),
    const Color(0xFFE1BEE7),
    const Color(0xFFFFCDD2),
  ];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await _storageService.loadNotes();
    setState(() => _notes = notes);
  }

  Future<void> _saveNotes() async {
    await _storageService.saveNotes(_notes);
  }

  List<Note> get _filteredNotes {
    List<Note> filtered = _notes;
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((note) =>
              note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              note.content.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    filtered.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.createdAt.compareTo(a.createdAt);
    });
    return filtered;
  }

  void _openNoteDialog({Note? note}) {
    showDialog(
      context: context,
      builder: (context) => NoteDialog(
        note: note,
        colors: _noteColors,
        onSave: (title, content, color) {
          setState(() {
            if (note == null) {
              _notes.add(Note(
                title: title,
                content: content,
                createdAt: DateTime.now(),
                color: color,
              ));
            } else {
              final index = _notes.indexOf(note);
              _notes[index].title = title;
              _notes[index].content = content;
              _notes[index].color = color;
            }
          });
          _saveNotes();
        },
      ),
    );
  }

  void _deleteNote(Note note) {
    setState(() => _notes.remove(note));
    _saveNotes();
  }

  void _togglePin(Note note) {
    setState(() => note.isPinned = !note.isPinned);
    _saveNotes();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredNotes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.amber,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
        ),
      ),
      body: filtered.isEmpty
          ? Center(
              child: Text(
                _searchQuery.isNotEmpty
                    ? 'No notes found for "$_searchQuery"'
                    : 'No notes yet!\nTap + to add a note.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final note = filtered[index];
                  return NoteCard(
                    note: note,
                    onEdit: () => _openNoteDialog(note: note),
                    onDelete: () => _deleteNote(note),
                    onTogglePin: () => _togglePin(note),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openNoteDialog(),
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
      ),
    );
  }
}