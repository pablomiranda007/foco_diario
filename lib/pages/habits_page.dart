import 'package:flutter/material.dart';
import '../models/habit_model.dart';

class HabitsPage extends StatelessWidget {
  final List<HabitModel> habits;
  final Future<void> Function(HabitModel) onAdd;
  final Future<void> Function(String) onToggleToday;
  final Future<void> Function(String) onDelete;

  const HabitsPage({
    Key? key,
    required this.habits,
    required this.onAdd,
    required this.onToggleToday,
    required this.onDelete,
  }) : super(key: key);

  String _todayKey() {
    final d = DateTime.now();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  int _streak(HabitModel h) {
    if (h.completions.isEmpty) return 0;
    final dates = h.completions.map((s) => DateTime.parse(s)).toList()..sort();
    int streak = 0;
    var cur = DateTime.now();
    cur = DateTime(cur.year, cur.month, cur.day);
    for (int i = 0; ; i++) {
      final check = cur.subtract(Duration(days: i));
      final key =
          '${check.year}-${check.month.toString().padLeft(2, '0')}-${check.day.toString().padLeft(2, '0')}';
      if (h.completions.contains(key))
        streak++;
      else
        break;
    }
    return streak;
  }

  @override
  Widget build(BuildContext context) {
    final today = _todayKey();
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Expanded(
            child: habits.isEmpty
                ? const Center(
                    child: Text('Nenhum hábito. Toque no + para criar.'),
                  )
                : ListView.builder(
                    itemCount: habits.length,
                    itemBuilder: (ctx, i) {
                      final h = habits[i];
                      final done = h.completions.contains(today);
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(h.title.characters.first.toUpperCase()),
                          ),
                          title: Text(
                            h.title,
                            style: TextStyle(
                              decoration: done
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Text(
                            '${h.time} • Sequência: ${_streak(h)}d',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => onDelete(h.id),
                              ),
                              IconButton(
                                icon: Icon(
                                  done
                                      ? Icons.check_circle
                                      : Icons.check_circle_outline,
                                  color: done ? Colors.green : null,
                                ),
                                onPressed: () => onToggleToday(h.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
