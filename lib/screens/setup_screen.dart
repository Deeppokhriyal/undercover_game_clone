import 'package:flutter/material.dart';
import '../models/players.dart';
import 'role_screen.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class SetupScreen extends StatefulWidget {
  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen>
    with SingleTickerProviderStateMixin {
  int _numPlayers = 3;
  List<String> _playerNames = [];
  bool _initialLoad = false;

  @override
  void initState() {
    super.initState();
    _playerNames = List.filled(_numPlayers, '', growable: true);
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _initialLoad = true;
      });
    });
  }

  void _updatePlayers(int newCount) {
    if (_playerNames.length < newCount) {
      _playerNames.addAll(List.filled(newCount - _playerNames.length, ''));
    } else if (_playerNames.length > newCount) {
      _playerNames = List.from(_playerNames.sublist(0, newCount));
    }
  }

  void _showNameDialog(int index) {
    TextEditingController _nameController =
    TextEditingController(text: _playerNames[index]);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Container(
          height: 230,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade700, Colors.purple.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Enter Player ${index + 1} Name",
                style: TextStyle(
                  fontFamily: 'nexaheavy',
                  fontSize: 20,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                style: TextStyle(color: Colors.white, fontFamily: 'nexalight'),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white24,
                  hintText: "Player Name",
                  hintStyle:
                  TextStyle(color: Colors.white70, fontFamily: 'nexalight'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'nexalight'),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _playerNames[index] = _nameController.text.trim();
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      textStyle: TextStyle(fontFamily: 'nexaheavy'),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Save"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  void _startGame() {
    if (_playerNames.any((name) => name.trim().isEmpty)) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 16),
        content: _SlidingSnackbarContent(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 110),
            child: AwesomeSnackbarContent(
              title: 'Oops!',
              message: 'Please enter all player names.',
              contentType: ContentType.warning,
              inMaterialBanner: false,
            ),
          ),
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      return;
    }

    List<Player> players = _playerNames.map((name) => Player(name: name)).toList();

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 1200),
        pageBuilder: (_, __, ___) => RoleScreen(players: players),
        transitionsBuilder: (_, animation, __, child) {
          final slideTween = TweenSequence<Offset>([
            TweenSequenceItem(
              tween: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeOutBack)),
              weight: 50,
            ),
            TweenSequenceItem(
              tween: Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1))
                  .chain(CurveTween(curve: Curves.easeIn)),
              weight: 50,
            ),
          ]).animate(animation);

          final fadeTween = TweenSequence<double>([
            TweenSequenceItem(
              tween: Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: Curves.easeIn)),
              weight: 50,
            ),
            TweenSequenceItem(
              tween: Tween<double>(begin: 1, end: 0).chain(CurveTween(curve: Curves.easeOut)),
              weight: 50,
            ),
          ]).animate(animation);

          return FadeTransition(
            opacity: fadeTween,
            child: SlideTransition(
              position: slideTween,
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _updatePlayers(_numPlayers);

    return Scaffold(
      appBar: AppBar(
        title: Text("Player Setup",
            style: TextStyle(fontFamily: 'nexaheavy', fontSize: 23)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient:
            LinearGradient(colors: [Colors.deepPurple, Colors.indigo]),
          ),
        ),
      ),
      body: AnimatedOpacity(
        opacity: _initialLoad ? 1.0 : 0.0,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                elevation: 4,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: DropdownButtonFormField<int>(
                    value: _numPlayers,
                    decoration: InputDecoration(
                      labelText: "Number of Players",
                      labelStyle: TextStyle(fontFamily: 'nexalight'),
                    ),
                    items: List.generate(8, (index) => index + 3)
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text('$e Players',
                          style: TextStyle(fontFamily: 'nexalight')),
                    ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _numPlayers = val ?? 3;
                        _updatePlayers(_numPlayers);
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text("Choose Slot to Play",
                  style: TextStyle(fontFamily: 'nexaheavy', fontSize: 23)),
              SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: _numPlayers,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => _showNameDialog(index),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: LinearGradient(
                          colors: [Colors.indigoAccent, Colors.deepPurple],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_add_alt_outlined,
                              color: Colors.white, size: 50),
                          SizedBox(height: 6),
                          Text(
                            _playerNames[index].isEmpty
                                ? ''
                                : _playerNames[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'nexalight',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _startGame,
                  icon: Icon(Icons.play_arrow, color: Colors.white),
                  label: Text("Start Game",
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'nexalight')),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
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
    );
  }
}

class _SlidingSnackbarContent extends StatefulWidget {
  final Widget child;
  const _SlidingSnackbarContent({required this.child});

  @override
  State<_SlidingSnackbarContent> createState() => _SlidingSnackbarContentState();
}
class _SlidingSnackbarContentState extends State<_SlidingSnackbarContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(const Duration(milliseconds: 1200));
        if (mounted) {
          await _controller.reverse();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: widget.child,
    );
  }
}
