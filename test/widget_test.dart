import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../lib/main.dart';

void main() {
  testWidgets('Tasks page shows empty state', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({}); // mock
    await tester.pumpWidget(
      MaterialApp(
        home: TasksPage(
          tasks: [],
          onAdd: (_) async {},
          onToggle: (_) async {},
          onDelete: (_) async {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Nenhuma tarefa. Toque no + para criar.'), findsOneWidget);
  });
}
