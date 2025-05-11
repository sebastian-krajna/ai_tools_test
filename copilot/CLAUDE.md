# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository contains a modern, feature-rich to-do list application built with Flutter using Material Design 3 (Material You) principles.

## Project Structure

The codebase follows a clean architecture approach with the following components:

- **Models**: Define data structures (`lib/models/`)
- **Services**: Handle business logic and data operations (`lib/services/`)
- **Providers**: Manage state and connect UI to services (`lib/providers/`)
- **Screens**: Display full pages of the app (`lib/screens/`)
- **Widgets**: Reusable UI components (`lib/widgets/`)
- **Utils**: Utility functions and theme management (`lib/utils/`)

## Common Commands

### Development

```bash
# Get dependencies
flutter pub get

# Run the app in debug mode
flutter run

# Build the app for different platforms
flutter build apk     # Android
flutter build ios     # iOS
flutter build web     # Web
flutter build macos   # macOS
```

### Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run a specific test file
flutter test test/model_test.dart
flutter test test/provider_test.dart
flutter test test/widget_test.dart

# Run a specific test group or test
flutter test --name "Task Model Tests"
flutter test --name "Initial state"
```

### Code Quality

```bash
# Run the analyzer 
flutter analyze

# Fix linting issues automatically where possible
dart fix --apply

# Format code according to Dart style guidelines
dart format lib test
```

## State Management & Architecture

The app uses the Provider pattern for state management with the following key components:

### State Management

- **TaskProvider**: Central class managing task state, including loading, sorting, and CRUD operations
- Utilizes the `ChangeNotifier` mechanism from the Provider package for efficient UI updates

### Data Persistence

- Uses Hive, a lightweight and fast NoSQL database, for local storage
- **StorageService**: Abstraction layer for all storage operations, simplifying testing and potential backend changes
- Data is automatically persisted on all changes

### Key Classes

- **Task**: Core model representing a to-do item with various properties (title, description, priority, due date, etc.)
- **TaskPriority**: Enum for priority levels (low, medium, high)
- **TaskSortOption**: Enum for different sorting strategies

## Testing Approach

The app follows a comprehensive testing strategy:

1. **Model Tests**: Verify the Task model's correctness
   - Object creation, property access, serialization methods

2. **Provider Tests**: Ensure business logic works as expected
   - CRUD operations, sorting functionality, state updates

3. **Widget Tests**: Validate UI components behave correctly
   - User interactions, rendering, state changes

Mock implementations of services (e.g., MockStorageService) are used to isolate test layers and ensure consistent test behavior.

## Feature Implementation Guidelines

When adding new features to the app, follow these patterns:

1. Start with the data model, ensuring proper serialization for Hive storage
2. Update the service layer to handle the data operations
3. Extend provider classes to expose functionality to the UI
4. Implement UI components, following Material Design 3 principles
5. Write tests at all appropriate levels (model, provider, widget)

## Additional Notes

- The app uses the provider pattern throughout - avoid mixing other state management approaches
- Always maintain the clean architecture separation between UI, business logic, and data access
- Follow existing patterns for error handling and asynchronous operations
- The UI follows Material Design 3 principles, including proper theming and animations