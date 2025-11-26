import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../widgets/task_tile.dart';

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
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tarefas',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${sorted.length} tarefas',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: sorted.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.task_alt, size: 64, color: Colors.grey),
                        SizedBox(height: 12),
                        Text('Nenhuma tarefa. Toque no botão + para criar.'),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: sorted.length,
                    itemBuilder: (ctx, i) {
                      final t = sorted[i];
                      return TaskTile(
                        task: t,
                        onToggle: () => onToggle(t.id),
                        onDelete: () => onDelete(t.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
