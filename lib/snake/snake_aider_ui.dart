import 'dart:async';
import 'package:flutter/material.dart';
import 'snake_aider.dart';

class SnakeAiderUI extends StatefulWidget {
  const SnakeAiderUI({Key? key}) : super(key: key);

  @override
  State<SnakeAiderUI> createState() => _SnakeAiderUIState();
}

class _SnakeAiderUIState extends State<SnakeAiderUI> {
  late SnakeGame _game;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _game = SnakeGame(boardWidth: 20, boardHeight: 20);
    _game.init();
    _isInitialized = true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _toggleAI() {
    setState(() {
      _game.toggleAI();
    });
  }

  void _changeDirection(Direction direction) {
    if (_game.gameState == GameState.running) {
      _game.changeDirection(direction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake Aider'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: Icon(_game.aiEnabled ? Icons.smart_toy : Icons.person),
            onPressed: _toggleAI,
            tooltip: 'Toggle AI',
          ),
        ],
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
                  'Score: ${_game.score}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    if (_game.gameState == GameState.notStarted || 
                        _game.gameState == GameState.gameOver)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _game.start();
                          });
                        },
                        child: const Text('Start'),
                      ),
                    if (_game.gameState == GameState.running)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _game.pause();
                          });
                        },
                        child: const Text('Pause'),
                      ),
                    if (_game.gameState == GameState.paused)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _game.resume();
                          });
                        },
                        child: const Text('Resume'),
                      ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _game.reset();
                        });
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0) {
                  _changeDirection(Direction.down);
                } else if (details.delta.dy < 0) {
                  _changeDirection(Direction.up);
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0) {
                  _changeDirection(Direction.right);
                } else if (details.delta.dx < 0) {
                  _changeDirection(Direction.left);
                }
              },
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    color: Colors.black,
                  ),
                  child: SnakeGameBoard(game: _game),
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
                  onPressed: () => _changeDirection(Direction.up),
                  color: Colors.purple,
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
                  onPressed: () => _changeDirection(Direction.left),
                  color: Colors.purple,
                ),
                const SizedBox(width: 60),
                DirectionButton(
                  icon: Icons.arrow_forward,
                  onPressed: () => _changeDirection(Direction.right),
                  color: Colors.purple,
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
                  onPressed: () => _changeDirection(Direction.down),
                  color: Colors.purple,
                ),
              ],
            ),
          ),
          if (_game.gameState == GameState.gameOver)
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

class SnakeGameBoard extends StatefulWidget {
  final SnakeGame game;

  const SnakeGameBoard({Key? key, required this.game}) : super(key: key);

  @override
  State<SnakeGameBoard> createState() => _SnakeGameBoardState();
}

class _SnakeGameBoardState extends State<SnakeGameBoard> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SnakeBoardPainter(
        snake: widget.game.snake,
        food: widget.game.food,
        boardWidth: widget.game.boardWidth,
        boardHeight: widget.game.boardHeight,
      ),
    );
  }
}

class SnakeBoardPainter extends CustomPainter {
  final List<Position> snake;
  final Position? food;
  final int boardWidth;
  final int boardHeight;

  SnakeBoardPainter({
    required this.snake,
    required this.food,
    required this.boardWidth,
    required this.boardHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double cellWidth = size.width / boardWidth;
    final double cellHeight = size.height / boardHeight;

    // Draw snake
    final Paint snakePaint = Paint()..color = Colors.purple;
    for (int i = 0; i < snake.length; i++) {
      final Position segment = snake[i];
      final Color color = i == 0 
          ? Colors.purple // Head
          : Colors.purple.withOpacity(0.8 - (i / snake.length) * 0.5); // Body with gradient
      
      snakePaint.color = color;
      final Rect rect = Rect.fromLTWH(
        segment.x * cellWidth,
        segment.y * cellHeight,
        cellWidth,
        cellHeight,
      );
      canvas.drawRect(rect, snakePaint);
    }

    // Draw food
    if (food != null) {
      final Paint foodPaint = Paint()..color = Colors.red;
      final Rect foodRect = Rect.fromLTWH(
        food!.x * cellWidth,
        food!.y * cellHeight,
        cellWidth,
        cellHeight,
      );
      canvas.drawOval(foodRect, foodPaint);
    }

    // Draw grid lines (optional)
    final Paint gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke;

    for (int x = 0; x < boardWidth; x++) {
      for (int y = 0; y < boardHeight; y++) {
        final Rect cell = Rect.fromLTWH(
          x * cellWidth,
          y * cellHeight,
          cellWidth,
          cellHeight,
        );
        canvas.drawRect(cell, gridPaint);
      }
    }
  }

  @override
  bool shouldRepaint(SnakeBoardPainter oldDelegate) {
    return true; // Always repaint to ensure game updates are shown
  }
}

class DirectionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const DirectionButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: color,
        padding: const EdgeInsets.all(16),
      ),
      child: Icon(icon),
    );
  }
} 