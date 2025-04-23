import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  static const int rows = 20;
  static const int columns = 20;
  static const Color snakeColor = Colors.green;
  static const Color foodColor = Colors.red;
  
  List<Offset> snake = [const Offset(5, 5)];
  Offset food = const Offset(10, 10);
  Offset direction = const Offset(1, 0); // Initially moving right
  Timer? timer;
  int score = 0;
  bool isGameOver = false;
  
  @override
  void initState() {
    super.initState();
    spawnFood();
    startGame();
  }
  
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  
  void startGame() {
    timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      updateSnake();
    });
  }
  
  void updateSnake() {
    setState(() {
      // Calculate new head position
      final Offset newHead = Offset(
        (snake.first.dx + direction.dx) % columns,
        (snake.first.dy + direction.dy) % rows,
      );
      
      // Check for collision with self
      if (snake.contains(newHead) && snake.length > 1) {
        gameOver();
        return;
      }
      
      // Add new head
      snake.insert(0, newHead);
      
      // Check if snake ate food
      if (newHead == food) {
        score++;
        spawnFood();
      } else {
        // Remove tail if no food eaten
        snake.removeLast();
      }
    });
  }
  
  void spawnFood() {
    final random = Random();
    do {
      food = Offset(
        random.nextInt(columns).toDouble(),
        random.nextInt(rows).toDouble(),
      );
    } while (snake.contains(food));
  }
  
  void gameOver() {
    timer?.cancel();
    isGameOver = true;
  }
  
  void resetGame() {
    setState(() {
      snake = [const Offset(5, 5)];
      direction = const Offset(1, 0);
      score = 0;
      isGameOver = false;
      spawnFood();
      startGame();
    });
  }
  
  void changeDirection(Offset newDirection) {
    // Prevent 180-degree turns
    if (direction.dx != -newDirection.dx || direction.dy != -newDirection.dy) {
      direction = newDirection;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake Game'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
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
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isGameOver)
                  ElevatedButton(
                    onPressed: resetGame,
                    child: const Text('Restart'),
                  ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0 && direction.dy != -1) {
                  // Downward swipe
                  changeDirection(const Offset(0, 1));
                } else if (details.delta.dy < 0 && direction.dy != 1) {
                  // Upward swipe
                  changeDirection(const Offset(0, -1));
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0 && direction.dx != -1) {
                  // Rightward swipe
                  changeDirection(const Offset(1, 0));
                } else if (details.delta.dx < 0 && direction.dx != 1) {
                  // Leftward swipe
                  changeDirection(const Offset(-1, 0));
                }
              },
              child: Focus(
                autofocus: true,
                onKeyEvent: (_, event) {
                  if (event is KeyDownEvent) {
                    if (event.logicalKey == LogicalKeyboardKey.arrowUp &&
                        direction.dy != 1) {
                      changeDirection(const Offset(0, -1));
                    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown &&
                        direction.dy != -1) {
                      changeDirection(const Offset(0, 1));
                    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft &&
                        direction.dx != 1) {
                      changeDirection(const Offset(-1, 0));
                    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
                        direction.dx != -1) {
                      changeDirection(const Offset(1, 0));
                    }
                  }
                  return KeyEventResult.handled;
                },
                child: AspectRatio(
                  aspectRatio: columns / rows,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                    ),
                    child: CustomPaint(
                      painter: SnakeBoardPainter(
                        snake: snake,
                        food: food,
                        rows: rows,
                        columns: columns,
                        snakeColor: snakeColor,
                        foodColor: foodColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DirectionButton(
                  icon: Icons.arrow_upward,
                  onPressed: () {
                    if (direction.dy != 1) {
                      changeDirection(const Offset(0, -1));
                    }
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DirectionButton(
                  icon: Icons.arrow_back,
                  onPressed: () {
                    if (direction.dx != 1) {
                      changeDirection(const Offset(-1, 0));
                    }
                  },
                ),
                const SizedBox(width: 60),
                DirectionButton(
                  icon: Icons.arrow_forward,
                  onPressed: () {
                    if (direction.dx != -1) {
                      changeDirection(const Offset(1, 0));
                    }
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DirectionButton(
                  icon: Icons.arrow_downward,
                  onPressed: () {
                    if (direction.dy != -1) {
                      changeDirection(const Offset(0, 1));
                    }
                  },
                ),
              ],
            ),
          ),
          if (isGameOver)
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.red.withOpacity(0.7),
              child: const Text(
                'Game Over!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
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
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
      ),
      child: Icon(icon),
    );
  }
}

class SnakeBoardPainter extends CustomPainter {
  final List<Offset> snake;
  final Offset food;
  final int rows;
  final int columns;
  final Color snakeColor;
  final Color foodColor;

  SnakeBoardPainter({
    required this.snake,
    required this.food,
    required this.rows,
    required this.columns,
    required this.snakeColor,
    required this.foodColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint snakePaint = Paint()..color = snakeColor;
    final Paint foodPaint = Paint()..color = foodColor;
    
    final double cellWidth = size.width / columns;
    final double cellHeight = size.height / rows;

    // Draw snake
    for (Offset segment in snake) {
      final Rect rect = Rect.fromLTWH(
        segment.dx * cellWidth,
        segment.dy * cellHeight,
        cellWidth,
        cellHeight,
      );
      canvas.drawRect(rect, snakePaint);
    }
    
    // Draw food
    final Rect foodRect = Rect.fromLTWH(
      food.dx * cellWidth,
      food.dy * cellHeight,
      cellWidth,
      cellHeight,
    );
    canvas.drawOval(foodRect, foodPaint);
  }

  @override
  bool shouldRepaint(SnakeBoardPainter oldDelegate) {
    return oldDelegate.snake != snake || oldDelegate.food != food;
  }
}

// Main entry point for the Snake Game
class SnakeCursor extends StatelessWidget {
  const SnakeCursor({super.key});

  @override
  Widget build(BuildContext context) {
    return const SnakeGame();
  }
}
