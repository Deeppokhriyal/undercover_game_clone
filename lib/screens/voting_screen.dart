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

class _VotingScreenState extends State<VotingScreen> with TickerProviderStateMixin {
  final Map<String, int> voteCount = {};
  String? selectedName;

  late final List<Player> _voters;
  int _currentVoterIndex = 0;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _voters = widget.players.where((p) => !p.eliminated).toList();

    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _submitVote() {
    if (selectedName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please select a player to vote.",
            style: TextStyle(fontFamily: 'nexalight'),
          ),
          backgroundColor: Colors.deepPurple.shade700,
        ),
      );
      return;
    }

    voteCount[selectedName!] = (voteCount[selectedName!] ?? 0) + 1;

    if (_voters.length > _currentVoterIndex + 1) {
      setState(() {
        _currentVoterIndex++;
        selectedName = null;
        _fadeController.reset();
        _fadeController.forward();
      });
    } else {
      _handleVoteResults();
    }
  }

  void _handleVoteResults() {
    int maxVotes = voteCount.values.isEmpty ? 0 : voteCount.values.reduce((a, b) => a > b ? a : b);
    List<String> topVoted = voteCount.entries
        .where((entry) => entry.value == maxVotes)
        .map((entry) => entry.key)
        .toList();

    if (topVoted.length == 1) {
      final eliminated = widget.players.firstWhere((p) => p.name == topVoted.first);
      eliminated.eliminated = true;

      if (eliminated.role == 'Undercover') {
        _navigateToResult("🎉 Citizens Win!\nUndercover was caught.");
        return;
      }
    }

    final activePlayers = widget.players.where((p) => !p.eliminated).toList();
    final undercoverAlive = activePlayers.any((p) => p.role == 'Undercover');

    if (activePlayers.length == 2 && undercoverAlive) {
      _navigateToResult("😈 Undercover Wins!\nOnly 1 citizen left.");
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
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 700),
        pageBuilder: (_, __, ___) => ResultScreen(message: message),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final voter = _voters[_currentVoterIndex];
    final candidates = widget.players
        .where((p) => !p.eliminated && p.name != voter.name)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Vote: ${voter.name}'s Turn",
          style: TextStyle(fontFamily: 'nexaheavy'),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.deepPurple, Colors.indigo]),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ListView.separated(
                    key: ValueKey(_currentVoterIndex),
                    itemCount: candidates.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12),
                    itemBuilder: (_, index) {
                      final player = candidates[index];
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(_fadeAnimation),
                        child: RadioListTile<String>(
                          title: Text(
                            player.name,
                            style: TextStyle(
                              fontFamily: 'nexalight',
                              fontSize: 18,
                              color: Colors.deepPurple.shade50,
                            ),
                          ),
                          activeColor: Colors.white,
                          value: player.name,
                          groupValue: selectedName,
                          onChanged: (val) => setState(() => selectedName = val),
                          tileColor: Colors.deepPurple.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTapDown: (_) => setState(() => _buttonScale = 0.95),
              onTapUp: (_) {
                setState(() => _buttonScale = 1.0);
                _submitVote();
              },
              onTapCancel: () => setState(() => _buttonScale = 1.0),
              child: AnimatedScale(
                scale: _buttonScale,
                duration: Duration(milliseconds: 150),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      "Submit Vote",
                      style: TextStyle(fontFamily: 'nexaheavy', fontSize: 18),
                    ),
                    onPressed: _submitVote,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _buttonScale = 1.0;
}
