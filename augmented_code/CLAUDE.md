# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Flutter ToDo app project implementing a feature-rich task management application. The app allows users to create, view, edit, and delete tasks with various attributes like priority levels, due dates, and completion status.

## Development Commands

### Setup and Installation

```bash
# Install dependencies
flutter pub get

# Generate Hive adapters (required after model changes)
flutter pub run build_runner build --delete-conflicting-outputs
```

### Running the App

```bash
# Run in debug mode
flutter run

# Run on a specific device
flutter run -d <device_id>

# Run with specific flavor/configuration
flutter run --flavor dev
```

### Testing

```bash
# Run all tests
flutter test

# Run a specific test file
flutter test test/models/task_test.dart

# Run tests with coverage
flutter test --coverage
```

### Linting and Analysis

```bash
# Analyze code with Dart analyzer
flutter analyze

# Format code
flutter format lib/
```

### Building

```bash
# Build APK for Android
flutter build apk

# Build App Bundle for Android
flutter build appbundle

# Build for iOS
flutter build ios

# Build for web
flutter build web
```

## Architecture

The app follows a clean architecture pattern with Provider for state management and Hive for local storage:

### Key Components

1. **Models** (`lib/models/`)
   - `Task`: Core data model representing a to-do item with properties like title, description, priority, due date, and completion status
   - Uses Hive annotations for local persistence

2. **Repositories** (`lib/repositories/`)
   - `TaskRepository`: Manages data operations (CRUD) for tasks
   - Interfaces with Hive for local storage

3. **Providers** (`lib/providers/`)
   - `TaskProvider`: Manages application state related to tasks
   - Implements business logic like sorting, filtering, and task operations
   - Extends ChangeNotifier for state management

4. **Screens** (`lib/screens/`)
   - `TaskListScreen`: Main screen displaying all tasks
   - `TaskDetailsScreen`: Screen for viewing task details
   - `TaskFormScreen`: Screen for creating and editing tasks

5. **Widgets** (`lib/widgets/`)
   - Reusable UI components like `TaskListItem`, `PrioritySelector`, etc.

6. **Utils** (`lib/utils/`)
   - Helper classes like `DateFormatter` for utility functions

7. **Constants** (`lib/constants/`)
   - App-wide constants like colors and theme settings

### Data Flow

1. UI components use `TaskProvider` to interact with data
2. `TaskProvider` uses `TaskRepository` to perform CRUD operations
3. `TaskRepository` uses Hive to persist data locally
4. State changes in `TaskProvider` trigger UI updates via ChangeNotifier/Consumer pattern

## Important Implementation Details

1. **Hive for Local Storage**
   - Task data is persisted using Hive
   - Type adapters are registered in `TaskRepository.init()`
   - Generated code is in `*.g.dart` files

2. **Provider for State Management**
   - Main state container is the `TaskProvider` class
   - Initialized in `main.dart` and provided to the widget tree

3. **Sorting and Filtering**
   - Tasks can be sorted by different criteria (priority, due date, title, creation date)
   - Completed tasks can be shown first based on user preference

4. **Task Features**
   - Each task has a priority level (low, medium, high)
   - Tasks can have optional due dates with time
   - Tasks can be marked as completed
   - Tasks have visual indicators for priority and overdue status

## Testing Approach

1. **Model Tests**
   - Verify constructors, property accessors, and methods like `copyWith`

2. **Provider Tests**
   - Test state management logic using a mock repository
   - Verify sorting, filtering, and CRUD operations

3. **Repository Tests**
   - Test data operations using Hive

4. **Utils Tests**
   - Test utility functions like date formatting