# Flutter To-Do App

A modern to-do list application built with Flutter, implementing Material Design 3 and following SOLID principles.

## Features

- **Task Management**
  - Add new tasks with title, description, priority, and due date
  - Mark tasks as complete
  - Delete tasks
  - Edit existing tasks

- **User Interface**
  - Clean, modern Material Design 3 UI with proper theming
  - Task list with sorting options (by priority, due date, completion status)
  - Task details view
  - Form for adding/editing tasks
  - Visual indicators for priority and due date status
  - Animation for completing tasks

- **State Management**
  - Implemented using Provider pattern
  - Data persistence using Hive
  - Efficient state handling

## Project Structure

```
lib/to-do/augmented_code/
├── models/
│   └── task.dart
├── providers/
│   ├── task_provider.dart
│   └── theme_provider.dart
├── screens/
│   ├── task_detail_screen.dart
│   ├── task_form_screen.dart
│   └── task_list_screen.dart
├── services/
│   └── storage_service.dart
├── utils/
│   ├── date_formatter.dart
│   └── priority_helper.dart
├── widgets/
│   ├── due_date_badge.dart
│   ├── empty_state.dart
│   ├── priority_badge.dart
│   ├── sort_options.dart
│   └── task_list_item.dart
└── main.dart
```

## Running the App

1. Make sure you have Flutter installed and set up on your machine.
2. Navigate to the project directory.
3. Run the following commands:

```bash
# Get dependencies
flutter pub get

# Generate Hive adapters
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

## Design Decisions

- **State Management**: Provider pattern was chosen for its simplicity and efficiency in managing app state.
- **Local Storage**: Hive was used for local storage due to its performance and ease of use.
- **UI Design**: Material Design 3 was implemented to provide a modern and consistent user experience.
- **Code Organization**: The code is organized following SOLID principles, with clear separation of concerns:
  - Models for data structure
  - Providers for state management
  - Screens for UI layout
  - Widgets for reusable UI components
  - Services for external operations
  - Utils for helper functions

## Future Improvements

- Add categories for tasks
- Implement search functionality
- Add notifications for upcoming tasks
- Sync with cloud storage
- Add unit and widget tests
