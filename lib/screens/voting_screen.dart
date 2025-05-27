import 'package:flutter/material.dart';
import '../models/players.dart';
import 'description_screen.dart';
import 'result_screen.dart';

class VotingScreen extends StatefulWidget {
  final List<Player> players;
  const VotingScreen({super.key, required this.players});

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> with TickerProviderStateMixin {
  final Map<String, int> voteCount = {};
  String? selectedName;
  late final List<Player> _voters;
  int _currentVoterIndex = 0;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  double _buttonScale = 1.0;

  @override
  void initState() {
    super.initState();
    _voters = widget.players.where((p) => !p.eliminated).toList();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
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
          content: const Text("Please select a player to vote.", style: TextStyle(fontFamily: 'nexalight')),
          backgroundColor: Colors.deepPurple.shade700,
        ),
      );
      return;
    }

    voteCount[selectedName!] = (voteCount[selectedName!] ?? 0) + 1;

    if (_currentVoterIndex < _voters.length - 1) {
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
    final maxVotes = voteCount.isEmpty ? 0 : voteCount.values.reduce((a, b) => a > b ? a : b);
    final topVoted = voteCount.entries
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

    final remaining = widget.players.where((p) => !p.eliminated).toList();
    final isUndercoverAlive = remaining.any((p) => p.role == 'Undercover');

    if (remaining.length == 2 && isUndercoverAlive) {
      _navigateToResult("😈 Undercover Wins!\nOnly 1 citizen left.");
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DescriptionScreen(players: widget.players)),
      );
    }
  }

  void _navigateToResult(String message) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
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
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Vote: ${voter.name}'s Turn", style: const TextStyle(fontFamily: 'nexaheavy')),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.deepPurple, Colors.indigo]),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: GridView.builder(
                  key: ValueKey(_currentVoterIndex),
                  itemCount: candidates.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (_, index) {
                    final player = candidates[index];
                    final isSelected = selectedName == player.name;

                    return GestureDetector(
                      onTap: () => setState(() => selectedName = player.name),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? const LinearGradient(colors: [Colors.green, Colors.purple])
                              : LinearGradient(colors: [Colors.deepPurple.shade700, Colors.indigo]),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
                          ],
                          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.person, color: Colors.white, size: 40),
                            const SizedBox(height: 12),
                            Text(
                              player.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'nexalight',
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTapDown: (_) => setState(() => _buttonScale = 0.95),
              onTapUp: (_) {
                setState(() => _buttonScale = 1.0);
                _submitVote();
              },
              onTapCancel: () => setState(() => _buttonScale = 1.0),
              child: AnimatedScale(
                scale: _buttonScale,
                duration: const Duration(milliseconds: 150),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitVote,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Submit Vote", style: TextStyle(fontFamily: 'nexaheavy', fontSize: 18)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
