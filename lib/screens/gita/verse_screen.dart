import 'package:flutter/material.dart';

class VerseScreen extends StatelessWidget {
  final String chapterName;
  final List<dynamic> verses;

  const VerseScreen({
    super.key,
    required this.chapterName,
    required this.verses,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chapterName),
      ),
      body: ListView.builder(
        itemCount: verses.length,
        itemBuilder: (context, index) {
          final verse = verses[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Verse ${verse["verse_number"] ?? verse["verseNumber"] ?? index + 1}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    verse["text"] ?? "",
                    style: const TextStyle(fontSize: 16, fontFamily: "NotoSansDevanagari"),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    verse["transliteration"] ?? "",
                    style: const TextStyle(
                        fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Word meanings: ${verse["word_meanings"] ?? verse["wordMeanings"] ?? ""}",
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}