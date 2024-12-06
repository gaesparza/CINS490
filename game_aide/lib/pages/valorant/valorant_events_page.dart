import 'package:flutter/material.dart';
import 'package:game_aide/main.dart';
import 'package:url_launcher/url_launcher.dart';
import '/services/valorant_event_api.dart';
import '../../models/val_models/valorant_events.dart';

class ValorantEventsPage extends StatefulWidget {
  const ValorantEventsPage({Key? key}) : super(key: key);

  @override
  _ValorantEventPageState createState() => _ValorantEventPageState();
}

class _ValorantEventPageState extends State<ValorantEventsPage> {
  final ValorantEventApiService _eventApiService = ValorantEventApiService();
  late Future<List<ValorantEvent>> _futureEvents;

  @override
  void initState() {
    super.initState();
    _futureEvents = _eventApiService.fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color4,
        title: const Text('Valorant Events'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'logos/logo-valorant.png',
            fit: BoxFit.contain,
            height: 60,
            width: 60,
          ),
        ),
      ),
      body: FutureBuilder<List<ValorantEvent>>(
        future: _futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData) {
            return _buildEventList(snapshot.data!);
          } else {
            return const Center(
              child: Text('No events available'),
            );
          }
        },
      ),
    );
  }

  Widget _buildEventList(List<ValorantEvent> events) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return _buildEventItem(events[index]);
      },
    );
  }

  Widget _buildEventItem(ValorantEvent event) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.network(
          event.bannerUrl,
          width: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.image_not_supported);
          },
        ),
        title: Text(event.title),
        subtitle: Text(
            'Category: ${event.category}\nData: ${event.date.toLocal().toString().split(' ')[0]}'),
        onTap: () => _launchURL(event.url),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch the event URL')),
      );
    }
  }
}
