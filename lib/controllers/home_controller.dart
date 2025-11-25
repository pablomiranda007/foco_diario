import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/task_model.dart';
import '../models/habit_model.dart';
import '../pages/tasks_page.dart';
import '../pages/habits_page.dart';
import '../pages/progress_page.dart';
import '../pages/weather_page.dart';
import '../utils/format.dart';

class HomeController extends StatefulWidget {
  final StorageService storage;
  const HomeController({Key? key, required this.storage}) : super(key: key);

  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  int _currentIndex = 0;
  late List<TaskModel> tasks;
  late List<HabitModel> habits;
  String dailyNote = '';
  bool darkMode = false;

  @override
  void initState() {
    super.initState();
    tasks = widget.storage.loadTasks();
    habits = widget.storage.loadHabits();
    dailyNote = widget.storage.loadDailyNote() ?? '';
  }

  // Tasks
  Future<void> addTask(TaskModel t) async {
    setState(() => tasks.add(t));
    await widget.storage.saveTasks(tasks);
  }

  Future<void> toggleTask(String id) async {
    final i = tasks.indexWhere((t) => t.id == id);
    if (i == -1) return;
    setState(() => tasks[i].done = !tasks[i].done);
    await widget.storage.saveTasks(tasks);
  }

  Future<void> deleteTask(String id) async {
    setState(() => tasks.removeWhere((t) => t.id == id));
    await widget.storage.saveTasks(tasks);
  }

  // Habits
  Future<void> addHabit(HabitModel h) async {
    setState(() => habits.add(h));
    await widget.storage.saveHabits(habits);
  }

  Future<void> toggleHabitToday(String id) async {
    final h = habits.firstWhere((x) => x.id == id);
    final today = formatYMD(DateTime.now());
    setState(() {
      if (h.completions.contains(today))
        h.completions.remove(today);
      else
        h.completions.add(today);
    });
    await widget.storage.saveHabits(habits);
  }

  Future<void> deleteHabit(String id) async {
    setState(() => habits.removeWhere((h) => h.id == id));
    await widget.storage.saveHabits(habits);
  }

  Future<void> saveDailyNote(String s) async {
    setState(() => dailyNote = s);
    await widget.storage.saveDailyNote(s);
  }

  void _toggleTheme() => setState(() => darkMode = !darkMode);
  void _onNav(int idx) => setState(() => _currentIndex = idx);

  @override
  Widget build(BuildContext context) {
    final pages = [
      TasksPage(
        tasks: tasks,
        onToggle: toggleTask,
        onDelete: deleteTask,
        onAdd: addTask,
      ),
      HabitsPage(
        habits: habits,
        onToggleToday: toggleHabitToday,
        onDelete: deleteHabit,
        onAdd: addHabit,
      ),
      ProgressPage(tasks: tasks, habits: habits),
      const WeatherPage(),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkMode
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Foco Diário'),
          actions: [
            IconButton(
              icon: Icon(darkMode ? Icons.dark_mode : Icons.light_mode),
              onPressed: _toggleTheme,
            ),
          ],
        ),
        body: pages[_currentIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onNav,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.list), label: 'Tarefas'),
            NavigationDestination(icon: Icon(Icons.repeat), label: 'Hábitos'),
            NavigationDestination(
              icon: Icon(Icons.show_chart),
              label: 'Progresso',
            ),
            NavigationDestination(icon: Icon(Icons.cloud), label: 'Clima'),
          ],
        ),
        floatingActionButton: _currentIndex == 0
            ? FloatingActionButton(
                onPressed: () => _dialogAddTask(context),
                child: const Icon(Icons.add),
              )
            : _currentIndex == 1
            ? FloatingActionButton(
                onPressed: () => _dialogAddHabit(context),
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }

  // Dialogs for adding
  Future<void> _dialogAddTask(BuildContext ctx) async {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String category = 'pessoal';
    DateTime? chosenDate;

    await showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Nova tarefa'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: category,
                items: const [
                  DropdownMenuItem(value: 'pessoal', child: Text('Pessoal')),
                  DropdownMenuItem(value: 'trabalho', child: Text('Trabalho')),
                  DropdownMenuItem(value: 'saude', child: Text('Saúde')),
                  DropdownMenuItem(value: 'estudos', child: Text('Estudos')),
                  DropdownMenuItem(value: 'casa', child: Text('Casa')),
                ],
                onChanged: (v) => category = v ?? 'pessoal',
                decoration: const InputDecoration(labelText: 'Categoria'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                child: const Text('Escolher data e hora'),
                onPressed: () async {
                  final d = await showDatePicker(
                    context: ctx,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 365),
                    ),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (d != null) {
                    final t = await showTimePicker(
                      context: ctx,
                      initialTime: TimeOfDay.now(),
                    );
                    if (t != null) {
                      chosenDate = DateTime(
                        d.year,
                        d.month,
                        d.day,
                        t.hour,
                        t.minute,
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final title = titleCtrl.text.trim();
              if (title.isEmpty) return;
              final id = DateTime.now().millisecondsSinceEpoch.toString();
              final task = TaskModel(
                id: id,
                title: title,
                description: descCtrl.text,
                category: category,
                dateTime: chosenDate ?? DateTime.now(),
              );
              addTask(task);
              Navigator.pop(ctx);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _dialogAddHabit(BuildContext ctx) async {
    final titleCtrl = TextEditingController();
    TimeOfDay? chosenTime;
    await showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Novo hábito'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              child: const Text('Escolher hora do dia'),
              onPressed: () async {
                final t = await showTimePicker(
                  context: ctx,
                  initialTime: const TimeOfDay(hour: 8, minute: 0),
                );
                if (t != null) chosenTime = t;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final title = titleCtrl.text.trim();
              if (title.isEmpty) return;
              final id = DateTime.now().millisecondsSinceEpoch.toString();
              final time = chosenTime != null
                  ? '${chosenTime!.hour.toString().padLeft(2, '0')}:${chosenTime!.minute.toString().padLeft(2, '0')}'
                  : '08:00';
              addHabit(HabitModel(id: id, title: title, time: time));
              Navigator.pop(ctx);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
