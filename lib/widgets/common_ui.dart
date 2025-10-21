import 'package:flutter/material.dart';

// --- SCButton ---
class SCButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool loading;
  final Color color;
  final Color textColor;
  const SCButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.color = const Color(0xFFF9A825), // yellow
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: loading ? null : onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: loading
              ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : Text(label),
        ),
      ),
    );
  }
}

// --- SCTextField ---
class SCTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  final TextInputAction action;
  final TextInputType keyboardType;
  final Color borderColor;
  const SCTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscure = false,
    this.action = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.borderColor = const Color(0xFFFF7043), // orange
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      textInputAction: action,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: borderColor, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 2.5),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

// --- TEST WIDGET ---
class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF9A825), Color(0xFFFF7043)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                color: Colors.white.withOpacity(0.93),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Om logo
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: const Color(0xFFFF7043),
                        child: Text(
                          'ॐ',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF9A825),
                            fontFamily: 'NotoSansDevanagari', // Optional - change font if you want
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'ISKCON Themed Login',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Color(0xFFFF7043),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      SCTextField(
                        controller: _emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        borderColor: Color(0xFFFF7043),
                      ),
                      const SizedBox(height: 12),
                      SCTextField(
                        controller: _passwordController,
                        label: 'Password',
                        obscure: true,
                        action: TextInputAction.done,
                        borderColor: Color(0xFFF9A825),
                      ),
                      const SizedBox(height: 16),
                      SCButton(
                        label: 'Log in',
                        onPressed: () {
                          setState(() => _loading = true);
                          Future.delayed(const Duration(seconds: 2), () {
                            setState(() => _loading = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Logged in (demo)!")));
                          });
                        },
                        loading: _loading,
                        color: Color(0xFFF9A825),
                        textColor: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Create a new account',
                          style: TextStyle(color: Color(0xFFFF7043)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- MAIN ENTRY POINT TO RUN TEST ---
void main() {
  runApp(const MaterialApp(home: TestWidget()));
}
