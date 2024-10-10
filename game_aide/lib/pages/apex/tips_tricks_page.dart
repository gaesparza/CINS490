import 'package:flutter/material.dart';

class TipsTricksPage extends StatefulWidget {
  final String game;

  const TipsTricksPage({required this.game});

  @override
  _TipsTricksPageState createState() => _TipsTricksPageState();
}

class _TipsTricksPageState extends State<TipsTricksPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Tips and Tricks for ${widget.game}',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
