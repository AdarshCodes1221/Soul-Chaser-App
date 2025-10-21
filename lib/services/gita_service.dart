import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class GitaService {
  static List<dynamic> _chapters = [];
  static List<dynamic> _verses = [];

  /// Load chapters from assets/gita/verse.json
  static Future<void> loadChapters() async {
    if (_chapters.isNotEmpty) return;
    try {
      final jsonString = await rootBundle.loadString('assets/gita/verse.json');
      final data = json.decode(jsonString);

      // Handle different JSON structures
      if (data is List) {
        _verses = data;
      } else if (data is Map && data.containsKey('verses')) {
        _verses = data['verses'];
      } else {
        _verses = [data]; // Single verse object
      }

      // Extract unique chapters from verses
      _chapters = _extractChaptersFromVerses(_verses);

      print('✅ Chapters loaded: ${_chapters.length}');
      print('✅ Verses loaded: ${_verses.length}');
    } catch (e) {
      print("Error loading Gita data: $e");
      rethrow;
    }
  }

  /// Load verses from assets/gita/verse.json
  static Future<void> loadVerses() async {
    // Verses are already loaded with chapters in this JSON structure
    if (_verses.isNotEmpty) return;

    try {
      final jsonString = await rootBundle.loadString('assets/gita/verse.json');
      final data = json.decode(jsonString);

      if (data is List) {
        _verses = data;
      } else if (data is Map && data.containsKey('verses')) {
        _verses = data['verses'];
      } else {
        _verses = [data];
      }

      print('✅ Verses loaded: ${_verses.length}');
    } catch (e) {
      print("Error loading Gita verses: $e");
      rethrow;
    }
  }

  /// Extract chapters from verses data
  static List<dynamic> _extractChaptersFromVerses(List<dynamic> verses) {
    final chapters = <Map<String, dynamic>>[];
    final chapterNumbers = <int>{};

    for (var verse in verses) {
      final chapterNum = verse['chapter_number'] ?? verse['chapterNumber'];
      if (chapterNum != null && !chapterNumbers.contains(chapterNum)) {
        chapterNumbers.add(chapterNum);
        chapters.add({
          'chapter_number': chapterNum,
          'name': 'Chapter $chapterNum',
          'summary': 'Bhagavad Gita Chapter $chapterNum - ${_getChapterTitle(chapterNum)}',
          'verse_count': _getVerseCountForChapter(verses, chapterNum),
        });
      }
    }

    // Sort by chapter number
    chapters.sort((a, b) => a['chapter_number'].compareTo(b['chapter_number']));
    return chapters;
  }

  /// Get chapter title based on chapter number
  static String _getChapterTitle(int chapterNumber) {
    final chapterTitles = {
      1: "Arjuna Vishada Yoga",
      2: "Sankhya Yoga",
      3: "Karma Yoga",
      4: "Jnana Yoga",
      5: "Karma Sannyasa Yoga",
      6: "Dhyana Yoga",
      7: "Jnana Vijnana Yoga",
      8: "Aksara Brahma Yoga",
      9: "Raja Vidya Raja Guhya Yoga",
      10: "Vibhuti Yoga",
      11: "Vishvarupa Darsana Yoga",
      12: "Bhakti Yoga",
      13: "Kshetra Kshetrajna Vibhaga Yoga",
      14: "Gunatraya Vibhaga Yoga",
      15: "Purushottama Yoga",
      16: "Daivasura Sampad Vibhaga Yoga",
      17: "Shraddha Traya Vibhaga Yoga",
      18: "Moksha Sannyasa Yoga"
    };
    return chapterTitles[chapterNumber] ?? "Yoga";
  }

  /// Count verses in a chapter
  static int _getVerseCountForChapter(List<dynamic> verses, int chapterNumber) {
    return verses.where((v) => v['chapter_number'] == chapterNumber).length;
  }

  /// Get all chapters
  static List<dynamic> getChapters() => _chapters;

  /// Get verses for a chapter
  static List<dynamic> getVersesForChapter(int chapterNumber) {
    return _verses
        .where((v) => v['chapter_number'] == chapterNumber)
        .toList();
  }
}