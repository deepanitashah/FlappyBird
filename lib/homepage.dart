import 'dart:async';
import 'dart:core';
import 'barriers.dart';
import 'gameoverscreen.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdYaxis = 0;
  double time = 0;
  double height = 0;
  double initialHeight = birdYaxis;
  double velocity = 2.8;
  bool gameHasStarted = false;
  static double barrierXone = 1;
  double barrierXtwo = barrierXone + 1.5;
  int score = 0;
  int highScore = 0;
  bool birdPassedBarrierOne = false;
  bool birdPassedBarrierTwo = false;

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 60), (timer) {
      time += 0.05;
      height = -4.9 * time * time + velocity * time;

      setState(() {
        birdYaxis = initialHeight - height;
      });

      // Move barriers
      setState(() {
        if (barrierXone < -2) {
          barrierXone += 3.5;
          birdPassedBarrierOne = false;  // Reset when barrier is repositioned
        } else {
          barrierXone -= 0.05;
        }

        if (barrierXtwo < -2) {
          barrierXtwo += 3.5;
          birdPassedBarrierTwo = false;  // Reset when barrier is repositioned
        } else {
          barrierXtwo -= 0.05;
        }
      });

      // Check if bird hits the top or bottom of the screen
      if (birdYaxis > 1 || birdYaxis < -1) {
        timer.cancel();
        gameHasStarted = false;
        _endGame();
      }

      // Check for collision with barriers
      if (_checkCollision()) {
        timer.cancel();
        gameHasStarted = false;
        _endGame();
      }

      // Update the score when the bird passes a barrier
      if (barrierXone < -0.2 && !birdPassedBarrierOne) {
        setState(() {
          score += 1;
          birdPassedBarrierOne = true;
        });
      }
      if (barrierXtwo < -0.2 && !birdPassedBarrierTwo) {
        setState(() {
          score += 1;
          birdPassedBarrierTwo = true;
        });
      }
    });
  }

  // Simple collision detection function
  bool _checkCollision() {
    if (barrierXone <= -0.2 && barrierXone >= -0.4) {
      if (birdYaxis < -0.7 || birdYaxis > 0.7) {
        return true; // Bird hits the barrier
      }
    }
    if (barrierXtwo <= -0.2 && barrierXtwo >= -0.4) {
      if (birdYaxis < -0.6 || birdYaxis > 0.6) {
        return true; // Bird hits the second barrier
      }
    }
    return false;
  }

  void _endGame() {
    // Update high score
    if (score > highScore) {
      highScore = score;
    }

    // Navigate to the Game Over Screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameOverScreen(
          score: score,
          highScore: highScore,
          onPlayAgain: _restartGame,
        ),
      ),
    );
  }

  void _restartGame() {
    setState(() {
      birdYaxis = 0;
      time = 0;
      initialHeight = birdYaxis;
      barrierXone = 1;
      barrierXtwo = barrierXone + 1.5;
      score = 0;
      birdPassedBarrierOne = false;
      birdPassedBarrierTwo = false;
      gameHasStarted = false;
      Navigator.of(context).pop(); // Pop the GameOverScreen
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    AnimatedContainer(
                      alignment: Alignment(0, birdYaxis),
                      duration: Duration(milliseconds: 0),
                      color: Colors.blue,
                      child: MyBird(),
                    ),
                    Container(
                      alignment: Alignment(0, -0.3),
                      child: gameHasStarted
                          ? const Text("")
                          : const Text(
                              "T A P  T O  P L A Y",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 0),
                      alignment: Alignment(barrierXone, 1.1),
                      child: MyBarrier(
                        size: 200.0,
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 0),
                      alignment: Alignment(barrierXone, -1.1),
                      child: MyBarrier(
                        size: 200.0,
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 0),
                      alignment: Alignment(barrierXtwo, 1.1),
                      child: MyBarrier(
                        size: 150.0,
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 0),
                      alignment: Alignment(barrierXtwo, -1.1),
                      child: MyBarrier(
                        size: 250.0,
                      ),
                    ),
                  ],
                )),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "SCORE",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          score.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "BEST",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          highScore.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
