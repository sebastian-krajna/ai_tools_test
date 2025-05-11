# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository contains a Modern Todo App built with Flutter that implements Material Design 3 principles and provides comprehensive task management with local data persistence.

## Project Structure

The app follows a clean architecture pattern with a clear separation of concerns:

- `models/`: Data models (Task)
- `providers/`: State management (TaskProvider using Provider package)
- `screens/`: UI screens 
- `services/`: Data persistence (StorageService)
- `utils/`: Helper utilities
- `widgets/`: Reusable UI components
- `main.dart`: Application entry point

## Common Commands

### Setup and Development

```bash
# Install dependencies
flutter pub get

# Run the application in development mode
flutter run

# Run on specific device (when multiple connected)
flutter run -d <device_id>

# Check available devices
flutter devices

# Run the app in profile mode (performance overlay)
flutter run --profile
```

### Building

```bash
# Build for specific platform
flutter build apk        # Android APK
flutter build appbundle  # Android App Bundle
flutter build ios        # iOS (must be on macOS)
flutter build macos      # macOS application
flutter build web        # Web application

# Create a release build
flutter build apk --release
```

### Testing

```bash
# Run all tests
flutter test

# Run a specific test file
flutter test test/task_provider_test.dart

# Run tests with coverage
flutter test --coverage

# Generate coverage report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
```

### Linting and Code Quality

```bash
# Run static analysis
flutter analyze

# Format code
flutter format lib/

# Check for formatting issues without changing files
flutter format --set-exit-if-changed lib/
```

### Dependency Management

```bash
# Add a dependency
flutter pub add <package_name>

# Remove a dependency
flutter pub remove <package_name>

# Check outdated dependencies
flutter pub outdated

# Upgrade dependencies
flutter pub upgrade
```

## Architecture

The app follows a Provider-based architecture for state management:

1. **Models**: Data classes that represent the core entities (Task)
2. **Providers**: State management classes that extend ChangeNotifier
3. **Services**: Classes that handle external interactions (storage)
4. **Screens**: UI components that display and interact with the data
5. **Widgets**: Reusable UI elements

### Key Components

- **Task Model**: Represents a task with properties like title, description, priority, due date, and completion status
- **TaskProvider**: Manages the task state using the Provider pattern, with operations for adding, updating, deleting, and filtering tasks
- **StorageService**: Handles data persistence using SharedPreferences
- **Task Screens**: List view, detail view, and edit/create views for tasks

### Data Flow

1. UI actions dispatch events to the TaskProvider
2. TaskProvider updates the state and persists changes via StorageService
3. UI rebuilds based on the updated state through Provider.of or Consumer widgets

## Testing Strategy

- **Unit Tests**: Focus on business logic in TaskProvider using SharedPreferences.setMockInitialValues for data mocking
- **Widget Tests**: Test UI components and integration with providers
- **Integration Tests**: Not currently implemented, but would test full user workflows

## State Management

The app uses the Provider package for state management:

- **TaskProvider**: Central state management class that extends ChangeNotifier
- State changes trigger UI updates through Consumer widgets or Provider.of calls
- All data mutations go through the provider to maintain consistency

## Error Handling

Error handling is implemented at multiple levels:

- **TaskProvider**: Captures and exposes errors during data operations
- **UI**: Shows appropriate error messages and retry options
- **StorageService**: Handles persistence errors gracefully

## Task Operations

The app supports the following operations on tasks:

- Create: Add new tasks with title, description, priority, and due date
- Read: View task details and list all tasks
- Update: Modify task properties or toggle completion status
- Delete: Remove tasks from the list with swipe-to-delete functionality
- Sort: Arrange tasks by priority, due date, title, completion status, or creation date
- Filter: Show or hide completed tasks