import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:game_aide/main.dart';
import '/models/overwatch_models/overwatch_tips.dart';
import 'package:url_launcher/url_launcher.dart';

class OWTipsTricksPage extends StatefulWidget {
  const OWTipsTricksPage({Key? key}) : super(key: key);

  @override
  _OWTipsTricksPageState createState() => _OWTipsTricksPageState();
}

class _OWTipsTricksPageState extends State<OWTipsTricksPage> {
  late Future<List<Tip>> _futureTips;

  @override
  void initState() {
    super.initState();
    _futureTips = _loadTips();
  }

  Future<List<Tip>> _loadTips() async {
    final String jsonString =
        await rootBundle.loadString('data/overwatch_tips.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.map((json) => Tip.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color4,
        title: const Text('Tips and Tricks'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'logos/logo-overwatch.png',
            fit: BoxFit.contain,
            height: 32,
          ),
        ),
      ),
      body: FutureBuilder<List<Tip>>(
        future: _futureTips,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final tip = snapshot.data![index];
                return _buildTipItem(tip);
              },
            );
          } else {
            return const Center(child: Text('No tips available'));
          }
        },
      ),
    );
  }

  Widget _buildTipItem(Tip tip) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: tip.thumbnailUrl != null
            ? Image.network(
                tip.thumbnailUrl!,
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported);
                },
              )
            : const Icon(Icons.lightbulb),
        title: Text(tip.title),
        onTap: () => _launchURL(tip.url),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch the URL.')),
      );
    }
  }
}
