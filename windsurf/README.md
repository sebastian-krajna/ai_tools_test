# Modern Todo App

A clean, modern to-do list application built with Flutter. This app implements Material Design 3 principles and provides a comprehensive task management solution with local data persistence.

## Features

### Task Management

- **Create Tasks**: Add new tasks with title, description, priority level, and due date
- **Update Tasks**: Edit existing tasks to modify any of their attributes
- **Complete Tasks**: Mark tasks as completed with a satisfying animation
- **Delete Tasks**: Remove tasks you no longer need with swipe-to-delete functionality

### User Interface

- **Material Design 3**: Clean, modern UI with proper theming and adaptable colors
- **Task List**: Shows all tasks with visual indicators for priority and due dates
- **Task Details**: Dedicated view for examining and managing individual tasks
- **Task Form**: User-friendly form for adding and editing tasks
- **Sorting Options**: Sort tasks by priority, due date, completion status, and more
- **Light/Dark Mode**: Automatically adapts to system theme settings

### Architecture & Technical Features

- **Provider Pattern**: State management using the Provider package
- **Local Storage**: Data persistence with SharedPreferences
- **SOLID Principles**: Code organized following best practices
- **Clean Code**: Separation of UI from business logic
- **Unit Tests**: Basic tests for core functionality

## Project Structure

```
lib/
├── models/         # Data models
├── providers/      # State management
├── screens/        # UI screens
├── services/       # Data persistence
├── utils/          # Helper utilities
├── widgets/        # Reusable UI components
└── main.dart       # Application entry point
```

## Getting Started

1. Ensure you have Flutter installed (v3.19.0 or higher recommended)
2. Clone the repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the application

## Development Notes

- The app follows an organized architecture separating concerns between data, business logic, and UI
- Error handling is implemented throughout the app
- SharedPreferences is used for simplicity, but could be replaced with a more robust solution like Hive or SQLite for larger apps
- The Provider package manages state effectively without unnecessary complexity
