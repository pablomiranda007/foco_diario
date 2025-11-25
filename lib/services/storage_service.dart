import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';
import '../models/habit_model.dart';

class StorageService {
  final SharedPreferences prefs;
  StorageService(this.prefs);

  static const _tasksKey = 'foco_tasks_v1';
  static const _habitsKey = 'foco_habits_v1';
  static const _dailyNoteKey = 'foco_daily_v1';

  List<TaskModel> loadTasks() {
    final raw = prefs.getString(_tasksKey);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List;
    return decoded
        .map((e) => TaskModel.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> saveTasks(List<TaskModel> tasks) async {
    final encoded = jsonEncode(tasks.map((t) => t.toMap()).toList());
    await prefs.setString(_tasksKey, encoded);
  }

  List<HabitModel> loadHabits() {
    final raw = prefs.getString(_habitsKey);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List;
    return decoded
        .map((e) => HabitModel.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> saveHabits(List<HabitModel> habits) async {
    final encoded = jsonEncode(habits.map((h) => h.toMap()).toList());
    await prefs.setString(_habitsKey, encoded);
  }

  String? loadDailyNote() => prefs.getString(_dailyNoteKey);
  Future<void> saveDailyNote(String note) =>
      prefs.setString(_dailyNoteKey, note);
}
