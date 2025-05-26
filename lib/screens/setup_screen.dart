import 'package:flutter/material.dart';
import '../models/players.dart';
import 'role_screen.dart';

class SetupScreen extends StatefulWidget {
  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  int _numPlayers = 3;
  List<TextEditingController> _controllers = [];
  bool _initialLoad = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_numPlayers, (_) => TextEditingController());

    // Delay to trigger fade-in animation
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _initialLoad = true;
      });
    });
  }

  void _updateControllers(int newCount) {
    if (_controllers.length < newCount) {
      _controllers.addAll(
        List.generate(newCount - _controllers.length, (_) => TextEditingController()),
      );
    } else if (_controllers.length > newCount) {
      _controllers = _controllers.sublist(0, newCount);
    }
  }

  void _startGame() {
    if (_formKey.currentState!.validate()) {
      List<Player> players = _controllers
          .map((controller) => Player(name: controller.text.trim()))
          .toList();

      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) => RoleScreen(players: players),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
                    .animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
                child: child,
              ),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateControllers(_numPlayers);

    return Scaffold(
      appBar: AppBar(
        title: Text("Player Setup", style: TextStyle(fontFamily: 'nexaheavy', fontSize: 23)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.deepPurple, Colors.indigo]),
          ),
        ),
      ),
      body: AnimatedOpacity(
        opacity: _initialLoad ? 1.0 : 0.0,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: DropdownButtonFormField<int>(
                      value: _numPlayers,
                      decoration: InputDecoration(
                        labelText: "Number of Players",
                        labelStyle: TextStyle(fontFamily: 'nexalight'),
                      ),
                      items: List.generate(8, (index) => index + 3)
                          .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text('$e Players', style: TextStyle(fontFamily: 'nexalight')),
                      ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _numPlayers = val ?? 3;
                          _updateControllers(_numPlayers);
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: ListView.builder(
                      key: ValueKey(_numPlayers),
                      itemCount: _numPlayers,
                      itemBuilder: (context, index) {
                        return TweenAnimationBuilder(
                          duration: Duration(milliseconds: 500 + (index * 100)),
                          tween: Tween<double>(begin: 0, end: 1),
                          builder: (context, value, child) => Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: child,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: TextFormField(
                              style: TextStyle(fontFamily: 'nexalight'),
                              controller: _controllers[index],
                              decoration: InputDecoration(
                                labelStyle: TextStyle(fontFamily: 'nexalight'),
                                labelText: 'Player ${index + 1} Name',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a name';
                                }
                                return null;
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _startGame,
                    icon: Icon(Icons.play_arrow, color: Colors.white),
                    label: Text("Start Game", style: TextStyle(color: Colors.white, fontFamily: 'nexalight')),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.deepPurple,
                      elevation: 8,
                      shadowColor: Colors.deepPurpleAccent,
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
