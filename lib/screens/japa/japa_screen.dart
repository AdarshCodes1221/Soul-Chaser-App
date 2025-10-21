import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class JapaScreen extends StatefulWidget {
  static const route = '/japa';
  const JapaScreen({super.key});

  @override
  State<JapaScreen> createState() => _JapaScreenState();
}

class _JapaScreenState extends State<JapaScreen> {
  int _count = 0;
  bool _running = false;
  Timer? _holdTimer;

  // Constants
  final int _target = 108;
  final double _circleSize = 280;

  void _start() => setState(() => _running = true);

  void _pause() {
    _stopHoldTimer();
    setState(() => _running = false);
  }

  void _reset() {
    _stopHoldTimer();
    setState(() {
      _running = false;
      _count = 0;
    });
  }

  void _stopHoldTimer() {
    _holdTimer?.cancel();
    _holdTimer = null;
  }

  // Called when user presses down on the center mantra area
  void _onCenterTapDown(TapDownDetails _) {
    if (!_running) return;

    // immediate single increment
    if (_count < _target) {
      setState(() => _count++);
    }

    // then start periodic increments while the finger remains down
    _stopHoldTimer();
    _holdTimer = Timer.periodic(const Duration(milliseconds: 220), (_) {
      if (!mounted) return;
      setState(() {
        if (_count < _target) {
          _count++;
        } else {
          _stopHoldTimer();
        }
      });
    });
  }

  // When finger lifts or gesture cancels
  void _onCenterTapUp([TapUpDetails? _]) => _stopHoldTimer();
  void _onCenterTapCancel() => _stopHoldTimer();

  @override
  void dispose() {
    _stopHoldTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double size = _circleSize;
    final double center = size / 2;
    final double beadRadius = center - 28; // radius where beads sit

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [Color(0xFFFFF9C4), Color(0xFFFFE0B2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Header with beads counter
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCounterCard("Today", _count.toString(), const Color(0xFFFFCC80)),
                  _buildCounterCard("Target", _target.toString(), const Color(0xFFFFA726)),
                ],
              ),
            ),

            // Mala visualization and touch area
            Expanded(
              child: Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: _onCenterTapDown,
                  onTapUp: _onCenterTapUp,
                  onTapCancel: _onCenterTapCancel,
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF5D4037), width: 2),
                    ),
                    child: Stack(
                      children: [
                        // Beads (Positioned relative to this Stack)
                        ...List.generate(108, (index) {
                          final angle = (index / 108.0) * 2 * pi;
                          final x = center + beadRadius * cos(angle);
                          final y = center + beadRadius * sin(angle);
                          final counted = index < _count;
                          return Positioned(
                            left: x - 6, // bead width/2
                            top: y - 6,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: counted ? Colors.orange : const Color(0xFF5D4037),
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        }),

                        // Circular mantra — sized to the parent so positions are correct
                        SizedBox(
                          width: size,
                          height: size,
                          child: _buildCircularMantra(size),
                        ),

                        // small center overlay showing the count
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Count',
                                  style: TextStyle(
                                    color: Colors.brown[700],
                                  ),
                                ),
                                Text(
                                  '$_count',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF5D4037),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Controls
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(onTap: _start, child: _buildControlButton(Icons.play_arrow, "Start")),
                  GestureDetector(onTap: _pause, child: _buildControlButton(Icons.pause, "Pause")),
                  GestureDetector(onTap: _reset, child: _buildControlButton(Icons.replay, "Reset")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularMantra(double size) {
    // The full mantra (Hindi) repeated (you can change text as you want)
    const mantra = "हरे कृष्ण हरे कृष्ण कृष्ण कृष्ण हरे हरे हरे राम हरे राम राम राम हरे हरे ";
    final runes = mantra.runes.toList();
    final int mlen = runes.length;
    final double center = size / 2;
    final double radius = center - 60; // where letters sit

    return Stack(
      children: List.generate(mlen, (i) {
        final char = String.fromCharCode(runes[i]);
        final angle = (i / mlen) * 2 * pi - pi / 2; // start at top
        final x = center + radius * cos(angle);
        final y = center + radius * sin(angle);

        return Positioned(
          left: x - 6, // rough horizontal center for each character
          top: y - 6,
          child: Transform.rotate(
            angle: angle + pi / 2, // rotate so the letters follow the curve
            child: Text(
              char,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'NotoSansDevanagari', // optional — fallback used if not present
                color: Color(0xFF5D4037),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCounterCard(String title, String value, Color color) {
    return Card(
      elevation: 3,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(title, style: const TextStyle(color: Colors.white)),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: const Color(0xFF5D4037),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Color(0xFF5D4037))),
      ],
    );
  }
}
