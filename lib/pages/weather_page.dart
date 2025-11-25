import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _ctrl = TextEditingController(text: 'São Paulo');
  bool loading = false;
  String? error;
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _fetch(_ctrl.text));
  }

  Future<void> _fetch(String q) async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final res = await WeatherService.fetchWeather(q);
      setState(() => data = res);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  decoration: const InputDecoration(labelText: 'Cidade'),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _fetch(_ctrl.text.trim()),
                child: const Text('Buscar'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (loading) const CircularProgressIndicator(),
          if (error != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(error!, style: const TextStyle(color: Colors.red)),
            ),
          if (data != null && !loading)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      '${data!['city']}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${data!['description']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text('Temperatura: ${data!['temp']}°C'),
                    const SizedBox(height: 4),
                    Text(
                      'Umidade: ${data!['humidity']} • Vento: ${data!['wind']}',
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
