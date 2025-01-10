class Task {
  String title;
  DateTime date;
  bool isDone;

  Task({required this.title, required this.date, this.isDone = false});

  factory Task.fromMap(Map task) {
    return Task(
        title: task['title'],
        date: task['date'] is String
            ? DateTime.parse(task['date'])
            : task['date'],
        isDone: task['isDone']);
  }

  Map toMap() {
    return {'title': title, 'date': date.toIso8601String(), 'isDone': isDone};
  }
}
