import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/overwatch_models/overwatchplayer_stats.dart';

class OverwatchApiService {
  final String _baseUrl = 'https://overfast-api.tekrop.fr';

  Future<OverwatchPlayerSearchResult> fetchPlayerStats(
      String playerName) async {
    final String sanitizedPlayerName = playerName.replaceAll('#', '-');

    final Uri uri = Uri.parse('$_baseUrl/players/$sanitizedPlayerName');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return OverwatchPlayerSearchResult.fromJson(responseData);
    } else {
      throw Exception('Failed to fetch player stats');
    }
  }
}
