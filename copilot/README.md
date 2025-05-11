# Flutter ToDo App

A modern, feature-rich to-do list application built with Flutter using Material Design 3 (Material You) principles.

## Features

### Task Management
- Create tasks with title, description, priority levels, and due dates
- Mark tasks as complete with animation
- Delete tasks with swipe actions and confirmation dialogs
- Edit existing tasks

### User Interface
- Clean, modern Material Design 3 UI with proper theming
- Light and dark theme support
- Task list with multiple sorting options:
  - By priority (low/medium/high)
  - By due date
  - By completion status
  - By creation date
- Visual indicators for priority and due date status
- Detailed task view
- Form for adding/editing tasks
- Animations for task completion and list updates

### State Management & Data Persistence
- Provider pattern for state management
- Local data persistence using Hive
- Efficient state updates

### Code Quality
- SOLID principles
- Separation of UI from business logic
- Error handling
- Unit tests for models and business logic

## Project Structure

```
lib/
├── main.dart              # App entry point
├── models/                # Data models
│   └── task.dart          # Task model definition
├── providers/             # State management
│   └── task_provider.dart # Task state provider
├── screens/               # App screens
│   ├── task_detail_screen.dart  # Task details view
│   ├── task_form_screen.dart    # Add/edit task form
│   └── task_list_screen.dart    # Main task list
├── services/              # Business logic services
│   └── storage_service.dart     # Local storage service
├── utils/                 # Utility classes
│   ├── app_theme.dart     # Theme configuration
│   └── date_formatter.dart      # Date formatting utilities
└── widgets/               # Reusable UI components
    └── task_item.dart     # Task list item widget
```

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/todo_app.git
cd todo_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Architecture

The app follows a clean architecture approach:

- **Models**: Define data structures
- **Services**: Handle business logic and data operations
- **Providers**: Manage state and connect UI to services
- **Screens**: Display full pages of the app
- **Widgets**: Reusable UI components

## State Management

The app uses the Provider pattern for state management:
- `TaskProvider`: Manages the state of tasks, including loading, sorting, and CRUD operations

## Data Persistence

Data is persisted locally using Hive, a lightweight and fast NoSQL database:
- Tasks are saved in a Hive box
- Data is loaded when the app starts
- All changes are immediately persisted

## Testing

The app includes several types of tests:
- Unit tests for the Task model
- Unit tests for the TaskProvider
- Widget tests for UI components

Run tests with:
```bash
flutter test
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Material Design team for the design system
