import 'package:flutter/material.dart';

class EventsPage extends StatefulWidget {
  final String game;

  const EventsPage({required this.game});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Events for ${widget.game}',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
