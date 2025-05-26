import 'package:flutter/material.dart';
// import '../models/player.dart';
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
    if (currentIndex < widget.players.length - 1) {
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
    final player = widget.players.where((p) => !p.eliminated).toList()[currentIndex];
    return Scaffold(
      appBar: AppBar(title: Text("Describe Your Word")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("${player.name}, describe your word:",
                style: TextStyle(fontSize: 18)),
            TextField(
              onChanged: (value) {
                descriptions[player.name] = value;
              },
              decoration: InputDecoration(labelText: "Description (don't say the word!)"),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _next,
              child: Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
