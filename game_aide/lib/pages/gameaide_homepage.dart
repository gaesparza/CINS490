import 'package:flutter/material.dart';
import 'apex/find_friends_page.dart';
import 'apex/tips_tricks_page.dart';
import 'apex/events_page.dart';
import 'apex/stat_tracking_page.dart';

class GameAideHomePage extends StatefulWidget {
  const GameAideHomePage({super.key});

  @override
  _GameAideHomePageState createState() => _GameAideHomePageState();
}

class _GameAideHomePageState extends State<GameAideHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedGame = 'Apex Legends';
  final List<String> _games = ['Apex Legends', 'Destiny 2', 'Valorant'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onGameChanged(String? newGame) {
    if (newGame != null) {
      setState(() {
        _selectedGame = newGame;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Aide'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<String>(
              value: _selectedGame,
              onChanged: _onGameChanged,
              dropdownColor: Colors.blue,
              underline: const SizedBox(),
              style: const TextStyle(color: Color.fromARGB(255, 129, 57, 57)),
              items: _games.map<DropdownMenuItem<String>>((String game) {
                return DropdownMenuItem<String>(
                  value: game,
                  child: Text(game),
                );
              }).toList(),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Find a friend'),
            Tab(text: 'Tips and Tricks'),
            Tab(text: 'Events'),
            Tab(text: 'Stat Tracking'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FindFriendsPage(game: _selectedGame),
          TipsTricksPage(game: _selectedGame),
          EventsPage(game: _selectedGame),
          StatTrackingPage(game: _selectedGame)
        ],
      ),
    );
  }
}
