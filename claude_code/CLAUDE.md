# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository contains a Flutter To-Do application with the following features:
- Task management (create, read, update, delete)
- Task prioritization (high, medium, low)
- Due date assignment and tracking
- Sorting and filtering tasks
- Dark/light theme support
- Local storage with Hive

## Build and Development Commands

### Setup and Dependencies

```bash
# Get dependencies
flutter pub get

# Generate Hive adapters
flutter pub run build_runner build --delete-conflicting-outputs
```

### Running the App

```bash
# Run in debug mode
flutter run

# Run on a specific device
flutter run -d <device_id>

# Build for specific platforms
flutter build apk      # Android
flutter build ios      # iOS
flutter build web      # Web
flutter build macos    # macOS
```

### Testing

```bash
# Run all tests
flutter test

# Run a specific test file
flutter test test/task_provider_test.dart

# Run widget tests
flutter test test/widgets/

# Run with coverage
flutter test --coverage
```

### Code Quality

```bash
# Run linter (static analysis)
flutter analyze

# Format code
flutter format lib/
```

## Code Architecture

The application follows a clean architecture pattern with clear separation of concerns:

### 1. Models

Located in `lib/models/`, these represent the data structures used throughout the app:
- `Task`: Core model with properties like title, description, priority, due date, and completion status
- Generated Hive adapters for serialization/deserialization (`task.g.dart`)
- Custom type adapters for enums (`task_priority_adapter.dart`)

### 2. Providers

Located in `lib/providers/`, these manage state using the Provider pattern:
- `TaskProvider`: Manages the collection of tasks, with methods for CRUD operations, sorting, and filtering
- `ThemeProvider`: Handles theme switching (light/dark) and persistence

### 3. Services

Located in `lib/services/`:
- `StorageService`: Manages Hive database operations for persistent storage

### 4. Screens

Located in `lib/screens/`, these define the main UI pages:
- `TaskListScreen`: Main screen displaying the list of tasks with sort/filter options
- `TaskFormScreen`: Form for creating and editing tasks
- `TaskDetailScreen`: Detailed view of a specific task

### 5. Widgets

Located in `lib/widgets/`, these are reusable UI components:
- `TaskListItem`: Displays a task in a list with swipe actions
- `PriorityBadge`: Visual representation of task priority
- `DueDateBadge`: Visual representation of task due date
- `EmptyState`: Shown when task lists are empty
- `TaskForm`: Reusable form for task creation/editing

## Data Flow

1. User interacts with UI (Screens/Widgets)
2. UI calls methods on Providers
3. Providers update data via Services (e.g., StorageService)
4. Services perform operations on the data store (Hive)
5. Changes are reflected back to UI via ChangeNotifier

## Testing Strategy

The codebase includes:
- **Unit tests** for providers and models (`task_provider_test.dart`, `task_test.dart`)
- **Widget tests** for UI components (`priority_badge_test.dart`)

Tests use mocks (e.g., `MockStorageService`) to isolate components for testing.

## Important Development Notes

- Remember to run the build_runner after making changes to Hive models
- Use Provider pattern for state management throughout the app
- Follow the existing naming conventions and code structure
- Ensure tests are written for new functionality