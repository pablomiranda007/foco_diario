import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String apiKey = '195909dc';

  static Future<Map<String, dynamic>> fetchWeather(String cityOrQuery) async {
    try {
      final query = Uri.encodeComponent(cityOrQuery);
      final url =
          'https://api.hgbrasil.com/weather?key=$apiKey&city_name=$query';
      final uri = Uri.parse(url);
      final res = await http.get(uri);
      if (res.statusCode != 200) {
        throw Exception('HTTP ${res.statusCode} - ${res.body}');
      }

      final jsonMap = jsonDecode(res.body) as Map<String, dynamic>;

      final map = jsonMap.containsKey('results')
          ? Map<String, dynamic>.from(jsonMap['results'])
          : jsonMap;

      final city =
          (map['city'] ?? map['city_name'] ?? map['name'])?.toString() ??
          cityOrQuery;
      final temp = (map['temp'] != null)
          ? (map['temp'] as num).toDouble()
          : 0.0;
      final description =
          (map['description'] ?? map['condition'] ?? '')?.toString() ?? '';
      final humidity = map['humidity'] ?? map['rh'] ?? 0;
      var wind = map['wind_speedy'] ?? map['wind_speed'] ?? map['wind'] ?? '';
      wind = wind.toString();

      return {
        'city': city,
        'temp': temp,
        'description': description,
        'humidity': humidity,
        'wind': wind,
        'raw': map,
      };
    } catch (e) {
      print(e);
    }
    return {};
  }
}
