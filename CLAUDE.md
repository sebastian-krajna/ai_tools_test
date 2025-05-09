# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository contains a Flutter project that showcases different AI tool implementations (Cursor, Copilot, and Aider) of two applications:

1. **To-Do App** - Multiple implementations of a task management application with various architectures
2. **Snake Game** - Different implementations of the classic Snake game

## Project Structure

The project is organized into the following key directories:

- `lib/to-do/` - Contains different To-Do app implementations
  - `cursor/` - Cursor's implementation using SharedPreferences for storage
  - `copilot/` - Copilot's implementation using Hive for storage
  - `aider/` - Aider's implementation using Hive with service abstraction
  - `augmented_code/` - Enhanced implementation with comprehensive architecture
- `lib/snake/` - Contains Snake game implementations from different AI tools
- `test/` - Contains test files for the applications

## Build & Development Commands

### Setup & Dependencies

```bash
# Install dependencies
flutter pub get

# Generate code (required for Hive models)
flutter pub run build_runner build --delete-conflicting-outputs
```

### Running the Application

```bash
# Run the application in debug mode
flutter run

# Run on a specific device (when multiple connected)
flutter run -d <device_id>
```

### Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test <path_to_test_file>

# Run tests with coverage
flutter test --coverage
```

### Linting & Analysis

```bash
# Run static analysis
flutter analyze

# Fix formatting issues
flutter format .
```

## Architecture Overview

### To-Do App Architecture (Augmented Implementation)

The most comprehensive To-Do implementation follows a structured architecture:

1. **Models** - Data classes for tasks with serialization support
   - Task model with Hive integration for persistence
   - Priority enums and extensions for task categorization

2. **Providers** - State management using Provider pattern
   - TaskProvider handles task CRUD operations and storage
   - ThemeProvider manages application theme settings

3. **Screens** - UI components for different app views
   - TaskListScreen for displaying and managing tasks
   - TaskFormScreen for creating and editing tasks
   - TaskDetailScreen for viewing task details

4. **Services** - Abstracted storage layer
   - StorageService provides a consistent API for data persistence
   - Uses Hive for efficient local storage

5. **Widgets** - Reusable UI components
   - Task-related widgets like TaskListItem, PriorityBadge, etc.
   - UI utilities for consistent visual representation

6. **Utils** - Helper functions and constants
   - Date formatting utilities
   - Priority helpers
   - Application constants

### Snake Game Implementation

The Snake game implementations demonstrate different approaches to game development in Flutter:

1. **Game Loop** - Each implementation has its own game loop mechanism
2. **State Management** - Various approaches to managing game state
3. **Rendering** - Custom rendering using Canvas or built-in widgets
4. **Input Handling** - Different methods for user input (gestures, buttons)

## Testing Strategy

The project uses Flutter's testing framework with:

1. **Unit Tests** - For testing individual components:
   - Model tests: Verify object creation, serialization, and methods
   - Provider tests: Validate state management logic
   - Utility tests: Ensure helper functions work correctly

2. **Widget Tests** - For testing UI components in isolation

Tests are located in test directories, and can be run using the standard Flutter test commands.

## Library Dependencies

Key dependencies used in the project:

- `provider` - For state management
- `hive` and `hive_flutter` - For local data storage
- `shared_preferences` - Alternative storage mechanism
- `intl` - For date/time formatting
- `uuid` - For generating unique identifiers
- `build_runner` and `hive_generator` - For code generation