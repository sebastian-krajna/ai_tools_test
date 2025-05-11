class Task {
  String id;
  String title;
  String description;
  DateTime? dueDate;
  bool isCompleted;
  TaskPriority priority;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.dueDate,
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
  });

  // Add toJson and fromJson methods for persistence
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
      'priority': priority.index,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: json['dueDate'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['dueDate']) 
          : null,
      isCompleted: json['isCompleted'],
      priority: TaskPriority.values[json['priority']],
    );
  }

  // Create a copy with method for immutability
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    TaskPriority? priority,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
    );
  }
}

enum TaskPriority { low, medium, high }
