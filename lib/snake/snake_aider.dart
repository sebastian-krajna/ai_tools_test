import 'dart:math';
import 'dart:async';

/// Possible directions the snake can move
enum Direction { up, down, left, right }

/// Represents a point on the game board
class Position {
  final int x;
  final int y;

  const Position(this.x, this.y);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Position && other.x == x && other.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

/// Game state enum
enum GameState { notStarted, running, paused, gameOver }

/// Snake game model that handles the game logic
class SnakeGame {
  // Game board dimensions
  final int boardWidth;
  final int boardHeight;
  
  // Game state
  GameState _gameState = GameState.notStarted;
  GameState get gameState => _gameState;
  
  // Snake properties
  List<Position> _snake = [];
  Direction _direction = Direction.right;
  Direction get direction => _direction;
  List<Position> get snake => List.unmodifiable(_snake);
  
  // Food position
  Position? _food;
  Position? get food => _food;
  
  // Score
  int _score = 0;
  int get score => _score;
  
  // Game speed (milliseconds per move)
  int _speed = 300;
  int get speed => _speed;
  
  // Game timer
  Timer? _timer;
  
  // Random generator
  final Random _random = Random();
  
  // AI controller
  final SnakeAI _ai = SnakeAI();
  bool _aiEnabled = false;
  bool get aiEnabled => _aiEnabled;
  
  // Constructor
  SnakeGame({
    required this.boardWidth,
    required this.boardHeight,
  });
  
  /// Initialize the game
  void init() {
    // Initialize snake at the center of the board
    final centerX = boardWidth ~/ 2;
    final centerY = boardHeight ~/ 2;
    
    _snake = [
      Position(centerX, centerY),
      Position(centerX - 1, centerY),
      Position(centerX - 2, centerY),
    ];
    
    _direction = Direction.right;
    _gameState = GameState.notStarted;
    _score = 0;
    _speed = 300;
    
    // Generate initial food
    _generateFood();
  }
  
  /// Start the game
  void start() {
    if (_gameState == GameState.notStarted || _gameState == GameState.gameOver) {
      init();
    }
    
    _gameState = GameState.running;
    _startGameLoop();
  }
  
  /// Pause the game
  void pause() {
    if (_gameState == GameState.running) {
      _gameState = GameState.paused;
      _timer?.cancel();
    }
  }
  
  /// Resume the game
  void resume() {
    if (_gameState == GameState.paused) {
      _gameState = GameState.running;
      _startGameLoop();
    }
  }
  
  /// Reset the game
  void reset() {
    _timer?.cancel();
    init();
  }
  
  /// Toggle AI control
  void toggleAI() {
    _aiEnabled = !_aiEnabled;
  }
  
  /// Change the snake's direction
  void changeDirection(Direction newDirection) {
    // Prevent 180-degree turns
    if ((_direction == Direction.up && newDirection == Direction.down) ||
        (_direction == Direction.down && newDirection == Direction.up) ||
        (_direction == Direction.left && newDirection == Direction.right) ||
        (_direction == Direction.right && newDirection == Direction.left)) {
      return;
    }
    
    _direction = newDirection;
  }
  
  /// Start the game loop
  void _startGameLoop() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: _speed), (_) {
      if (_gameState == GameState.running) {
        // If AI is enabled, let it decide the next move
        if (_aiEnabled && _food != null) {
          final aiDirection = _ai.getNextMove(
            snakePosition: _snake,
            foodPosition: _food!,
            boardWidth: boardWidth,
            boardHeight: boardHeight,
            currentDirection: _direction,
          );
          changeDirection(aiDirection);
        }
        
        _update();
      }
    });
  }
  
  /// Update game state
  void _update() {
    // Move the snake
    _moveSnake();
    
    // Check for collisions
    if (_checkCollision()) {
      _gameOver();
      return;
    }
    
    // Check if food is eaten
    if (_food != null && _snake.first == _food) {
      _eatFood();
    }
  }
  
  /// Move the snake
  void _moveSnake() {
    // Get the current head position
    final head = _snake.first;
    
    // Calculate new head position based on direction
    Position newHead;
    switch (_direction) {
      case Direction.up:
        newHead = Position(head.x, head.y - 1);
        break;
      case Direction.down:
        newHead = Position(head.x, head.y + 1);
        break;
      case Direction.left:
        newHead = Position(head.x - 1, head.y);
        break;
      case Direction.right:
        newHead = Position(head.x + 1, head.y);
        break;
    }
    
    // Add new head to the snake
    _snake.insert(0, newHead);
    
    // Remove tail unless food was eaten
    if (_food != null && newHead != _food) {
      _snake.removeLast();
    }
  }
  
  /// Check for collisions with walls or self
  bool _checkCollision() {
    final head = _snake.first;
    
    // Check for wall collision
    if (head.x < 0 || head.x >= boardWidth || head.y < 0 || head.y >= boardHeight) {
      return true;
    }
    
    // Check for self collision (skip the head)
    for (int i = 1; i < _snake.length; i++) {
      if (head == _snake[i]) {
        return true;
      }
    }
    
    return false;
  }
  
  /// Handle food consumption
  void _eatFood() {
    // Increase score
    _score += 10;
    
    // Speed up the game slightly
    if (_speed > 100) {
      _speed -= 5;
      // Restart the timer with the new speed
      _startGameLoop();
    }
    
    // Generate new food
    _generateFood();
  }
  
  /// Generate food at a random position
  void _generateFood() {
    // Create a list of all possible positions
    final List<Position> availablePositions = [];
    
    for (int x = 0; x < boardWidth; x++) {
      for (int y = 0; y < boardHeight; y++) {
        final position = Position(x, y);
        // Check if the position is not occupied by the snake
        if (!_snake.contains(position)) {
          availablePositions.add(position);
        }
      }
    }
    
    // If there are available positions, randomly select one
    if (availablePositions.isNotEmpty) {
      _food = availablePositions[_random.nextInt(availablePositions.length)];
    } else {
      // No available positions means the player has won!
      _gameOver();
    }
  }
  
  /// End the game
  void _gameOver() {
    _gameState = GameState.gameOver;
    _timer?.cancel();
  }
}

/// SnakeAI class provides artificial intelligence for the snake game.
/// It makes decisions on which direction the snake should move based on
/// the current game state.
class SnakeAI {
  /// Decides the next direction for the snake based on the current game state
  /// 
  /// Parameters:
  /// - snakePosition: List of coordinates representing the snake's body segments
  /// - foodPosition: Coordinate of the food
  /// - boardWidth: Width of the game board
  /// - boardHeight: Height of the game board
  /// - currentDirection: Current direction of the snake
  /// 
  /// Returns the recommended direction to move
  Direction getNextMove({
    required List<Position> snakePosition,
    required Position foodPosition,
    required int boardWidth,
    required int boardHeight,
    required Direction currentDirection,
  }) {
    // Get the head position of the snake
    final head = snakePosition.first;
    
    // Calculate distances to food in each direction
    final distanceUp = _calculateDistanceIfMove(
      head, foodPosition, Direction.up, snakePosition, boardWidth, boardHeight);
    final distanceDown = _calculateDistanceIfMove(
      head, foodPosition, Direction.down, snakePosition, boardWidth, boardHeight);
    final distanceLeft = _calculateDistanceIfMove(
      head, foodPosition, Direction.left, snakePosition, boardWidth, boardHeight);
    final distanceRight = _calculateDistanceIfMove(
      head, foodPosition, Direction.right, snakePosition, boardWidth, boardHeight);
    
    // Create a map of directions and their safety scores
    final directionScores = {
      Direction.up: distanceUp,
      Direction.down: distanceDown,
      Direction.left: distanceLeft,
      Direction.right: distanceRight,
    };
    
    // Remove invalid moves (collisions with walls or self)
    _removeInvalidMoves(directionScores, head, snakePosition, boardWidth, boardHeight);
    
    // Don't allow 180-degree turns
    _preventReverseDirection(directionScores, currentDirection);
    
    // If no valid moves, just continue in current direction if possible
    if (directionScores.isEmpty) {
      return currentDirection;
    }
    
    // Find the direction with the minimum distance to food
    return directionScores.entries
        .reduce((a, b) => a.value < b.value ? a : b)
        .key;
  }
  
  /// Calculates the Manhattan distance to food if the snake moves in the given direction
  double _calculateDistanceIfMove(
    Position head,
    Position food,
    Direction direction,
    List<Position> snakeBody,
    int boardWidth,
    int boardHeight,
  ) {
    Position newHead;
    
    switch (direction) {
      case Direction.up:
        newHead = Position(head.x, head.y - 1);
        break;
      case Direction.down:
        newHead = Position(head.x, head.y + 1);
        break;
      case Direction.left:
        newHead = Position(head.x - 1, head.y);
        break;
      case Direction.right:
        newHead = Position(head.x + 1, head.y);
        break;
    }
    
    // Check if this move would result in a collision
    if (_wouldCollide(newHead, snakeBody, boardWidth, boardHeight)) {
      return double.infinity; // Return infinity for invalid moves
    }
    
    // Calculate Manhattan distance to food
    return ((newHead.x - food.x).abs() + (newHead.y - food.y).abs()).toDouble();
  }
  
  /// Checks if moving to the new position would result in a collision
  bool _wouldCollide(
    Position newHead,
    List<Position> snakeBody,
    int boardWidth,
    int boardHeight,
  ) {
    // Check for wall collision
    if (newHead.x < 0 || newHead.x >= boardWidth || 
        newHead.y < 0 || newHead.y >= boardHeight) {
      return true;
    }
    
    // Check for self collision (skip the tail as it will move)
    for (int i = 0; i < snakeBody.length - 1; i++) {
      if (newHead == snakeBody[i]) {
        return true;
      }
    }
    
    return false;
  }
  
  /// Removes directions that would lead to collisions
  void _removeInvalidMoves(
    Map<Direction, double> directionScores,
    Position head,
    List<Position> snakeBody,
    int boardWidth,
    int boardHeight,
  ) {
    directionScores.removeWhere((direction, score) {
      Position newHead;
      
      switch (direction) {
        case Direction.up:
          newHead = Position(head.x, head.y - 1);
          break;
        case Direction.down:
          newHead = Position(head.x, head.y + 1);
          break;
        case Direction.left:
          newHead = Position(head.x - 1, head.y);
          break;
        case Direction.right:
          newHead = Position(head.x + 1, head.y);
          break;
      }
      
      return _wouldCollide(newHead, snakeBody, boardWidth, boardHeight);
    });
  }
  
  /// Prevents the snake from making a 180-degree turn
  void _preventReverseDirection(
    Map<Direction, double> directionScores,
    Direction currentDirection,
  ) {
    switch (currentDirection) {
      case Direction.up:
        directionScores.remove(Direction.down);
        break;
      case Direction.down:
        directionScores.remove(Direction.up);
        break;
      case Direction.left:
        directionScores.remove(Direction.right);
        break;
      case Direction.right:
        directionScores.remove(Direction.left);
        break;
    }
  }
}
