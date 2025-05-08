import 'package:shared_preferences/shared_preferences.dart';

class DiaryService {
  static const String _key = 'diary_entries';

  static Future<bool> saveEntry(String content) async {
    try {
      if (content.isEmpty) return false;

      final prefs = await SharedPreferences.getInstance();
      final List<String> entries = await getEntries();
      entries.add(content);
      return await prefs.setStringList(_key, entries);
    } catch (e) {
      print('Error saving diary entry: $e');
      return false;
    }
  }

  static Future<List<String>> getEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return _getEntriesSync(prefs);
    } catch (e) {
      print('Error retrieving diary entries: $e');
      return [];
    }
  }

  static List<String> _getEntriesSync(SharedPreferences prefs) {
    try {
      return prefs.getStringList(_key) ?? [];
    } catch (e) {
      print('Error in sync entries retrieval: $e');
      return [];
    }
  }

  static Future<bool> deleteEntry(int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> entries = await getEntries();
      if (index >= 0 && index < entries.length) {
        entries.removeAt(index);
        return await prefs.setStringList(_key, entries);
      }
      return false;
    } catch (e) {
      print('Error deleting diary entry: $e');
      return false;
    }
  }

  static Future<bool> updateEntry(int index, String newContent) async {
    try {
      if (newContent.isEmpty) return false;

      final prefs = await SharedPreferences.getInstance();
      final List<String> entries = await getEntries();
      if (index >= 0 && index < entries.length) {
        entries[index] = newContent;
        return await prefs.setStringList(_key, entries);
      }
      return false;
    } catch (e) {
      print('Error updating diary entry: $e');
      return false;
    }
  }

  static Future<bool> clearAllEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_key);
    } catch (e) {
      print('Error clearing all entries: $e');
      return false;
    }
  }
}
