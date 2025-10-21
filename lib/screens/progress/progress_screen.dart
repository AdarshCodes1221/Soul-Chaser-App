import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/progress_service.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Spiritual Progress'),
        backgroundColor: Colors.orange[700],
      ),
      body: Consumer<ProgressService>(
        builder: (context, progressService, child) {
          final stats = progressService.getUserStats();
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Overall Progress Card
                _buildOverallProgressCard(stats),
                const SizedBox(height: 20),

                // Gita Reading Progress
                _buildGitaProgressCard(stats),
                const SizedBox(height: 20),

                // Japa Progress
                _buildJapaProgressCard(stats),
                const SizedBox(height: 20),

                // Quiz Progress
                _buildQuizProgressCard(stats),
                const SizedBox(height: 20),

                // Daily Streak
                _buildStreakCard(stats),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverallProgressCard(Map<String, dynamic> stats) {
    final totalChapters = 18;
    final chaptersRead = stats['chaptersRead'] ?? 0;
    final totalVerses = 700;
    final versesRead = stats['versesRead'] ?? 0;
    final totalJapa = stats['totalJapaCount'] ?? 0;
    final quizzesTaken = stats['quizzesTaken'] ?? 0;

    final overallProgress = ((chaptersRead / totalChapters) * 0.4 +
        (versesRead / totalVerses) * 0.3 +
        (quizzesTaken / 50) * 0.2 +
        (totalJapa / 10000) * 0.1).clamp(0.0, 1.0);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.insights, color: Colors.orange[700], size: 32),
                const SizedBox(width: 12),
                Text(
                  'Overall Progress',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: overallProgress,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange[700]!),
                  ),
                ),
                Text(
                  '${(overallProgress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatRow('Chapters Read', '$chaptersRead/$totalChapters'),
            _buildStatRow('Verses Read', '$versesRead/$totalVerses'),
            _buildStatRow('Japa Count', totalJapa.toString()),
            _buildStatRow('Quizzes Taken', quizzesTaken.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildGitaProgressCard(Map<String, dynamic> stats) {
    final chaptersRead = stats['chaptersRead'] ?? 0;
    final versesRead = stats['versesRead'] ?? 0;
    final lastRead = stats['lastGitaRead'] ?? 'Never';
    final favoriteChapter = stats['favoriteChapter'] ?? 'Not available';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.book, color: Colors.green[700], size: 28),
                const SizedBox(width: 12),
                Text(
                  'Bhagavad Gita Progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: chaptersRead / 18,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
            ),
            const SizedBox(height: 8),
            Text(
              'Chapters: $chaptersRead/18 (${((chaptersRead / 18) * 100).toInt()}%)',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            _buildStatRow('Verses Read', versesRead.toString()),
            _buildStatRow('Last Read', lastRead),
            _buildStatRow('Favorite Chapter', favoriteChapter),
          ],
        ),
      ),
    );
  }

  Widget _buildJapaProgressCard(Map<String, dynamic> stats) {
    final totalJapa = stats['totalJapaCount'] ?? 0;
    final dailyAverage = stats['dailyJapaAverage'] ?? 0;
    final currentStreak = stats['japaCurrentStreak'] ?? 0;
    final longestStreak = stats['japaLongestStreak'] ?? 0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: Colors.purple[700], size: 28),
                const SizedBox(width: 12),
                Text(
                  'Japa Meditation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatRow('Total Japa Count', totalJapa.toString()),
            _buildStatRow('Daily Average', '$dailyAverage/day'),
            _buildStatRow('Current Streak', '$currentStreak days 🔥'),
            _buildStatRow('Longest Streak', '$longestStreak days'),
            const SizedBox(height: 12),
            if (totalJapa > 0)
              LinearProgressIndicator(
                value: (totalJapa % 108) / 108,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[700]!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizProgressCard(Map<String, dynamic> stats) {
    final quizzesTaken = stats['quizzesTaken'] ?? 0;
    final averageScore = stats['quizAverageScore'] ?? 0;
    final highestScore = stats['quizHighestScore'] ?? 0;
    final totalQuestions = stats['totalQuestionsAnswered'] ?? 0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.quiz, color: Colors.blue[700], size: 28),
                const SizedBox(width: 12),
                Text(
                  'Gita Quizzes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatRow('Quizzes Taken', quizzesTaken.toString()),
            _buildStatRow('Average Score', '${averageScore.toStringAsFixed(1)}%'),
            _buildStatRow('Highest Score', '$highestScore%'),
            _buildStatRow('Questions Answered', totalQuestions.toString()),
            const SizedBox(height: 12),
            if (quizzesTaken > 0)
              LinearProgressIndicator(
                value: averageScore / 100,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard(Map<String, dynamic> stats) {
    final currentStreak = stats['currentStreak'] ?? 0;
    final longestStreak = stats['longestStreak'] ?? 0;
    final lastActive = stats['lastActiveDate'] ?? 'Today';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_fire_department, color: Colors.red[700], size: 32),
                const SizedBox(width: 12),
                Text(
                  'Daily Streak',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Text(
                    '$currentStreak',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const Text(
                    'days in a row!',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow('Longest Streak', '$longestStreak days'),
            _buildStatRow('Last Active', lastActive),
            if (currentStreak > 0)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Keep going! Your dedication is inspiring. 🎯',
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}