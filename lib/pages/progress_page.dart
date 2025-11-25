import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../models/habit_model.dart';

class ProgressPage extends StatelessWidget {
  final List<TaskModel> tasks;
  final List<HabitModel> habits;
  const ProgressPage({Key? key, required this.tasks, required this.habits})
    : super(key: key);

  double _todayTasksProgress() {
    final today = DateTime.now();
    final key =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final todayTasks = tasks.where((t) {
      final d = DateTime(t.dateTime.year, t.dateTime.month, t.dateTime.day);
      final k =
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      return k == key;
    }).toList();
    if (todayTasks.isEmpty) return 0.0;
    final done = todayTasks.where((t) => t.done).length;
    return done / todayTasks.length;
  }

  double _todayHabitsProgress() {
    if (habits.isEmpty) return 0.0;
    final key =
        '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';
    final done = habits.where((h) => h.completions.contains(key)).length;
    return done / habits.length;
  }

  @override
  Widget build(BuildContext context) {
    final tProg = (_todayTasksProgress() * 100).round();
    final hProg = (_todayHabitsProgress() * 100).round();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Progresso diário',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: _todayTasksProgress(), minHeight: 12),
          const SizedBox(height: 8),
          Text('Tarefas: $tProg%'),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: _todayHabitsProgress(),
            minHeight: 12,
            color: Colors.orange,
          ),
          const SizedBox(height: 8),
          Text('Hábitos: $hProg%'),
        ],
      ),
    );
  }
}
