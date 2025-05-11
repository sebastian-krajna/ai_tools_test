# Task Manager App

A modern to-do list application built with Flutter, featuring Material Design 3 UI and local data persistence.

## Features

### Task Management
- Add new tasks with title, description, priority (low/medium/high), and due date
- Mark tasks as complete
- Delete tasks
- Edit existing tasks

### User Interface
- Clean, modern Material Design 3 UI with proper theming
- Task list with sorting options (by priority, due date, completion status)
- Task details view
- Form for adding/editing tasks
- Visual indicators for priority and due date status
- Animation for completing tasks
- Light and dark theme support

### State Management & Data Persistence
- Provider pattern for state management
- Local data persistence with Hive database
- Efficient state updates

### Code Quality
- SOLID principles implementation
- Separation of UI and business logic
- Unit tests for core functionality
- Error handling

## Project Structure

```
lib/
├── models/        # Data models
├── providers/     # State management
├── screens/       # App screens
└── widgets/       # Reusable UI components
```

## Getting Started

### Prerequisites
- Flutter SDK (latest version)
- Dart SDK (latest version)

### Installation

1. Clone this repository
2. Navigate to the project directory
3. Run the following commands:

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Running the App

```bash
flutter run
```

## Architecture

This app follows a clean architecture approach:
- **Models**: Data structures and business logic
- **Providers**: State management and business operations
- **Screens**: Top-level UI components and navigation
- **Widgets**: Reusable UI components

## Libraries Used

- **provider**: For state management
- **hive** and **hive_flutter**: For local data persistence
- **intl**: For date formatting
- **uuid**: For generating unique IDs
