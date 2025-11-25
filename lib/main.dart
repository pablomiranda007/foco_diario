import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/home_controller.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(FocoDiarioApp(sharedPrefs: prefs));
}

class FocoDiarioApp extends StatelessWidget {
  final SharedPreferences sharedPrefs;
  const FocoDiarioApp({Key? key, required this.sharedPrefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storage = StorageService(sharedPrefs);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Foco Diário',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: HomeController(storage: storage),
    );
  }
}
