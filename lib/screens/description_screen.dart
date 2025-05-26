import 'package:flutter/material.dart';
import '../models/players.dart';
import 'voting_screen.dart';

class DescriptionScreen extends StatefulWidget {
  final List<Player> players;
  const DescriptionScreen({required this.players, super.key});

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  final Map<String, String> descriptions = {};
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  void _next() async {
    final activePlayers = widget.players.where((p) => !p.eliminated).toList();

    if (currentIndex < activePlayers.length - 1) {
      await _controller.reverse(); // fade out
      setState(() => currentIndex++);
      await _controller.forward(); // fade in next player
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => VotingScreen(players: widget.players),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activePlayers = widget.players.where((p) => !p.eliminated).toList();
    final player = activePlayers[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Describe Your Word", style: TextStyle(fontFamily: 'nexaheavy')),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.deepPurple, Colors.indigo]),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Card(
            color: Colors.deepPurple,
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${player.name}, describe your word:",
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontFamily: 'nexaheavy',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    onChanged: (value) {
                      descriptions[player.name] = value;
                    },
                    style: const TextStyle(color: Colors.white, fontFamily: 'nexalight'),
                    decoration: InputDecoration(
                      labelText: "Description (don't say the word!)",
                      labelStyle: const TextStyle(color: Colors.white70, fontFamily: 'nexalight'),
                      filled: true,
                      fillColor: Colors.deepPurple.shade400,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Next",
                        style: TextStyle(fontFamily: 'nexaheavy', fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
