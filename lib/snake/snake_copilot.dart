import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const SnakeGame());
}

class SnakeGame extends StatelessWidget {
  const SnakeGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Snake Game',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SnakeGameScreen(),
    );
  }
}

class SnakeGameScreen extends StatefulWidget {
  const SnakeGameScreen({Key? key}) : super(key: key);

  @override
  State<SnakeGameScreen> createState() => _SnakeGameScreenState();
}

class _SnakeGameScreenState extends State<SnakeGameScreen> {
  static const int squaresPerRow = 20;
  static const int squaresPerCol = 40;
  static const double borderWidth = 1.0;
  final randomGenerator = Random();
  
  // Game state
  List<int> snakePosition = [45, 65, 85, 105, 125];
  int food = 0;
  String direction = 'down';
  bool isPlaying = false;
  int score = 0;
  
  @override
  void initState() {
    super.initState();
    _generateNewFood();
  }
  
  void _startGame() {
    setState(() {
      snakePosition = [45, 65, 85, 105, 125];
      direction = 'down';
      score = 0;
      _generateNewFood();
      isPlaying = true;
    });
    
    // Start game loop
    Duration duration = const Duration(milliseconds: 150);
    Timer.periodic(duration, (Timer timer) {
      _updateGame();
      
      if (!isPlaying) {
        timer.cancel();
      }
    });
  }
  
  void _generateNewFood() {
    food = randomGenerator.nextInt(squaresPerRow * squaresPerCol);
    
    // Regenerate if food appears on snake
    while (snakePosition.contains(food)) {
      food = randomGenerator.nextInt(squaresPerRow * squaresPerCol);
    }
  }
  
  void _updateGame() {
    setState(() {
      // Move snake based on direction
      switch (direction) {
        case 'down':
          if (snakePosition.last % squaresPerRow == 0) {
            // Hit the wall
            snakePosition.add(snakePosition.last - squaresPerRow + 1);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
          break;
          
        case 'up':
          if (snakePosition.last % squaresPerRow == squaresPerRow - 1) {
            // Hit the wall
            snakePosition.add(snakePosition.last + squaresPerRow - 1);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }
          break;
          
        case 'left':
          if (snakePosition.last < squaresPerRow) {
            // Hit the wall
            snakePosition.add(snakePosition.last - squaresPerRow + (squaresPerCol * squaresPerRow));
          } else {
            snakePosition.add(snakePosition.last - squaresPerRow);
          }
          break;
          
        case 'right':
          if (snakePosition.last >= (squaresPerCol - 1) * squaresPerRow) {
            // Hit the wall
            snakePosition.add(snakePosition.last + squaresPerRow - (squaresPerCol * squaresPerRow));
          } else {
            snakePosition.add(snakePosition.last + squaresPerRow);
          }
          break;
      }
      
      // Check if snake eats food
      if (snakePosition.last == food) {
        _generateNewFood();
        score += 5;
      } else {
        snakePosition.removeAt(0);
      }
      
      // Check for game over conditions
      if (_checkGameOver()) {
        isPlaying = false;
        _showGameOverDialog();
      }
    });
  }
  
  bool _checkGameOver() {
    // Check if snake hits itself
    for (int i = 0; i < snakePosition.length - 1; i++) {
      if (snakePosition[i] == snakePosition.last) {
        return true;
      }
    }
    return false;
  }
  
  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text('Your score: $score'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startGame();
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }
  
  void _changeDirection(String newDirection) {
    if (!isPlaying) return;
    
    // Prevent 180-degree turns
    if ((direction == 'up' && newDirection == 'down') ||
        (direction == 'down' && newDirection == 'up') ||
        (direction == 'left' && newDirection == 'right') ||
        (direction == 'right' && newDirection == 'left')) {
      return;
    }
    
    direction = newDirection;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake Game'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Score: $score',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: isPlaying ? null : _startGame,
                  child: Text(isPlaying ? 'Playing' : 'Start Game'),
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0) {
                  _changeDirection('down');
                } else if (details.delta.dy < 0) {
                  _changeDirection('up');
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0) {
                  _changeDirection('right');
                } else if (details.delta.dx < 0) {
                  _changeDirection('left');
                }
              },
              child: Container(
                color: Colors.black,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: squaresPerRow,
                  ),
                  itemCount: squaresPerRow * squaresPerCol,
                  itemBuilder: (BuildContext context, int index) {
                    if (snakePosition.contains(index)) {
                      // Snake body
                      Color snakeColor = Colors.green;
                      // Head of the snake
                      if (index == snakePosition.last) {
                        snakeColor = Colors.green.shade900;
                      }
                      return Container(
                        padding: const EdgeInsets.all(borderWidth),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            color: snakeColor,
                          ),
                        ),
                      );
                    }
                    if (index == food) {
                      // Food
                      return Container(
                        padding: const EdgeInsets.all(borderWidth),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            color: Colors.red,
                          ),
                        ),
                      );
                    } else {
                      // Empty space
                      return Container(
                        padding: const EdgeInsets.all(borderWidth),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(1),
                          child: Container(
                            color: Colors.black87,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DirectionButton(
                  icon: Icons.arrow_upward,
                  onPressed: () => _changeDirection('up'),
                ),
                DirectionButton(
                  icon: Icons.arrow_back,
                  onPressed: () => _changeDirection('left'),
                ),
                DirectionButton(
                  icon: Icons.arrow_downward,
                  onPressed: () => _changeDirection('down'),
                ),
                DirectionButton(
                  icon: Icons.arrow_forward,
                  onPressed: () => _changeDirection('right'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DirectionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const DirectionButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
      ),
      child: Icon(icon),
    );
  }
}