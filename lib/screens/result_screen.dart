import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String message;
  ResultScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Game Over")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, style: TextStyle(fontSize: 22)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              child: Text("Play Again"),
            )
          ],
        ),
      ),
    );
  }
}
