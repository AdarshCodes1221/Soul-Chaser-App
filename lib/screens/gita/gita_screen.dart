import 'package:flutter/material.dart';
import '../../services/gita_service.dart';
import 'verse_screen.dart';

class GitaScreen extends StatefulWidget {
  const GitaScreen({super.key, required List<dynamic> chapters});

  @override
  State<GitaScreen> createState() => _GitaScreenState();
}

class _GitaScreenState extends State<GitaScreen> {
  List<dynamic> chapters = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadChapters();
  }

  Future<void> _loadChapters() async {
    try {
      await GitaService.loadChapters();
      setState(() {
        chapters = GitaService.getChapters();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load chapters: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bhagavad Gita"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : ListView.builder(
        itemCount: chapters.length,
        itemBuilder: (context, index) {
          final chapter = chapters[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${chapter['chapter_number']}'),
              ),
              title: Text(
                chapter["name"] ?? "Chapter ${chapter['chapter_number']}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(chapter["summary"] ?? ""),
                  const SizedBox(height: 4),
                  Text(
                    "Verses: ${chapter['verse_count'] ?? 'N/A'}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              onTap: () {
                final verses = GitaService.getVersesForChapter(
                  chapter["chapter_number"],
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VerseScreen(
                      chapterName: chapter["name"] ?? "Chapter ${chapter['chapter_number']}",
                      verses: verses,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}