import 'package:flutter/material.dart';
// import '../models/player.dart';
import '../models/players.dart';
import 'role_screen.dart';

class SetupScreen extends StatefulWidget {
  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _playerNames = [];
  int _numPlayers = 3;

  void _startGame() {
    if (_playerNames.length < 3) return;
    List<Player> players = _playerNames.map((name) => Player(name: name)).toList();
    Navigator.push(context, MaterialPageRoute(builder: (_) => RoleScreen(players: players)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Player Setup")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              value: _numPlayers,
              items: List.generate(10, (index) => index + 3)
                  .map((e) => DropdownMenuItem(value: e, child: Text('$e Players')))
                  .toList(),
              onChanged: (val) => setState(() => _numPlayers = val ?? 3),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _numPlayers,
                itemBuilder: (context, index) {
                  return TextFormField(
                    decoration: InputDecoration(labelText: 'Player ${index + 1} Name'),
                    onChanged: (val) {
                      if (_playerNames.length > index) {
                        _playerNames[index] = val;
                      } else {
                        _playerNames.add(val);
                      }
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _startGame,
              child: Text("Start Game"),
            ),
          ],
        ),
      ),
    );
  }
}
