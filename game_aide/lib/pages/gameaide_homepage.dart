import 'package:flutter/material.dart';
import 'package:game_aide/main.dart';
import 'package:game_aide/pages/overwatch/overwatch_friends_page.dart';
import 'package:game_aide/pages/overwatch/overwatch_tips_page.dart';
import 'apex/apex_find_friends_page.dart';
import 'apex/apex_tips_tricks_page.dart';
import 'apex/apex_events_page.dart';
import 'apex/apex_stat_tracking_page.dart';
import 'valorant/valorant_stats_page.dart';
import 'valorant/valorant_events_page.dart';
import 'valorant/valorant_tips_tricks_page.dart';
import 'valorant/valorant_friends_page.dart';
import 'overwatch/overwatch_player_stats.dart';
import 'overwatch/overwatch_events_page.dart';

class GameAideHomePage extends StatefulWidget {
  const GameAideHomePage({Key? key}) : super(key: key);

  @override
  _GameAideHomePageState createState() => _GameAideHomePageState();
}

class _GameAideHomePageState extends State<GameAideHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedGame = 'Apex Legends';
  final List<String> _games = ['Apex Legends', 'Overwatch', 'Valorant'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
    );
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

  Widget _buildFindFriendsPage() {
    switch (_selectedGame) {
      case 'Apex Legends':
        return const ApexFindFriendsPage();
      case 'Valorant':
        return const ValorantFriendsPage();
      case 'Overwatch':
        return const OWFriendsPage();
      default:
        return const Center(child: Text('Game not found'));
    }
  }

  Widget _buildTipsTricksPage() {
    switch (_selectedGame) {
      case 'Apex Legends':
        return const ApexTipsTricksPage();
      case 'Valorant':
        return const ValorantTipsTricksPage();
      case 'Overwatch':
        return const OWTipsTricksPage();
      default:
        return const Center(child: Text('Game not found'));
    }
  }

  Widget _buildEventsPage() {
    switch (_selectedGame) {
      case 'Apex Legends':
        return const ApexNewsPage();
      case 'Valorant':
        return const ValorantEventsPage();
      case 'Overwatch':
        return const OverwatchEventsPage();
      default:
        return const Center(child: Text('Game not found'));
    }
  }

  Widget _buildStatTrackingPage() {
    switch (_selectedGame) {
      case 'Apex Legends':
        return const ApexStatTrackingPage();
      case 'Valorant':
        return const ValStatTrackingPage();
      case 'Overwatch':
        return const OverwatchStatsPage();
      default:
        return const Center(child: Text('Game not found'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color3,
        title: const Text('Game Aide'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<String>(
              value: _selectedGame,
              onChanged: _onGameChanged,
              dropdownColor: Theme.of(context).primaryColor,
              underline: const SizedBox(),
              style: const TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.bold),
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
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
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
          _buildFindFriendsPage(),
          _buildTipsTricksPage(),
          _buildEventsPage(),
          _buildStatTrackingPage(),
        ],
      ),
    );
  }
}
