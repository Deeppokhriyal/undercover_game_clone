import 'package:flutter/material.dart';
import 'screens/setup_screen.dart';

void main() {
  runApp(UndercoverGameApp());
}

class UndercoverGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Undercover Game',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      home: SetupScreen(),
    );
  }
}
