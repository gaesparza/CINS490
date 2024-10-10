import 'package:flutter/material.dart';

class FindFriendsPage extends StatefulWidget {
  final String game;

  const FindFriendsPage({required this.game});

  @override
  _FindFriendsPageState createState() => _FindFriendsPageState();
}

class _FindFriendsPageState extends State<FindFriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Find Friends for ${widget.game}',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
