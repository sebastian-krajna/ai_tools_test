# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Flutter-based Todo application that allows users to create, update, and manage tasks with various features:
- Task management with CRUD operations
- Task prioritization (low, medium, high)
- Due dates for tasks
- Persistent storage using SharedPreferences
- Sorting tasks by priority, due date, or completion status
- Light and dark theme support

## Project Structure

The project follows a standard Flutter architecture with the following key components:

1. **Models**: Data structures representing business entities
   - `Task`: Represents a to-do item with properties like title, description, priority, etc.

2. **Providers**: State management using the Provider pattern
   - `TaskProvider`: Manages task state, including CRUD operations and sorting

3. **Services**: External interactions and utilities
   - `StorageService`: Handles persistence with SharedPreferences

4. **UI**: User interface components
   - `screens`: Major application screens (home, detail, form)
   - `widgets`: Reusable UI components
   - `theme`: App-wide theming

## Common Commands

### Development

```bash
# Get dependencies
flutter pub get

# Run the application
flutter run

# Run on a specific device
flutter run -d [device_id]
flutter run -d chrome  # For web
```

### Building

```bash
# Build for Android
flutter build apk
flutter build appbundle  # For Play Store

# Build for iOS
flutter build ios

# Build for web
flutter build web
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

### Code Quality

```bash
# Analyze the code
flutter analyze

# Format code (auto-fix)
flutter format .
```

### Dependency Management

```bash
# Add a dependency
flutter pub add [package_name]

# Remove a dependency
flutter pub remove [package_name]

# Update dependencies
flutter pub upgrade
```

### Generate Mocks (for testing)

```bash
# Generate mock classes
flutter pub run build_runner build

# Generate mocks with cleanup
flutter pub run build_runner build --delete-conflicting-outputs
```

## Architecture Notes

### State Management

The app uses the Provider pattern for state management. The `TaskProvider` class is responsible for:
- Maintaining the current state of tasks
- Providing methods to add, update, and delete tasks
- Handling task sorting and filtering
- Persisting changes to storage

### Data Flow

1. UI interactions trigger methods in the `TaskProvider`
2. `TaskProvider` updates its internal state and persists changes via `StorageService`
3. UI components listen to changes in the `TaskProvider` and rebuild when needed

### Storage

Task persistence is implemented using SharedPreferences, which stores task data as JSON strings. The `StorageService` class handles the serialization and deserialization of tasks.

## Known Issues and TODOs

- The mock test setup is incomplete and needs to properly inject the MockStorageService
- Error handling could be improved with more detailed user feedback
- No synchronization for tasks across devices