import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/val_models/valorant_events.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ValorantEventApiService{
  final String _baseUrl = 'https://api.henrikdev.xyz/valorant/v1/website/en-us';

  Future<List<ValorantEvent>> fetchEvents() async{
    final String? apiKey = dotenv.env['VAL_API_KEY'];

    if(apiKey == null || apiKey.isEmpty){
      throw Exception('API Key not loaded');
    }

    final Uri uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'api_key' : apiKey,
    });

    final response = await http.get(uri);

    if(response.statusCode == 200){
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'];

      return data.map((json) => ValorantEvent.fromJson(json)).toList();
    }else{
      throw Exception('Failed to load events');
    }
  }
}