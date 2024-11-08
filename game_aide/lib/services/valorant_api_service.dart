import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/models/val_models/valorant_account_stats.dart';
import '/models/val_models/valorant_ranked_stats.dart';

class ValorantApiService {
    final String _apiKey = dotenv.env['VAL_API_KEY']?? '';
    final String region = 'na';

    Future<Map<String, dynamic>> fetchCombinedStats({
        required String name,
        required String tag,
    }) async{
        try{
        final accountStats = await getAccountStats(name, tag);
        final rankedStats = await getRankedStats(name, tag, region);

        return {
            'accountStats' : accountStats,
            'rankedStats' : rankedStats,
        };
        } catch(e){
            print('Error Fetching Stats: $e');
            rethrow;
        }
    }

    Future<ValorantAccountStats?> getAccountStats(String name, String tag) async {
        final String url = 'https://api.henrikdev.xyz/valorant/v2/account/$name/$tag?api_key=$_apiKey';

            final response = await http.get(Uri.parse(url));

            if(response.statusCode == 200){
                final responseJson = json.decode(response.body);
                final data = responseJson['data'] as Map<String, dynamic>;
                return ValorantAccountStats.fromJson(data);
            } else {
                throw Exception('Error: ${response.statusCode} - ${response.reasonPhrase}');
        }
}

        Future<ValorantRankedStats?> getRankedStats(String name, String tag, String region) async {
            final String url = 'https://api.henrikdev.xyz/valorant/v2/mmr/$region/$name/$tag?api_key=$_apiKey';

                final response = await http.get(Uri.parse(url));

                if(response.statusCode == 200){
                final responseJson = json.decode(response.body) as Map<String, dynamic>;
                final data = responseJson['data'] as Map<String, dynamic>;
                    return ValorantRankedStats.fromJson(data);
                } else {
                    throw Exception('Error: ${response.statusCode} - ${response.reasonPhrase}');
            }
        }
}