import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/apex_news.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NewsApiService {
  final String _baseUrl = 'https://api.mozambiquehe.re/news';

  Future<List<NewsArticle>> fetchNewsArticle() async {
    final String? apiKey = dotenv.env['APEX_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API Key not loaded');
    }

    final Uri uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'auth': apiKey,
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      return data.map((json) => NewsArticle.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news articles');
    }
  }
}
