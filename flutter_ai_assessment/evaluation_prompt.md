Comprehensive Flutter To-Do App Evaluation Prompt
This evaluation prompt includes a structured template format to ensure consistent evaluation across different AI-generated Flutter applications.
# Flutter To-Do App Evaluation

## Evaluator Role

As an evaluator, you should adopt the perspective of a Senior Flutter Developer with 5+ years of experience, who regularly performs code reviews for enterprise Flutter applications. You should:

1. **Be thorough but pragmatic** - Focus on issues that would impact maintainability, performance, and user experience
2. **Consider trade-offs** - Recognize that simpler solutions might be preferable to technically perfect but overly complex ones
3. **Evaluate as a maintainer** - Consider if you would be comfortable maintaining this codebase for the next year
4. **Apply industry standards** - Use Flutter's official style guide and community best practices as your reference point
5. **Consider both technical correctness and practical usability** - Code that works perfectly but is hard to understand should be flagged

Your goal is to provide specific, actionable feedback that would help improve the application's quality, maintainability, and adherence to modern Flutter development standards.

## User Input Requirements

As some aspects of app evaluation require hands-on testing, please provide your input on the following items before or during the evaluation process:

### Required User Verification Points
Please test and provide feedback on these aspects:

1. **Build & Deployment**
   - Does the app build without manual configuration changes?
   - Are there any runtime errors not visible in the code?
   - Approximately how long does the app take to start up?

2. **Performance & UX**
   - How smooth are the animations (particularly task completion animation)?
   - Is there any noticeable lag when navigating between screens?
   - How does the app perform with 50+ tasks in the list?

3. **Practical Usability**
   - Rate the intuitiveness of the UI (1-5)
   - Are there any accessibility issues you notice?
   - Would you feel comfortable using this app daily?

### Instructions for Testing
1. Build and run the app on a real device or emulator
2. Add at least 10 tasks with various priorities and due dates
3. Sort tasks using all available sorting options
4. Complete, edit, and delete several tasks
5. Pay attention to animation smoothness and overall responsiveness
6. Test with screen readers or accessibility tools if possible

When evaluating the respective sections, the AI will prompt you for this input with the notation [USER INPUT REQUIRED].

## Evaluation Process Guidelines
1. **Reference the original prompt**: Always refer back to the original prompt to verify if requirements were met.
2. **Code examples**: Include specific code snippets when discussing strengths or weaknesses.
3. **Technical metrics approach**: For complexity metrics, you don't need exact measurements but should identify obvious issues like excessively large methods or classes with too many responsibilities.
4. **Pattern evaluation**: When evaluating patterns:
   * First check if the Provider pattern was implemented as requested
   * Note any additional patterns used and whether they enhance or complicate the solution
   * Identify if any anti-patterns are present that could cause future maintenance issues
5. **Balanced feedback**: Provide both positive aspects and areas for improvement, even in strong implementations.
6. **Follow the structured templates**: Complete all tables and forms provided to ensure consistent evaluation.

**Purpose**: These guidelines ensure thorough and consistent evaluations across Flutter applications. They help evaluators focus on both technical implementation and adherence to requirements.

**Application**: Apply these principles throughout all sections of this template. When completing checklists and ratings, provide specific evidence from the code to support your assessments. For pattern evaluation, refer to sections on Provider implementation (Requirements Compliance, Project Structure) and anti-patterns (Flutter Bad Practices Check).

## **Prompt Used**

"Create a Flutter app that implements a modern to-do list with these features:

1. Task management:  
   * Add new tasks with title, description, priority (low/medium/high), and due date  
   * Mark tasks as complete  
   * Delete tasks  
   * Edit existing tasks  
2. User interface:  
   * Clean, modern Material Design 3 UI with proper theming  
   * Task list with sorting options (by priority, due date, completion status)  
   * Task details view  
   * Form for adding/editing tasks  
   * Visual indicators for priority and due date status  
   * Animation for completing tasks  
3. State management:  
   * Implement using a Provider pattern  
   * Persist data locally using either Hive or SharedPreferences  
   * Handle state changes efficiently  
4. Code quality:  
   * Follow SOLID principles  
   * Separate UI from business logic  
   * Include appropriate comments  
   * Implement error handling  
   * Add basic unit tests for the main functionality

Please provide complete, runnable code with proper project structure and all necessary files. The app should be ready to run without requiring additional implementation. If you need to make architectural decisions, prefer simplicity and clarity over complex patterns. Explain any key design decisions in comments within the code."

## SECTION 1: Requirements Compliance Checklist
Please complete the following checklist with Yes/No/Partial for each item:

| Requirement | Implemented? | Notes/Examples |
|-------------|--------------|---------------|
| **Task Management** | | |
| - Add tasks with title | | |
| - Add tasks with description | | |
| - Add tasks with priority | | |
| - Add tasks with due date | | |
| - Mark tasks as complete | | |
| - Delete tasks | | |
| - Edit existing tasks | | |
| **User Interface** | | |
| - Material Design 3 UI | | |
| - Proper theming | | |
| - Task list with sorting options | | |
| - Task details view | | |
| - Form for adding/editing | | |
| - Visual indicators for priority | | |
| - Visual indicators for due date | | |
| - Animation for completing tasks | | |
| **State Management** | | |
| - Provider pattern | | |
| - Local persistence | | |
| - Efficient state handling | | |
| **Code Quality** | | |
| - SOLID principles | | |
| - UI/business logic separation | | |
| - Appropriate comments | | |
| - Error handling | | |
| - Unit tests | | |

**Additional Features Beyond Requirements:**
- List any features implemented that weren't requested

## SECTION 2: Implementation Completeness Check

Evaluate whether the application is fully runnable or requires additional implementation:

| Aspect | Complete? | Notes |
|--------|-----------|-------|
| All required dependencies in pubspec.yaml | | |
| App builds without manual configuration | [USER INPUT REQUIRED] | |
| All screens/views implemented | | |
| Data models completely defined | | |
| State management fully implemented | | |
| Main functionality works without additional coding | [USER INPUT REQUIRED] | |
| Error states and edge cases handled | | |

## SECTION 3: Technical Quality Metrics

| Metric | Rating (1-5) | Notes/Examples |
|--------|--------------|---------------|
| **Code Complexity** | | |
| - Function/method complexity | | |
| - Class size and responsibility | | |
| - Component coupling | | |
| **Test Coverage** | | |
| - Business logic test coverage | | |
| - Test quality and edge cases | | |
| **Technical Debt** | | |
| - Code duplication | | |
| - Component dependencies | | |
| - Architecture consistency | | |

## SECTION 4: Project Structure and Architecture

| Aspect | Rating (1-5) | Notes/Examples |
|--------|--------------|---------------|
| Logical organization | | |
| File grouping strategy | | |
| Separation of concerns | | |
| Provider pattern implementation | | |
| SOLID principles application | | |

**Folder Structure Overview:**
Copy and describe the main folders/files structure here

## SECTION 5: Flutter Implementation Quality

| Aspect | Rating (1-5) | Notes/Examples |
|--------|--------------|---------------|
| **UI Implementation** | | |
| - Material Design 3 compliance | | |
| - Widget composition | | |
| - Widget type appropriateness | | |
| - Animation quality | [USER INPUT REQUIRED] | |
| **State Management** | | |
| - Provider implementation | | |
| - State update efficiency | | |
| - Local persistence implementation | | |
| **Flutter Patterns** | | |
| - StatelessWidget vs StatefulWidget usage | | |
| - Const constructors usage | | |
| - Widget tree optimization | | |
| - Build method implementation | | |
| **Advanced Implementation** | | |
| - Proper lifecycle management | | |
| - Responsive layout techniques | | |
| - Form validation approach | | |
| - Dialog and modal implementation | | |
| - List optimization techniques | | |

## SECTION 6: Libraries and Dependencies

| Library | Version | Status | Appropriateness |
|---------|---------|--------|----------------|
| | | | |
| | | | |
| | | | |
| | | | |

**Status Legend:** Active/Maintained, Deprecated, Overkill, Appropriate

## SECTION 7: Code Quality and Documentation

| Aspect | Rating (1-5) | Notes/Examples |
|--------|--------------|---------------|
| Code comments quality | | |
| Naming conventions | | |
| Error handling | | |
| Code formatting | | |
| Logging approach | | |
| Consistency with Flutter style guide | | |
| Proper use of trailing commas | | |
| Consistent widget structure | | |
| Proper use of constants | | |
| File naming conventions | | |

## SECTION 8: Flutter Bad Practices Check

| Bad Practice | Present? (Yes/No) | Examples/Location | Impact |
|--------------|-------------------|-------------------|--------|
| Rebuilding expensive widgets unnecessarily | | | |
| Passing callbacks down multiple widget layers | | | |
| Improper dispose() method implementation | | | |
| Blocking the UI thread with heavy operations | | | |
| Misuse of setState() | | | |
| Excessive use of GlobalKey | | | |
| Unoptimized image assets | | | |
| Improper use of FutureBuilder/StreamBuilder | | | |
| Nested SingleChildScrollViews | | | |
| Missing key parameters for dynamic lists | | | |

## SECTION 9: Performance Considerations

| Performance Aspect | Rating (1-5) | Notes/Examples |
|-------------------|--------------|---------------|
| Widget rebuilds optimization | | |
| List view and grid optimization | | |
| Image loading and caching | | |
| Startup time considerations | [USER INPUT REQUIRED] | |
| Animation smoothness | [USER INPUT REQUIRED] | |
| State management efficiency | | |
| Memory usage patterns | [USER INPUT REQUIRED] | |

## SECTION 10: Bonus Features

| Feature | Implemented? | Quality (1-5) | Notes |
|---------|--------------|---------------|-------|
| Null safety | | | |
| Additional patterns | | | |
| Routing/navigation | | | |
| Async/await usage | | | |
| Layout optimization | | | |
| Accessibility | [USER INPUT REQUIRED] | | |
| Theme support | | | |

## SECTION 11: Specific Code Examples

### Strongest Code Examples
1. **Example 1**
```dart
// Paste code snippet here
```
Why it's strong: Explanation here

2. **Example 2**
```dart
// Paste code snippet here
```
Why it's strong: Explanation here

3. **Example 3**
```dart
// Paste code snippet here
```
Why it's strong: Explanation here


### Code That Needs Improvement

1. **Example 1**
```dart
// Paste code snippet here
```
Issue: Explanation here

2. **Example 2**
```dart
// Paste code snippet here
```
Issue: Explanation here

3. **Example 3**
```dart
// Paste code snippet here
```
Issue: Explanation here

## SECTION 12: Overall Assessment

### Key Strengths
1.
2.
3.

### Critical Areas for Improvement
1.
2.
3. 


### Ratings Summary
| Category | Weight | Score (1-10) | Weighted Score |
|----------|--------|--------------|----------------|
| Requirements Compliance | 25% | | |
| Technical Quality | 15% | | |
| Project Structure | 15% | | |
| Flutter Implementation | 20% | | |
| Libraries & Dependencies | 10% | | |
| Code Quality & Documentation | 15% | | |
| Bonus Features | 0-10% | | |
| **TOTAL** | **100%+** | | |


### Executive Summary

- Overall Score: [Final percentage]
- Implementation Quality: [Excellent/Good/Average/Below Average/Poor]
- Completeness: [Summary of requirements fulfillment]
- Code Quality: [Assessment of code quality and maintainability]
- Standout Features: [Highlight of impressive aspects]
- Critical Issues: [List of major problems]
- Production Readiness: [USER INPUT REQUIRED] [1-10 score with explanation]
- Improvement Roadmap:
  - [Priority 1]
  - [Priority 2]
  - [Priority 3]
  - [Priority 4]
  - [Priority 5]


