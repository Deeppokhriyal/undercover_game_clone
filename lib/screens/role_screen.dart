import 'dart:math';
import 'package:flutter/material.dart';
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
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => DescriptionScreen(players: widget.players),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween(begin: Offset(1, 0), end: Offset.zero)
                  .animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
              child: child,
            );
          },
        ),
      );
    }
  }

  void _showRoleDialog(Player player) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Center(
          child: Text(
            "Your Role",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              fontFamily: 'nexaheavy',
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              player.role == "Undercover" ? Icons.visibility_off : Icons.person,
              size: 50,
              color: player.role == "Undercover" ? Colors.redAccent : Colors.green,
            ),
            SizedBox(height: 16),
            Text(
              "${player.role}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'nexalight',
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Your Word: ${player.word}",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'nexalight',
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _nextPlayer();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                "OK",
                style: TextStyle(fontFamily: 'nexaheavy',color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.players[currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text("View Role", style: TextStyle(fontFamily: 'nexaheavy')),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.deepPurple, Colors.indigo]),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Card(
            color: Colors.deepPurple, // dark background for contrast
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Pass the device to:",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'nexalight',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    player.name,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'nexaheavy',
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showRoleDialog(player),
                      icon: Icon(Icons.remove_red_eye),
                      label: Text(
                        "View Role",
                        style: TextStyle(fontFamily: 'nexaheavy'),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
