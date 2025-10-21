// services/progress_service.dart
import 'package:flutter/foundation.dart';

class ProgressService with ChangeNotifier {
  // Gita Reading Progress
  int _chaptersRead = 0;
  int _versesRead = 0;
  String _lastGitaRead = 'Never';
  int _favoriteChapter = 1;

  // Japa Progress
  int _totalJapaCount = 0;
  int _dailyJapaAverage = 0;
  int _japaCurrentStreak = 0;
  int _japaLongestStreak = 0;

  // Quiz Progress
  int _quizzesTaken = 0;
  double _quizAverageScore = 0;
  int _quizHighestScore = 0;
  int _totalQuestionsAnswered = 0;

  // Overall Progress
  int _currentStreak = 0;
  int _longestStreak = 0;
  String _lastActiveDate = 'Today';

  // Gita Methods
  void markChapterAsRead(int chapterNumber) {
    _chaptersRead++;
    _lastGitaRead = _formatDate(DateTime.now());
    _updateStreak();
    notifyListeners();
  }

  void markVerseAsRead(int count) {
    _versesRead += count;
    _lastGitaRead = _formatDate(DateTime.now());
    _updateStreak();
    notifyListeners();
  }

  // Japa Methods
  void addJapaCount(int count) {
    _totalJapaCount += count;
    _dailyJapaAverage = _totalJapaCount ~/ (_currentStreak > 0 ? _currentStreak : 1);
    _updateStreak();
    notifyListeners();
  }

  // Quiz Methods
  void addQuizResult(int score, int questionCount) {
    _quizzesTaken++;
    _totalQuestionsAnswered += questionCount;

    // Update average score
    _quizAverageScore = ((_quizAverageScore * (_quizzesTaken - 1)) + score) / _quizzesTaken;

    // Update highest score
    if (score > _quizHighestScore) {
      _quizHighestScore = score;
    }

    _updateStreak();
    notifyListeners();
  }

  // Streak Management
  void _updateStreak() {
    final today = DateTime.now();
    _lastActiveDate = _formatDate(today);
    _currentStreak++; // In real app, you'd check if user was active yesterday
    if (_currentStreak > _longestStreak) {
      _longestStreak = _currentStreak;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Getters
  Map<String, dynamic> getUserStats() {
    return {
      // Gita Stats
      'chaptersRead': _chaptersRead,
      'versesRead': _versesRead,
      'lastGitaRead': _lastGitaRead,
      'favoriteChapter': 'Chapter $_favoriteChapter',

      // Japa Stats
      'totalJapaCount': _totalJapaCount,
      'dailyJapaAverage': _dailyJapaAverage,
      'japaCurrentStreak': _japaCurrentStreak,
      'japaLongestStreak': _japaLongestStreak,

      // Quiz Stats
      'quizzesTaken': _quizzesTaken,
      'quizAverageScore': _quizAverageScore,
      'quizHighestScore': _quizHighestScore,
      'totalQuestionsAnswered': _totalQuestionsAnswered,

      // Overall Stats
      'currentStreak': _currentStreak,
      'longestStreak': _longestStreak,
      'lastActiveDate': _lastActiveDate,
    };
  }

  // For testing - add some sample data
  void initializeWithSampleData() {
    _chaptersRead = 5;
    _versesRead = 127;
    _totalJapaCount = 3250;
    _quizzesTaken = 8;
    _quizAverageScore = 75.5;
    _quizHighestScore = 90;
    _currentStreak = 7;
    _longestStreak = 12;
    notifyListeners();
  }
}