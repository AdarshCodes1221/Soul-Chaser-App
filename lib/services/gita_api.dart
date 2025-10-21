import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class GitaApi {
  static List<dynamic>? _cachedChapters;
  static const String _assetPath = 'assets/gita.json/verse.json'; // Update if path changes

  static Future<List<dynamic>> getChapters() async {
    if (_cachedChapters != null) return _cachedChapters!;

    try {
      final jsonString = await rootBundle.loadString(_assetPath);
      final data = json.decode(jsonString);

      // Handle both list and map formats
      List<dynamic> verses;
      if (data is List) {
        verses = data;
      } else if (data is Map) {
        verses = data.values.expand((v) => v).toList();
      } else {
        throw Exception('Unexpected JSON format');
      }

      _cachedChapters = _convertToChapterList(verses);
      return _cachedChapters!;
    } catch (e) {
      debugPrint('Error loading Gita data: $e');
      throw Exception('Failed to load chapters from local data');
    }
  }

  static Future<List<dynamic>> getVerses(int chapterNumber) async {
    final chapters = await getChapters();
    final chapter = chapters.firstWhere(
          (ch) => ch['chapter_number'] == chapterNumber,
      orElse: () => throw Exception('Chapter $chapterNumber not found'),
    );
    return chapter['verses'] ?? [];
  }

  static List<dynamic> _convertToChapterList(List<dynamic> verses) {
    final Map<int, dynamic> chapterMap = {};

    for (final verse in verses) {
      final chapterNum = verse['chapter'];
      if (!chapterMap.containsKey(chapterNum)) {
        chapterMap[chapterNum] = {
          'chapter_number': chapterNum,
          'name': _getChapterName(chapterNum),
          'verses': [],
        };
      }
      chapterMap[chapterNum]!['verses'].add({
        'verse_number': verse['verse'],
        'text': verse['text'],
        'translation': verse['translation'],
      });
    }

    return chapterMap.values.toList()
      ..sort((a, b) => a['chapter_number'].compareTo(b['chapter_number']));
  }

  static String _getChapterName(int chapter) {
    const names = {
      1: "Arjuna Vishada Yoga",
      2: "Sankhya Yoga",
      3: "Karma Yoga",
      4: "Jnana Yoga",
      5: "Karma Vairagya Yoga",
      6: "Abhyasa Yoga",
      7: "Paramahamsa Vijnana Yoga",
      8: "Aksara Brahma Yoga",
      9: "Raja Vidya Yoga",
      10: "Vibhuti Yoga",
      11: "Vishwaroopa Darshana Yoga",
      12: "Bhakti Yoga",
      13: "Kshetra Kshetrajna Vibhaga Yoga",
      14: "Gunatraya Vibhaga Yoga",
      15: "Purushottama Yoga",
      16: "Daivasura Sampad Vibhaga Yoga",
      17: "Shraddhatraya Vibhaga Yoga",
      18: "Moksha Sannyasa Yoga"
    };
    return names[chapter] ?? "Chapter $chapter";
  }
}
