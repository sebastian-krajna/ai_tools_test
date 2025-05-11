# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository contains a Flutter To-Do app with the following features:
- Task creation, editing, and deletion
- Task prioritization (low, medium, high)
- Due date assignment
- Completion status tracking
- Task sorting (by priority, due date, completion status)
- Persistent storage using SharedPreferences

## Development Commands

### Setup & Installation

```bash
# Install dependencies
flutter pub get
```

### Running the App

```bash
# Run the app in debug mode
flutter run

# Run the app on a specific device
flutter run -d [device_id]

# Run the app with specific flavor or configuration
flutter run --flavor [flavor]
```

### Building the App

```bash
# Build APK for Android
flutter build apk

# Build app bundle for Android
flutter build appbundle

# Build for iOS
flutter build ios

# Build for MacOS
flutter build macos
```

### Testing

```bash
# Run all tests
flutter test

# Run a specific test file
flutter test test/task_provider_test.dart

# Run tests with coverage
flutter test --coverage
```

### Linting & Analysis

```bash
# Run the Dart analyzer
flutter analyze

# Format code
flutter format lib/

# Check for unused dependencies
flutter pub deps --style=compact
```

## Architecture & Structure

This Flutter app follows a Provider pattern for state management:

### Core Components

1. **Models**
   - `Task`: Defines the task model with properties (id, title, description, priority, dueDate, isCompleted)
   - `Priority` enum: Defines priority levels (low, medium, high)

2. **Providers**
   - `TaskProvider`: Manages tasks state and operations (add, update, delete, toggle completion)
   - Uses `ChangeNotifier` for state management
   - Manages task sorting with `SortOption` enum (priority, dueDate, completion)

3. **Services**
   - `StorageService`: Handles persistence using SharedPreferences
   - Serializes/deserializes tasks to/from JSON
   - Provides loadTasks() and saveTasks() methods used by TaskProvider

4. **Screens**
   - `TaskListScreen`: Shows all tasks with sorting options
   - `TaskFormScreen`: Form for adding/editing tasks
   - `TaskDetailScreen`: Displays details of a single task

5. **Widgets**
   - `TaskTile`: UI component for individual tasks in the list

### Data Flow

1. UI interactions trigger methods in the TaskProvider
2. TaskProvider updates the task list in memory
3. TaskProvider saves changes to local storage via StorageService
4. TaskProvider notifies listeners causing UI to rebuild

### App Entry Point

The app is initialized in `main.dart` where:
- The TaskProvider is registered using ChangeNotifierProvider
- MaterialApp is configured with the TaskListScreen as the home screen
- Theme settings are defined using Material 3 design

## Coding Conventions

- Use proper error handling in async operations
- Follow standard Flutter Provider pattern for state management
- Maintain separation of concerns between models, providers, services, screens, and widgets
- Use copyWith pattern for immutable updates to model objects
- Format code according to standard Dart conventions using `flutter format`

## Implementation Notes

### StorageService
- Uses SharedPreferences for task persistence
- JSON-encodes task data for storage
- Handles proper serialization of enum values and dates

### TaskProvider
- Central state management using ChangeNotifier
- All task operations should update storage via StorageService
- Implements optimistic UI updates (UI updates before async operations complete)
- Error handling included for all async operations

### Testing
- Provider tests focus on business logic verification
- Mock StorageService when testing TaskProvider in isolation
- Test both success and error scenarios