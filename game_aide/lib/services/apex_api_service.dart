import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/apex_playerstats.dart';

class ApexApiService {
  final String _baseUrl =
      'https://api.mozambiquehe.re/bridge?auth=YOUR_API_KEY&player=PLAYER_NAME&platform=PLATFORM';

  Future<ApexPlayerStats> fetchPlayerStats({
    required String playerName,
    required String platform,
  }) async {
    final String apiKey = dotenv.env['APEX_API_KEY'] ?? '';

    final Uri uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'auth': apiKey,
      'player': playerName,
      'platform': platform,
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ApexPlayerStats.fromJson(data);
    } else if (response.statusCode == 400) {
      throw Exception('Bad Request: ${response.reasonPhrase}');
    } else if (response.statusCode == 403) {
      throw Exception('Forbidden: Invalid API Key');
    } else if (response.statusCode == 404) {
      throw Exception('Player Not Found');
    } else {
      throw Exception('Failed to load stats');
    }
  }
}
