import 'package:flutter/material.dart';
import 'apex/apex_find_friends_page.dart';
import 'apex/apex_tips_tricks_page.dart';
import 'apex/apex_events_page.dart';
import 'apex/apex_stat_tracking_page.dart';
import 'valorant/valorant_stats_page.dart';
import 'valorant/valorant_events_page.dart';
import 'valorant/valorant_tips_tricks_page.dart';
import 'valorant/valorant_friends_page.dart';

class GameAideHomePage extends StatefulWidget {
  const GameAideHomePage({Key? key}) : super(key: key);

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

  Widget _buildFindFriendsPage(){
    switch (_selectedGame){
      case 'Apex Legends':
      return const ApexFindFriendsPage();
      case 'Valorant':
      return const ValorantFriendsPage();
      default:
      return const Center(child: Text('Game not found'));
    }
  }
  Widget _buildTipsTricksPage(){
    switch (_selectedGame){
      case 'Apex Legends':
      return const ApexTipsTricksPage();
      case 'Valorant':
      return const ValorantTipsTricksPage();
      default:
      return const Center(child: Text('Game not found'));
    }
  }

    Widget _buildEventsPage(){
    switch (_selectedGame){
      case 'Apex Legends':
      return const ApexNewsPage();
      case 'Valorant':
      return const ValorantEventsPage();
      default:
      return const Center(child: Text('Game not found'));
    }
  }

  Widget _buildStatTrackingPage(){
    switch(_selectedGame){
      case 'Apex Legends':
      return const ApexStatTrackingPage();
      case 'Valorant':
      return const ValStatTrackingPage();
      default:
      return const Center(child: Text('Game not found'));
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
          _buildFindFriendsPage(),
          _buildTipsTricksPage(),
          _buildEventsPage(),
          _buildStatTrackingPage(),
        ],
      ),
    );
  }
}
