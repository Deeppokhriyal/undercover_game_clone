import 'package:flutter/material.dart';
// import '../models/player.dart';
import '../models/players.dart';
import 'result_screen.dart';
import 'description_screen.dart';

class VotingScreen extends StatefulWidget {
  final List<Player> players;
  VotingScreen({required this.players});

  @override
  _VotingScreenState createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  String? selectedName;

  void _submitVote() {
    if (selectedName == null) return;

    final votedPlayer = widget.players.firstWhere((p) =>
    p.name == selectedName);
    votedPlayer.eliminated = true;

    final remaining = widget.players.where((p) => !p.eliminated).toList();
    final undercoverRemaining = remaining
        .where((p) => p.role == 'Undercover')
        .length;

    if (undercoverRemaining == 0) {
      // Citizens win
      _navigateToResult("Citizens Win! Undercover was caught.");
    } else if (remaining.length <= 2) {
      // Undercover wins
      _navigateToResult("Undercover Wins! Only 2 players left.");
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DescriptionScreen(players: widget.players),
        ),
      );
    }
  }

  void _navigateToResult(String message) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(message: message),
      ),
    );
  }

//   @override
//   Widget build(BuildContext context) {
//     final remainingPlayers = widget.players.where((p) => !p.eliminated).toList();
//     return Scaffold(
//       appBar: AppBar(title: Text("Vote for Undercover")),
//       body: Column(
//         children: remainingPlayers.map((player) {
//           return RadioListTile<String>(
//             title: Text(player.name),
//             value: player.name,
//             groupValue: selectedName,
//             onChanged: (val) {
//               setState(() => selectedName = val);
//             },
//           );
//         }).toList(),
//           // ..add(
//             ElevatedButton(
//               onPressed: _submitVote,
//               child: Text("Submit Vote"),
//             ),
//           // ),
//       ),
//     );
//   }
// }
  @override
  Widget build(BuildContext context) {
    final remainingPlayers = widget.players.where((p) => !p.eliminated)
        .toList();
    return Scaffold(
      appBar: AppBar(title: Text("Vote for Undercover")),
      body: Column(
        children: [
          ...remainingPlayers.map((player) {
            return RadioListTile<String>(
              title: Text(player.name),
              value: player.name,
              groupValue: selectedName,
              onChanged: (val) {
                setState(() => selectedName = val);
              },
            );
          }).toList(),
          ElevatedButton(
            onPressed: _submitVote,
            child: Text("Submit Vote"),
          ),
        ],
      ),
    );
  }
}
