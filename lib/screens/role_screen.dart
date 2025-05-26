import 'dart:math';
import 'package:flutter/material.dart';
// import '../models/player.dart';
import '../models/players.dart';
import '../utils/word_pairs.dart';
import 'description_screen.dart';

class RoleScreen extends StatefulWidget {
  final List<Player> players;
  RoleScreen({required this.players});

  @override
  _RoleScreenState createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _assignRoles();
  }

  void _assignRoles() {
    final random = Random();
    final selectedPair = wordPairs[random.nextInt(wordPairs.length)];
    final undercoverIndex = random.nextInt(widget.players.length);

    for (int i = 0; i < widget.players.length; i++) {
      if (i == undercoverIndex) {
        widget.players[i].role = 'Undercover';
        widget.players[i].word = selectedPair[1];
      } else {
        widget.players[i].role = 'Citizen';
        widget.players[i].word = selectedPair[0];
      }
    }
  }

  void _nextPlayer() {
    if (currentIndex < widget.players.length - 1) {
      setState(() => currentIndex++);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DescriptionScreen(players: widget.players),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.players[currentIndex];
    return Scaffold(
      appBar: AppBar(title: Text("View Role")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Pass the device to: ${player.name}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("Your Role"),
                  content: Text("${player.role}\nYour Word: ${player.word}"),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.pop(context);
                      _nextPlayer();
                    }, child: Text("OK"))
                  ],
                ),
              ),
              child: Text("View Role"),
            )
          ],
        ),
      ),
    );
  }
}
