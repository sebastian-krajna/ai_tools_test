Comprehensive Flutter To-Do App Evaluation Prompt
This evaluation prompt includes a structured template format to ensure consistent evaluation across different AI-generated Flutter applications.
# Flutter To-Do App Evaluation

When evaluating each AI tool, create a separate file named `evaluation_<tool>.md` where `<tool>` is the name of the AI tool being evaluated (e.g., `evaluation_aider.md`, `evaluation_copilot.md`, etc.).

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

## SECTION 1B: Implementation Completeness Check

Evaluate whether the application is fully runnable or requires additional implementation:

| Aspect | Complete? | Notes |
|--------|-----------|-------|
| All required dependencies in pubspec.yaml | | |
| App builds without manual configuration | | |
| All screens/views implemented | | |
| Data models completely defined | | |
| State management fully implemented | | |
| Main functionality works without additional coding | | |
| Error states and edge cases handled | | |

## SECTION 2: Technical Quality Metrics

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

## SECTION 3: Project Structure and Architecture

| Aspect | Rating (1-5) | Notes/Examples |
|--------|--------------|---------------|
| Logical organization | | |
| File grouping strategy | | |
| Separation of concerns | | |
| Provider pattern implementation | | |
| SOLID principles application | | |

**Folder Structure Overview:**
Copy and describe the main folders/files structure here

## SECTION 4: Flutter Implementation Quality

| Aspect | Rating (1-5) | Notes/Examples |
|--------|--------------|---------------|
| **UI Implementation** | | |
| - Material Design 3 compliance | | |
| - Widget composition | | |
| - Widget type appropriateness | | |
| - Animation quality | | |
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

## SECTION 5: Libraries and Dependencies

| Library | Version | Status | Appropriateness |
|---------|---------|--------|----------------|
| | | | |
| | | | |
| | | | |
| | | | |

**Status Legend:** Active/Maintained, Deprecated, Overkill, Appropriate

## SECTION 6: Code Quality and Documentation

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

## SECTION 6B: Flutter Bad Practices Check

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

## SECTION 6C: Performance Considerations

| Performance Aspect | Rating (1-5) | Notes/Examples |
|-------------------|--------------|---------------|
| Widget rebuilds optimization | | |
| List view and grid optimization | | |
| Image loading and caching | | |
| Startup time considerations | | |
| Animation smoothness | | |
| State management efficiency | | |
| Memory usage patterns | | |

## SECTION 7: Bonus Features

| Feature | Implemented? | Quality (1-5) | Notes |
|---------|--------------|---------------|-------|
| Null safety | | | |
| Additional patterns | | | |
| Routing/navigation | | | |
| Async/await usage | | | |
| Layout optimization | | | |
| Accessibility | | | |
| Theme support | | | |

## SECTION 8: Specific Code Examples

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

## SECTION 9: Overall Assessment

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
- Production Readiness: [1-10 score with explanation]
- Improvement Roadmap:
  - [Priority 1]
  - [Priority 2]
  - [Priority 3]
  - [Priority 4]
  - [Priority 5]


