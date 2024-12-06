import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:game_aide/main.dart';
import '/models/overwatch_models/overwatch_events.dart';
import 'package:url_launcher/url_launcher.dart';

class OverwatchEventsPage extends StatefulWidget {
  const OverwatchEventsPage({Key? key}) : super(key: key);

  @override
  _OverwatchEventsPageState createState() => _OverwatchEventsPageState();
}

class _OverwatchEventsPageState extends State<OverwatchEventsPage> {
  late Future<List<EventsArticle>> _futureTips;

  @override
  void initState() {
    super.initState();
    _futureTips = _loadTips();
  }

  Future<List<EventsArticle>> _loadTips() async {
    final String jsonString =
        await rootBundle.loadString('/data/overwatch_events.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.map((json) => EventsArticle.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color4,
        title: const Text('Overwatch Events'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'logos/logo-overwatch.png',
            fit: BoxFit.contain,
            height: 32,
          ),
        ),
      ),
      body: FutureBuilder<List<EventsArticle>>(
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

  Widget _buildTipItem(EventsArticle event) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.network(
          event.thumbnailUrl,
          width: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.image_not_supported);
          },
        ),
        title: Text(event.title),
        onTap: () => _launchURL(event.url),
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
