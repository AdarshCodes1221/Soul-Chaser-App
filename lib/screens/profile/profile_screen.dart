import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../screens/services/progress_service.dart';
import '../progress/progress_screen.dart';
import '../japa/japa_screen.dart';
import '../services/progress_service.dart';

class ProfileScreen extends StatelessWidget {
  static const route = '/profile';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().currentUser;
    final progressService = Provider.of<ProgressService>(context, listen: true);
    final stats = progressService.getUserStats();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF9C4), Color(0xFFFFCC80)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Profile header
            Container(
              padding: EdgeInsets.only(top: 50, bottom: 30),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFF5D4037),
                    child: Text(
                      user?.displayName?.substring(0, 1) ?? 'D',
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    user?.displayName ?? 'Devotee',
                    style: TextStyle(fontSize: 24, color: Color(0xFF5D4037)),
                  ),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(color: Color(0xFFE65100)),
                  ),
                ],
              ),
            ),

            // Stats cards
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  _buildStatCard('Japa', '${stats['totalJapaCount'] ?? 0}'),
                  _buildStatCard('Quizzes', '${stats['quizzesTaken'] ?? 0}'),
                  _buildStatCard('Verses', '${stats['versesRead'] ?? 0}'),
                ],
              ),
            ),

            // Settings list
            Expanded(
              child: ListView(
                children: [
                  _buildListTile(
                    Icons.history,
                    'Japa History',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => JapaScreen()),
                      );
                    },
                  ),
                  _buildListTile(
                    Icons.leaderboard,
                    'Progress & Analytics',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ProgressScreen()),
                      );
                    },
                  ),
                  _buildListTile(
                    Icons.notifications,
                    'Reminders & Notifications',
                    onTap: () {
                      _showRemindersSettings(context);
                    },
                  ),
                  _buildListTile(
                    Icons.settings,
                    'App Settings',
                    onTap: () {
                      _showAppSettings(context);
                    },
                  ),
                  _buildListTile(
                    Icons.help,
                    'Help & Support',
                    onTap: () {
                      _showHelpSupport(context);
                    },
                  ),
                  _buildListTile(
                    Icons.info,
                    'About App',
                    onTap: () {
                      _showAboutApp(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Expanded(
      child: Card(
        elevation: 3,
        color: Colors.white.withOpacity(0.7),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Text(title, style: TextStyle(color: Color(0xFF5D4037))),
              Text(value, style: TextStyle(
                color: Color(0xFFE65100),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, {VoidCallback? onTap}) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      color: Colors.white.withOpacity(0.7),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF5D4037)),
        title: Text(title, style: TextStyle(color: Color(0xFF5D4037))),
        trailing: Icon(Icons.chevron_right, color: Color(0xFFE65100)),
        onTap: onTap,
      ),
    );
  }

  void _showRemindersSettings(BuildContext context) {
    bool morningReminder = true;
    bool eveningReminder = false;
    bool japaReminder = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Reminders & Notifications'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildReminderSwitch(
                    'Morning Prayer Reminder',
                    '7:00 AM',
                    morningReminder,
                        (value) => setState(() => morningReminder = value),
                  ),
                  _buildReminderSwitch(
                    'Evening Prayer Reminder',
                    '7:00 PM',
                    eveningReminder,
                        (value) => setState(() => eveningReminder = value),
                  ),
                  _buildReminderSwitch(
                    'Daily Japa Reminder',
                    '8:00 PM',
                    japaReminder,
                        (value) => setState(() => japaReminder = value),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Save reminder settings
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Reminder settings saved')),
                      );
                    },
                    child: Text('Save Settings'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE65100),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReminderSwitch(String title, String time, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      title: Text(title),
      subtitle: Text(time),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Color(0xFFE65100),
      ),
    );
  }

  void _showAppSettings(BuildContext context) {
    bool darkMode = false;
    bool sanskritText = true;
    bool englishTranslation = true;
    bool vibration = true;
    bool sound = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('App Settings'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSettingSwitch(
                    'Dark Mode',
                    'Switch to dark theme',
                    darkMode,
                        (value) => setState(() => darkMode = value),
                  ),
                  _buildSettingSwitch(
                    'Sanskrit Text',
                    'Show original Sanskrit verses',
                    sanskritText,
                        (value) => setState(() => sanskritText = value),
                  ),
                  _buildSettingSwitch(
                    'English Translation',
                    'Show English translations',
                    englishTranslation,
                        (value) => setState(() => englishTranslation = value),
                  ),
                  _buildSettingSwitch(
                    'Vibration',
                    'Haptic feedback',
                    vibration,
                        (value) => setState(() => vibration = value),
                  ),
                  _buildSettingSwitch(
                    'Sound',
                    'App sounds and notifications',
                    sound,
                        (value) => setState(() => sound = value),
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 8),
                  ListTile(
                    title: Text('Font Size'),
                    subtitle: Text('Medium'),
                    trailing: Icon(Icons.arrow_drop_down),
                    onTap: () {
                      _showFontSizeDialog(context);
                    },
                  ),
                  ListTile(
                    title: Text('Language'),
                    subtitle: Text('English'),
                    trailing: Icon(Icons.arrow_drop_down),
                    onTap: () {
                      _showLanguageDialog(context);
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Save app settings
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('App settings saved')),
                      );
                    },
                    child: Text('Save Settings'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE65100),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingSwitch(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Color(0xFFE65100),
      ),
    );
  }

  void _showFontSizeDialog(BuildContext context) {
    String selectedSize = 'Medium';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Font Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFontSizeOption(context, 'Small', selectedSize),
            _buildFontSizeOption(context, 'Medium', selectedSize),
            _buildFontSizeOption(context, 'Large', selectedSize),
            _buildFontSizeOption(context, 'Extra Large', selectedSize),
          ],
        ),
      ),
    );
  }

  Widget _buildFontSizeOption(BuildContext context, String size, String selected) {
    return ListTile(
      title: Text(size),
      trailing: selected == size ? Icon(Icons.check, color: Color(0xFFE65100)) : null,
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Font size set to $size')),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    String selectedLanguage = 'English';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(context, 'English', selectedLanguage),
            _buildLanguageOption(context, 'Hindi', selectedLanguage),
            _buildLanguageOption(context, 'Sanskrit', selectedLanguage),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, String language, String selected) {
    return ListTile(
      title: Text(language),
      trailing: selected == language ? Icon(Icons.check, color: Color(0xFFE65100)) : null,
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Language set to $language')),
        );
      },
    );
  }

  void _showHelpSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Help & Support'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpOption(
                Icons.email,
                'Contact Support',
                'Get help via email',
                onTap: () {
                  // Open email
                  Navigator.pop(context);
                },
              ),
              _buildHelpOption(
                Icons.help_outline,
                'FAQs',
                'Frequently asked questions',
                onTap: () {
                  // Show FAQs
                  Navigator.pop(context);
                },
              ),
              _buildHelpOption(
                Icons.bug_report,
                'Report Bug',
                'Report an issue',
                onTap: () {
                  // Report bug
                  Navigator.pop(context);
                },
              ),
              _buildHelpOption(
                Icons.lightbulb_outline,
                'Suggest Feature',
                'Share your ideas',
                onTap: () {
                  // Suggest feature
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpOption(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF5D4037)),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }

  void _showAboutApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('About Soul Chaser'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFF176), Color(0xFFFFA726)],
                    ),
                  ),
                  child: Text(
                    'ॐ',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Soul Chaser v1.0.0',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Your spiritual companion for daily meditation, Gita study, and self-improvement.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              Text(
                'Features:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Japa Meditation Counter'),
              Text('• Bhagavad Gita Reader'),
              Text('• Spiritual Quizzes'),
              Text('• Progress Tracking'),
              SizedBox(height: 16),
              Text('Made with ❤️ for spiritual seekers'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}