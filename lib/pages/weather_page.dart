import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherState();
}

class _WeatherState extends State<WeatherPage> {
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
    final city = data?['city'] ?? '--';
    final temp = data?['temp'] != null ? '${data!['temp']}°C' : '--';
    final desc = data?['description'] ?? '';

    return Padding(
      padding: const EdgeInsets.all(16),
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
          if (loading) const Center(child: CircularProgressIndicator()),
          if (error != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(error!, style: const TextStyle(color: Colors.red)),
            ),
          if (data != null && !loading)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // left column: temp and icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.indigo.shade50,
                            Colors.indigo.shade100,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.wb_sunny,
                            size: 36,
                            color: Colors.orange.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            temp,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // right column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            city,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(desc, style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 8),
                          Text(
                            'Umidade: ${data!['humidity']} • Vento: ${data!['wind']}',
                          ),
                        ],
                      ),
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
