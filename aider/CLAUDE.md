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
flutter run -d macos  # For macOS app

# Enable web platform (if needed)
flutter config --enable-web

# Clear derived files and rebuild
flutter clean && flutter pub get

# Check the current Flutter setup
flutter doctor
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

# Build for macOS
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

# Generate coverage report (requires lcov)
genhtml coverage/lcov.info -o coverage/html

# Run tests with verbose output
flutter test --verbose
```

### Code Quality

```bash
# Analyze the code
flutter analyze

# Format code (auto-fix)
flutter format .

# Run linter with specific rules
flutter analyze --fatal-infos
```

### Dependency Management

```bash
# Add a dependency
flutter pub add [package_name]

# Remove a dependency
flutter pub remove [package_name]

# Update dependencies
flutter pub upgrade

# Check for outdated packages
flutter pub outdated
```

### Generate Mocks (for testing)

```bash
# Generate mock classes
flutter pub run build_runner build

# Generate mocks with cleanup
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes and rebuild mocks
flutter pub run build_runner watch
```

## Architecture Notes

### State Management

The app uses the Provider pattern for state management. The `TaskProvider` class is responsible for:
- Maintaining the current state of tasks
- Providing methods to add, update, and delete tasks
- Handling task sorting and filtering
- Persisting changes to storage

#### Task Model Structure

The `Task` model includes:
- Unique ID (generated with UUID)
- Title and description
- Due date (optional)
- Completion status
- Priority level (low, medium, high)

The model implements serialization methods (`toJson`/`fromJson`) for persistence and a `copyWith` method for immutable updates.

### Data Flow

1. UI interactions trigger methods in the `TaskProvider`
2. `TaskProvider` updates its internal state and persists changes via `StorageService`
3. UI components listen to changes in the `TaskProvider` and rebuild when needed

### Storage

Task persistence is implemented using SharedPreferences, which stores task data as JSON strings. The `StorageService` class handles the serialization and deserialization of tasks.

### Theming

The app supports both light and dark themes using Material 3 design principles. The theme system:
- Uses `ColorScheme.fromSeed` for color generation
- Consistently applies rounded corners to UI elements
- Adapts to system theme preferences by default
- Can be extended to support custom themes

## Core Dependencies

- **provider**: For state management
- **shared_preferences**: For local data persistence
- **intl**: For date formatting
- **uuid**: For generating unique task IDs
- **mockito**: For creating mock objects in tests
- **build_runner**: For code generation (used with mockito)
- **flutter_lints**: For code quality and static analysis

## Testing Workflow

When writing tests for the application, follow these guidelines:

1. Use the `@GenerateMocks` annotation to generate mock classes for services and dependencies.
2. Run `flutter pub run build_runner build` to generate the mock classes.
3. In your test setup, create instances of the mocks and define their behavior using `when()` and `thenAnswer()`.
4. Inject mocked dependencies into the classes being tested.
5. For testing providers, ensure they're using mocked services instead of real ones.
6. Follow the Arrange-Act-Assert pattern in your test cases.

### Example Mock Injection

The current test setup for `TaskProvider` doesn't properly inject the mock `StorageService`. To fix this:

```dart
// This would need to be implemented in the TaskProvider
TaskProvider(this._storageService);

// Then in tests
setUp(() {
  mockStorageService = MockStorageService();
  when(mockStorageService.loadTasks()).thenAnswer((_) async => []);
  taskProvider = TaskProvider(mockStorageService);
});
```

## Feature Implementation Workflow

When implementing new features or fixing bugs:

1. **Understand Requirements**: Clarify the feature's scope and behavior
2. **Plan Implementation**: Determine what files need to be modified
3. **Update Models**: If needed, modify the Task model or add new models
4. **Implement Business Logic**: Update providers with new functionality
5. **Create/Update UI**: Implement the user interface components
6. **Add Tests**: Write tests for the new functionality
7. **Verify**: Run tests and manually verify the feature works as expected

## Known Issues and TODOs

- The mock test setup is incomplete and needs to properly inject the MockStorageService
- Error handling could be improved with more detailed user feedback
- No synchronization for tasks across devices
- The app lacks user authentication for managing personal task lists