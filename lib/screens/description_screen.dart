import 'package:flutter/material.dart';
import '../models/players.dart';
import 'voting_screen.dart';

class DescriptionScreen extends StatefulWidget {
  final List<Player> players;
  DescriptionScreen({required this.players});

  @override
  _DescriptionScreenState createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  int currentIndex = 0;
  final Map<String, String> descriptions = {};

  void _next() {
    if (currentIndex < widget.players.where((p) => !p.eliminated).length - 1) {
      setState(() => currentIndex++);
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
  Widget build(BuildContext context) {
    final activePlayers = widget.players.where((p) => !p.eliminated).toList();
    final player = activePlayers[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("Describe Your Word", style: TextStyle(fontFamily: 'nexaheavy')),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.deepPurple, Colors.indigo]),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Card(
          color: Colors.deepPurple,
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${player.name}, describe your word:",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: 'nexaheavy',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    descriptions[player.name] = value;
                  },
                  style: TextStyle(color: Colors.white, fontFamily: 'nexalight'),
                  decoration: InputDecoration(
                    labelText: "Description (don't say the word!)",
                    labelStyle: TextStyle(color: Colors.white70, fontFamily: 'nexalight'),
                    filled: true,
                    fillColor: Colors.deepPurple.shade400,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      "Next",
                      style: TextStyle(fontFamily: 'nexaheavy', fontSize: 16),
                    ),
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
