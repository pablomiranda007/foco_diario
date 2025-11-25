class TaskModel {
  String id;
  String title;
  String description;
  String category;
  DateTime dateTime;
  bool done;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.dateTime,
    this.done = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'dateTime': dateTime.toIso8601String(),
    'done': done,
  };

  factory TaskModel.fromMap(Map m) => TaskModel(
    id: m['id'],
    title: m['title'],
    description: m['description'] ?? '',
    category: m['category'] ?? 'pessoal',
    dateTime: DateTime.parse(m['dateTime']),
    done: m['done'] ?? false,
  );
}
