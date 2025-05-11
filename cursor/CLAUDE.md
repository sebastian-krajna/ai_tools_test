# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a modern to-do list application built with Flutter, following Material Design 3 principles and implementing local data persistence with Hive. The application allows users to manage tasks with features like adding, editing, deleting, and marking tasks as complete.

## Development Commands

### Setup and Dependencies

```bash
# Install dependencies
flutter pub get

# Generate Hive adapters (required after model changes)
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

## Project Architecture

The application follows a clean architecture approach:

### Data Layer

- **Models** (`lib/models/`): Core data structures and business logic
  - `Task` class with properties: id, title, description, priority, dueDate, isCompleted, createdAt
  - `TaskPriority` enum with levels: low, medium, high
  - Hive adapters for persistence

### State Management

- **Providers** (`lib/providers/`): Manage application state using the Provider pattern
  - `TaskProvider`: Handles task CRUD operations and sorting (by priority, due date, completion, creation date)
  - `ThemeProvider`: Manages light/dark theme state with persistence

### Presentation Layer

- **Screens** (`lib/screens/`): Main UI containers
  - `HomeScreen`: Main screen with task list and tabs for active/completed tasks
  - `TaskDetailScreen`: Detailed view of a task
  - `TaskFormScreen`: Form for creating/editing tasks

- **Widgets** (`lib/widgets/`): Reusable UI components
  - `TaskItem`: List item representation with animations and visual indicators
  - `TaskForm`: Form component for task creation/editing

### Persistence

- **Hive Storage**: Local database for storing tasks and settings
  - Tasks are stored in a Hive box named 'tasks'
  - Theme preferences are stored in a Hive box named 'settings'

## Key Implementation Details

1. **Task Lifecycle**:
   - Tasks can be created, read, updated, and deleted through the `TaskProvider`
   - Each task has a unique UUID generated upon creation
   - Tasks include metadata like creation time and completion status

2. **UI Features**:
   - Material Design 3 with adaptive light/dark themes
   - Animated transitions for task completion
   - Visual indicators for task priority and due dates
   - Swipe-to-delete functionality
   - Sorting options for tasks

3. **Data Flow**:
   - `TaskProvider` loads tasks from Hive storage on initialization
   - UI components observe the provider state and rebuild when data changes
   - Changes to tasks trigger persistence operations and UI updates
   - Theme changes are persisted and applied immediately