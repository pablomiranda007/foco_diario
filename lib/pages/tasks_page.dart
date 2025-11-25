import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TasksPage extends StatelessWidget {
  final List<TaskModel> tasks;
  final Future<void> Function(TaskModel) onAdd;
  final Future<void> Function(String) onToggle;
  final Future<void> Function(String) onDelete;

  const TasksPage({
    Key? key,
    required this.tasks,
    required this.onAdd,
    required this.onToggle,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sorted = [...tasks]..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Expanded(
            child: sorted.isEmpty
                ? const Center(
                    child: Text('Nenhuma tarefa. Toque no + para criar.'),
                  )
                : ListView.builder(
                    itemCount: sorted.length,
                    itemBuilder: (ctx, i) {
                      final t = sorted[i];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(t.title.characters.first.toUpperCase()),
                          ),
                          title: Text(
                            t.title,
                            style: TextStyle(
                              decoration: t.done
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Text(
                            '${t.category} • ${t.dateTime.toLocal()}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => onDelete(t.id),
                              ),
                              Checkbox(
                                value: t.done,
                                onChanged: (_) => onToggle(t.id),
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
