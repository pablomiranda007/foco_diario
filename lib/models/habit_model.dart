class HabitModel {
  String id;
  String title;
  String time; // HH:mm
  List<String> completions; // days: yyyy-MM-dd

  HabitModel({
    required this.id,
    required this.title,
    required this.time,
    List<String>? completions,
  }) : completions = completions ?? [];

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'time': time,
    'completions': completions,
  };

  factory HabitModel.fromMap(Map m) => HabitModel(
    id: m['id'],
    title: m['title'],
    time: m['time'] ?? '08:00',
    completions: List<String>.from(m['completions'] ?? []),
  );
}
