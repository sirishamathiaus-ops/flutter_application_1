import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class StorageService {
  static const String _key = 'notes';

  Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesJson = prefs.getString(_key);
    if (notesJson != null) {
      final List<dynamic> decoded = jsonDecode(notesJson);
      return decoded.map((e) => Note.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(notes.map((e) => e.toJson()).toList());
    await prefs.setString(_key, encoded);
  }
}