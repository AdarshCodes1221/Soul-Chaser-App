import 'package:flutter/material.dart';
import '../data/gita_questions.dart';
import '../home/home_shell.dart';

class QuizScreen extends StatefulWidget {
  static const route = '/quiz';

  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  int? _selectedIndex;
  bool _showFeedback = false;
  bool _isCorrect = false;
  late List<Map<String, dynamic>> _questions;

  @override
  void initState() {
    super.initState();
    _questions = GitaQuestions.getAllQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Header with score and progress
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Score',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            '$_score',
                            style: TextStyle(
                              fontSize: 24,
                              color: Color(0xFFE65100),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Question',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            '${_currentQuestion + 1}/${_questions.length}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFFE65100),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: (_currentQuestion + 1) / _questions.length,
                    backgroundColor: Colors.grey[200],
                    color: Color(0xFFE65100),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),

            // Chapter and verse info
            if (_questions[_currentQuestion]['chapter'] != null)
              Container(
                padding: EdgeInsets.all(8),
                color: Color(0xFFE65100).withOpacity(0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.menu_book, size: 16, color: Color(0xFFE65100)),
                    SizedBox(width: 8),
                    Text(
                      'Chapter ${_questions[_currentQuestion]['chapter']} - ${_questions[_currentQuestion]['verse']}',
                      style: TextStyle(
                        color: Color(0xFFE65100),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

            // Question card with enhanced design
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Question Card with animation
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Question number with decorative icon
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.help_outline,
                                color: Color(0xFFE65100),
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Question ${_currentQuestion + 1}',
                                style: TextStyle(
                                  color: Color(0xFFE65100),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            _questions[_currentQuestion]['question'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    // Options with enhanced styling
                    Expanded(
                      child: ListView(
                        children: [
                          ...List.generate(
                            _questions[_currentQuestion]['options'].length,
                                (index) => _buildOptionButton(index),
                          ),
                        ],
                      ),
                    ),

                    // Feedback message with explanation
                    if (_showFeedback)
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.elasticOut,
                        margin: EdgeInsets.only(bottom: 16),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _isCorrect ? Colors.green[50] : Colors.red[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _isCorrect ? Colors.green : Colors.red,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _isCorrect ? Icons.check_circle : Icons.error,
                                  color: _isCorrect ? Colors.green : Colors.red,
                                  size: 24,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _isCorrect
                                        ? 'Excellent! Correct answer! 🙏'
                                        : 'Oops! That\'s not correct.',
                                    style: TextStyle(
                                      color: _isCorrect ? Colors.green[800] : Colors.red[800],
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Show explanation when answer is wrong
                            if (!_isCorrect && _questions[_currentQuestion]['explanation'] != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 12),
                                  Divider(color: Colors.red[300]),
                                  SizedBox(height: 8),
                                  Text(
                                    'Explanation:',
                                    style: TextStyle(
                                      color: Colors.red[800],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    _questions[_currentQuestion]['explanation'],
                                    style: TextStyle(
                                      color: Colors.red[800],
                                      fontSize: 14,
                                      height: 1.4,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.red[100],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.lightbulb_outline, size: 16, color: Colors.red[800]),
                                        SizedBox(width: 6),
                                        Text(
                                          'Remember this for next time!',
                                          style: TextStyle(
                                            color: Colors.red[800],
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                            // Show verse reference for correct answers too
                            if (_isCorrect && _questions[_currentQuestion]['explanation'] != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 12),
                                  Divider(color: Colors.green[300]),
                                  SizedBox(height: 8),
                                  Text(
                                    'Wisdom from Bhagavad Gita:',
                                    style: TextStyle(
                                      color: Colors.green[800],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    _questions[_currentQuestion]['explanation'],
                                    style: TextStyle(
                                      color: Colors.green[800],
                                      fontSize: 14,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(int index) {
    final bool isSelected = _selectedIndex == index;
    final bool isCorrectAnswer = index == _questions[_currentQuestion]['answer'];

    Color bgColor = Colors.white;
    Color fgColor = Color(0xFF5D4037);
    Color borderColor = Color(0xFFE65100);
    IconData? icon;
    Color? iconColor;

    if (_selectedIndex != null) {
      if (isCorrectAnswer) {
        bgColor = Colors.green[50]!;
        fgColor = Colors.green[800]!;
        borderColor = Colors.green;
        icon = Icons.check_circle;
        iconColor = Colors.green;
      } else if (isSelected) {
        bgColor = Colors.red[50]!;
        fgColor = Colors.red[800]!;
        borderColor = Colors.red;
        icon = Icons.cancel;
        iconColor = Colors.red;
      }
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(bottom: 12),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        elevation: isSelected ? 4 : 2,
        child: InkWell(
          onTap: _selectedIndex == null ? () => _handleAnswer(index) : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: borderColor,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                // Option letter with decorative background
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Color(0xFFE65100).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFFE65100).withOpacity(0.3)),
                  ),
                  child: Center(
                    child: Text(
                      String.fromCharCode(65 + index), // A, B, C, D
                      style: TextStyle(
                        color: Color(0xFFE65100),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    _questions[_currentQuestion]['options'][index],
                    style: TextStyle(
                      color: fgColor,
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                if (icon != null)
                  Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleAnswer(int selectedIndex) {
    final bool isCorrect = selectedIndex == _questions[_currentQuestion]['answer'];

    setState(() {
      _selectedIndex = selectedIndex;
      _showFeedback = true;
      _isCorrect = isCorrect;
      if (isCorrect) {

        _score++;
      }
    });

    // Wait 2.5 seconds before moving to next question (longer to read explanation)
    Future.delayed(Duration(milliseconds: 2500), () {
      setState(() {
        _showFeedback = false;
        if (_currentQuestion < _questions.length - 1) {
          _currentQuestion++;
          _selectedIndex = null;
        } else {
          // Quiz completed with enhanced dialog
          _showCompletionDialog();
        }
      });
    });
  }

  void _showCompletionDialog() {
    double percentage = (_score / _questions.length) * 100;
    String message;
    Color color;
    IconData icon;

    if (percentage >= 90) {
      message = 'Outstanding! You have mastered the Bhagavad Gita! 🌟';
      color = Colors.green;
      icon = Icons.emoji_events;
    } else if (percentage >= 70) {
      message = 'Excellent! Your knowledge of Gita is impressive! 🎯';
      color = Colors.blue;
      icon = Icons.star;
    } else if (percentage >= 50) {
      message = 'Good effort! Keep studying the divine wisdom! 📚';
      color = Colors.orange;
      icon = Icons.auto_awesome;
    } else {
      message = 'Keep learning! The Gita has endless wisdom to offer! 🙏';
      color = Colors.orange;
      icon = Icons.lightbulb;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Color(0xFFFFF3E0)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 64,
                color: color,
              ),
              SizedBox(height: 16),
              Text(
                'Quiz Completed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE65100),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Your Score: $_score/${_questions.length}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 18,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Navigate to home screen
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomeShell()),
                              (Route<dynamic> route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFFE65100),
                        side: BorderSide(color: Color(0xFFE65100)),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Exit to Home'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _currentQuestion = 0;
                          _score = 0;
                          _selectedIndex = null;
                          _showFeedback = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE65100),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Play Again'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}