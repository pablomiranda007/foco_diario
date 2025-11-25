import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import '../lib/main.dart'; // mesmo arquivo single-file

void main() {
  test('TaskModel serialization', () {
    final t = TaskModel(
      id: '1',
      title: 'X',
      description: 'Y',
      category: 'pessoal',
      dateTime: DateTime.parse('2024-01-01T10:00:00'),
    );
    final m = t.toMap();
    final json = jsonEncode(m);
    final parsed = TaskModel.fromMap(jsonDecode(json));
    expect(parsed.title, 'X');
    expect(parsed.category, 'pessoal');
  });
}
