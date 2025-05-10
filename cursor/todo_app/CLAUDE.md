# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a modern to-do list application built with Flutter, following Material Design 3 principles and implementing local data persistence with Hive. The application allows users to manage tasks with features like adding, editing, deleting, and marking tasks as complete.

## Project Structure

The application follows a clean architecture approach:

- **models/**: Data structures and business logic
  - `task.dart`: Core Task model with properties and methods
  - `task.g.dart`: Generated Hive adapter code
  - `task_priority_adapter.dart`: Custom Hive adapter for TaskPriority enum

- **providers/**: State management classes using Provider pattern
  - `task_provider.dart`: Manages task data and CRUD operations
  - `theme_provider.dart`: Handles theme state and preferences

- **screens/**: Main application views
  - `home_screen.dart`: Main screen with task list and tabs
  - `task_detail_screen.dart`: Detailed view of a task
  - `task_form_screen.dart`: Form for creating/editing tasks

- **widgets/**: Reusable UI components
  - `task_form.dart`: Form widget for task creation/editing
  - `task_item.dart`: List item representation of a task

## Development Commands

### Setup and Installation

```bash
# Install dependencies
flutter pub get

# Generate Hive adapters
flutter pub run build_runner build --delete-conflicting-outputs

# Clean and regenerate (if having issues with generated code)
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Running the App

```bash
# Run in debug mode
flutter run

# Run with specific device
flutter run -d <device_id>

# Run in release mode
flutter run --release
```

### Testing

```bash
# Run all tests
flutter test

# Run a specific test file
flutter test test/task_test.dart

# Run tests with coverage
flutter test --coverage
```

### Building

```bash
# Build Android APK
flutter build apk

# Build iOS
flutter build ios

# Build web version
flutter build web
```

## Key Architecture Concepts

1. **State Management**: The app uses the Provider pattern for state management:
   - `TaskProvider` manages the task collection and persistence operations
   - `ThemeProvider` handles theme state (light/dark mode)
   - Both providers use `ChangeNotifier` for reactive UI updates

2. **Data Persistence**: The app uses Hive for local storage:
   - Tasks are stored in a Hive box named 'tasks'
   - Theme preferences are stored in a Hive box named 'settings'
   - Custom adapters are used for serializing the Task model and TaskPriority enum

3. **UI Architecture**: 
   - Material Design 3 with light/dark theme support
   - Task items show visual indicators for priority and due date status
   - Animated interactions for task completion and list operations

4. **Task Management**:
   - Tasks have properties: id, title, description, priority, dueDate, isCompleted, createdAt
   - Tasks can be sorted by priority, due date, completion status, or creation date
   - Task priority is represented as an enum with low, medium, and high levels