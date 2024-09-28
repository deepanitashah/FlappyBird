import 'package:flutter/material.dart';

class GameOverScreen extends StatelessWidget {
  final int score;
  final int highScore;
  final VoidCallback onPlayAgain;

  const GameOverScreen({
    Key? key,
    required this.score,
    required this.highScore,
    required this.onPlayAgain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'GAME OVER',
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Score: $score',
              style: const TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'High Score: $highScore',
              style: const TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: onPlayAgain,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text(
                'Play Again',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
