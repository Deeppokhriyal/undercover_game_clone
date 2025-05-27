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
  bool showBack = false;

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
      setState(() {
        currentIndex++;
        showBack = false;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DescriptionScreen(players: widget.players)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.players[currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
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
          child: GestureDetector(
            onTap: () {
              if (!showBack) {
                setState(() {
                  showBack = true;
                });
              }
            },
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 600),
              transitionBuilder: __transitionBuilder,
              layoutBuilder: (widget, list) => Stack(children: [widget!, ...list]),
              switchInCurve: Curves.easeInBack,
              switchOutCurve: Curves.easeInBack.flipped,
              child: showBack
                  ? _buildCardBack(player)
                  : _buildCardFront(player.name),
            ),
          ),
        ),
      ),
    );
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotate = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotate,
      child: widget,
      builder: (context, child) {
        final isUnder = (ValueKey(showBack) != widget!.key);
        final tilt = (animation.value - 0.5).abs() - 0.5;
        final value = isUnder ? min(rotate.value, pi / 2) : rotate.value;
        return Transform(
          transform: Matrix4.rotationY(value)..setEntry(3, 0, 0.001),
          alignment: Alignment.center,
          child: child,
        );
      },
    );
  }

  Widget _buildCardFront(String name) {
    return Card(
      key: ValueKey(false),
      color: Colors.deepPurple,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      child: Container(
        width: 300,
        height: 350,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Pass the device to:", style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'nexalight')),
            SizedBox(height: 10),
            Text(name, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'nexaheavy')),
            SizedBox(height: 20),
            Icon(Icons.remove_red_eye, size: 50, color: Colors.white),
            SizedBox(height: 10),
            Text("Tap to View Role", style: TextStyle(color: Colors.white70, fontFamily: 'nexalight')),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBack(Player player) {
    return Card(
      key: ValueKey(true),
      color: Colors.grey.shade200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      child: Container(
        width: 300,
        height: 350,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              player.role == "Undercover" ? Icons.visibility_off : Icons.person,
              size: 50,
              color: player.role == "Undercover" ? Colors.redAccent : Colors.green,
            ),
            SizedBox(height: 16),
            Text(player.role, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'nexaheavy')),
            SizedBox(height: 8),
            Text("Your Word:", style: TextStyle(fontFamily: 'nexalight')),
            Text(player.word, style: TextStyle(fontSize: 22, fontFamily: 'nexaheavy')),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _nextPlayer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text("Next", style: TextStyle(color: Colors.white, fontFamily: 'nexaheavy')),
            ),
          ],
        ),
      ),
    );
  }
}
