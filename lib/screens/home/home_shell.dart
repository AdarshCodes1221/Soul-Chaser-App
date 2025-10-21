import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/gita_service.dart';
import '../japa/japa_screen.dart';
import '../quiz/quiz_screen.dart';
import '../profile/profile_screen.dart';
import '../gita/gita_screen.dart';
import '../progress/progress_screen.dart'; // ✅ Added for Progress navigation
import '../auth/login_screen.dart'; // ✅ Import LoginScreen

class HomeShell extends StatefulWidget {
  static const route = '/home';
  final int? initialIndex;

  const HomeShell({super.key, this.initialIndex});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  final _pages = const [
    _Dashboard(),
    JapaScreen(),
    QuizScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFF176),
                  Color(0xFFFFA726),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Opacity(
              opacity: 0.08,
              child: Center(
                child: Transform.rotate(
                  angle: -0.2,
                  child: Text(
                    'राधे राधे',
                    style: TextStyle(
                      fontSize: 120,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE65100),
                      fontFamily: 'NotoSansDevanagari',
                    ),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: _pages[_index],
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.24),
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFF176).withOpacity(0.8),
              Color(0xFFFFA726).withOpacity(0.8),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFFFF176), Color(0xFFFFA726)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Text(
              'ॐ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'NotoSansDevanagari',
              ),
            ),
          ),
          SizedBox(width: 12),
          Text(
            'Soul Chaser',
            style: TextStyle(
              color: Color(0xFF5D4037),
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.logout, color: Color(0xFF5D4037)),
          tooltip: 'Logout',
          onPressed: () => _confirmLogout(context),
        ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        child: NavigationBar(
          height: 70,
          selectedIndex: _index,
          backgroundColor: Colors.white.withOpacity(0.9),
          indicatorColor: Color(0xFFFFA726).withOpacity(0.3),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Color(0xFF5D4037)),
              selectedIcon: Icon(Icons.home, color: Color(0xFFE65100)),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.timer_outlined, color: Color(0xFF5D4037)),
              selectedIcon: Icon(Icons.timer, color: Color(0xFFE65100)),
              label: 'Japa',
            ),
            NavigationDestination(
              icon: Icon(Icons.quiz_outlined, color: Color(0xFF5D4037)),
              selectedIcon: Icon(Icons.quiz, color: Color(0xFFE65100)),
              label: 'Quiz',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outlined, color: Color(0xFF5D4037)),
              selectedIcon: Icon(Icons.person, color: Color(0xFFE65100)),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Logout', style: TextStyle(color: Color(0xFFE65100))),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE65100),
            ),
            onPressed: () async {
              Navigator.pop(ctx); // Close dialog
              await context.read<AuthService>().logout(); // Perform logout

              // Navigate to LoginScreen and remove all previous routes
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(), // Your LoginScreen
                ),
                    (route) => false,
              );
            },
            child: Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        Center(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFFFF176), Color(0xFFFFA726)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Text(
              'ॐ',
              style: TextStyle(
                fontSize: 60,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoSansDevanagari',
              ),
            ),
          ),
        ),
        SizedBox(height: 30),
        _buildQuoteCard(),
        SizedBox(height: 20),
        _buildWelcomeCard(),
        SizedBox(height: 30),
        _buildQuickActions(context),
      ],
    );
  }

  Widget _buildQuoteCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.format_quote, color: Color(0xFFFFA726), size: 30),
            SizedBox(height: 10),
            Text(
              '"Set your heart upon your work, but never on its reward."',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF5D4037),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              '— Bhagavad Gita 2.47',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFE65100),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white.withOpacity(0.85),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Soul Chaser!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE65100),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Your spiritual companion for:\n\n'
                  '• Japa meditation tracking\n'
                  '• Bhagavad Gita quizzes\n'
                  '• Spiritual progress insights',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF5D4037),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      padding: EdgeInsets.symmetric(horizontal: 10),
      children: [
        _buildActionButton(
          context,
          icon: Icons.timer,
          label: 'Start Japa',
          color: Color(0xFFFFF176),
          onTap: () {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => HomeShell(initialIndex: 1),
                transitionsBuilder: (_, animation, __, child) =>
                    FadeTransition(opacity: animation, child: child),
              ),
            );
          },
        ),
        _buildActionButton(
          context,
          icon: Icons.quiz,
          label: 'Take Quiz',
          color: Color(0xFFFFCC80),
          onTap: () {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => HomeShell(initialIndex: 2),
                transitionsBuilder: (_, animation, __, child) =>
                    FadeTransition(opacity: animation, child: child),
              ),
            );
          },
        ),
        _buildActionButton(
          context,
          icon: Icons.insights,
          label: 'Progress',
          color: Color(0xFFFFE0B2),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ProgressScreen(),
              ),
            );
          },
        ),
        _buildActionButton(
          context,
          icon: Icons.book,
          label: 'Gita',
          color: Color(0xFFFFECB3),
          onTap: () async {
            await GitaService.loadChapters();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => GitaScreen(
                  chapters: GitaService.getChapters(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
        required VoidCallback onTap,
      }) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.7),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Color(0xFFE65100)),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF5D4037),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
