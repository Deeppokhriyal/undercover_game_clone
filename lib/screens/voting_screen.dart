import 'package:flutter/material.dart';
import '../models/players.dart';
import 'description_screen.dart';
import 'result_screen.dart';

class VotingScreen extends StatefulWidget {
  final List<Player> players;
  VotingScreen({required this.players});

  @override
  _VotingScreenState createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  final Map<String, int> voteCount = {};
  String? selectedName;

  void _submitVote() {
    if (selectedName == null) return;

    voteCount[selectedName!] = (voteCount[selectedName!] ?? 0) + 1;

    // Move to next voter
    if (_voters.length > _currentVoterIndex + 1) {
      setState(() {
        _currentVoterIndex++;
        selectedName = null;
      });
    } else {
      _handleVoteResults();
    }
  }

  void _handleVoteResults() {
    // Find top vote count
    int maxVotes = voteCount.values.isEmpty ? 0 : voteCount.values.reduce((a, b) => a > b ? a : b);
    List<String> topVoted = voteCount.entries
        .where((entry) => entry.value == maxVotes)
        .map((entry) => entry.key)
        .toList();

    if (topVoted.length == 1) {
      // One player has highest votes - eliminate them
      final eliminated = widget.players.firstWhere((p) => p.name == topVoted.first);
      eliminated.eliminated = true;

      if (eliminated.role == 'Undercover') {
        _navigateToResult("🎉 Citizens Win!\nUndercover was caught.");
        return;
      }
    }
    // Check if only 2 players left
    final activePlayers = widget.players.where((p) => !p.eliminated).toList();
    final undercoverAlive = activePlayers.where((p) => p.role == 'Undercover').isNotEmpty;

    if (activePlayers.length == 2 && undercoverAlive) {
      _navigateToResult("😈 Undercover Wins!\nOnly 1 citizen left.");
    } else {
      // Continue to next round
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DescriptionScreen(players: widget.players),
        ),
      );
    }
  }

  late final List<Player> _voters;
  int _currentVoterIndex = 0;

  @override
  void initState() {
    super.initState();
    _voters = widget.players.where((p) => !p.eliminated).toList();
  }

  @override
  Widget build(BuildContext context) {
    final voter = _voters[_currentVoterIndex];
    final candidates = widget.players.where((p) => !p.eliminated && p.name != voter.name).toList();

    return Scaffold(
      appBar: AppBar(title: Text("Vote: ${voter.name}'s Turn")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ...candidates.map((player) => RadioListTile<String>(
              title: Text(player.name),
              value: player.name,
              groupValue: selectedName,
              onChanged: (val) => setState(() => selectedName = val),
            )),
            Spacer(),
            ElevatedButton(
              onPressed: _submitVote,
              child: Text("Submit Vote"),
            )
          ],
        ),
      ),
    );
  }

  void _navigateToResult(String message) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(message: message),
      ),
    );
  }
}
