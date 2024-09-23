import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Aide',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: GameAideHomePage(),
    );
  }
}

class GameAideHomePage extends StatefulWidget {
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
              style: const TextStyle(color: Colors.white),
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
          FeaturePage(featureNumber: 1, game: _selectedGame),
          FeaturePage(featureNumber: 2, game: _selectedGame),
          FeaturePage(featureNumber: 3, game: _selectedGame),
          FeaturePage(featureNumber: 4, game: _selectedGame),
        ],
      ),
    );
  }
}

class FeaturePage extends StatelessWidget {
  final int featureNumber;
  final String game;

  const FeaturePage({required this.featureNumber, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      'Content for Feature $featureNumber of $game',
      style: TextStyle(fontSize: 24),
    ));
  }
}
