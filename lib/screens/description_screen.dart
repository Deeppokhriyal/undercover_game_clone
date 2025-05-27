import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
      await _controller.reverse();
      setState(() => currentIndex++);
      await _controller.forward();
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
      body: SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              Card(
                color: Colors.deepPurple.shade700,
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${player.name}, describe your word:",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'nexaheavy',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        onChanged: (value) {
                          descriptions[player.name] = value;
                        },
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'nexalight',
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          labelText: "Description (don't say the word!)",
                          labelStyle: const TextStyle(
                            color: Colors.white70,
                            fontFamily: 'nexalight',
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Colors.deepPurple.shade400,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        ),
                        maxLines: 3,
                        cursorColor: Colors.white,
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _next,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.deepPurple.shade800,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            "Next",
                            style: TextStyle(
                              fontFamily: 'nexaheavy',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 250,
                child: Lottie.asset(
                  'assets/animations/ANIM.json',
                  repeat: true,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    ),

    );
  }
}
