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

  // Palette (you can tweak these)
  static const Color seed = Color(0xFF4457FF);
  static final ColorScheme lightScheme = ColorScheme.fromSeed(seedColor: seed);
  static final ColorScheme darkScheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.dark,
  );

  @override
  Widget build(BuildContext context) {
    final storage = StorageService(sharedPrefs);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Foco Diário',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightScheme,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
          ),
        ),
      ),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkScheme),
      home: HomeController(storage: storage),
    );
  }
}
