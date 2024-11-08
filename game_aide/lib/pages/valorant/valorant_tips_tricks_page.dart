import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '/models/val_models/valorant_tips.dart';
import 'package:url_launcher/url_launcher.dart';

class ValorantTipsTricksPage extends StatefulWidget{
  const ValorantTipsTricksPage({Key? key}) : super(key: key);

  @override
  _ValorantTipsTricksPageState createState() => _ValorantTipsTricksPageState();
}

class _ValorantTipsTricksPageState extends State<ValorantTipsTricksPage> {
  late Future<List<Tip>> _futureTips;

  @override
  void initState() {
    super.initState();
    _futureTips = _loadTips();
  }

  Future<List<Tip>> _loadTips() async {
    final String jsonString =
        await rootBundle.loadString('/data/valorant_tips.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.map((json) => Tip.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Valorant Tips and Tricks'),
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