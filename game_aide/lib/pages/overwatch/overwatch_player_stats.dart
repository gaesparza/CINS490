import 'package:flutter/material.dart';
import '/services/overwatch_api_service.dart';
import '/models/overwatch_models/overwatchplayer_stats.dart';

class OverwatchStatsPage extends StatefulWidget {
  const OverwatchStatsPage({Key? key}) : super(key: key);

  @override
  _OverwatchStatsPageState createState() => _OverwatchStatsPageState();
}

class _OverwatchStatsPageState extends State<OverwatchStatsPage> {
  final OverwatchApiService _apiService = OverwatchApiService();
  final TextEditingController _playerNameController = TextEditingController();

  OverwatchPlayerSearchResult? _selectedPlayer;
  bool _isLoading = false;

  void searchPlayers() async {
    final playerName = _playerNameController.text.trim();
    if (playerName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Search player name')),
      );
      return;
    }

    setState(() {
      _selectedPlayer = null;
      _isLoading = true;
    });

    try {
      OverwatchPlayerSearchResult playerStats =
          await _apiService.fetchPlayerStats(playerName);

      setState(() {
        _selectedPlayer = playerStats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget _buildPlayerStats(OverwatchPlayerSearchResult player) {
    final summary = player.summary;
    final stats = player.stats;

    final double kdRatio = stats.deaths != 0
        ? stats.eliminations / stats.deaths
        : stats.eliminations.toDouble();
    final int totalMatches = stats.gamesWon + stats.gamesLost;
    final double winRate =
        totalMatches > 0 ? (stats.gamesWon / totalMatches) * 100 : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Player: ${summary.username}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              summary.rankIconUrl.isNotEmpty
                  ? Image.network(
                      summary.rankIconUrl,
                      height: 50,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image_not_supported);
                      },
                    )
                  : const Icon(Icons.image_not_supported, size: 50),
              const SizedBox(width: 10),
              Text(
                'Rank: ${_capitalize(summary.rankDivision)} ${summary.rankTier > 0 ? summary.rankTier.toString() : ''}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'K-D: ${stats.eliminations}-${stats.deaths} (Ratio: ${kdRatio.toStringAsFixed(2)})',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          Text(
            'W-L: ${stats.gamesWon}-${stats.gamesLost} (Win Rate: ${winRate.toStringAsFixed(2)}%)',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedPlayer = null;
                _playerNameController.clear();
              });
            },
            child: const Text('Search Again'),
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}' : s;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedPlayer != null
            ? '${_selectedPlayer!.summary.username} Stats'
            : 'Overwatch Stats'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'logos/logo-overwatch.png',
            fit: BoxFit.contain,
            height: 32,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_selectedPlayer == null) ...[
              TextField(
                controller: _playerNameController,
                decoration: const InputDecoration(
                  labelText: 'Enter Player Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: searchPlayers,
                child: const Text('Search'),
              ),
            ],
            const SizedBox(height: 10),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _selectedPlayer == null
                      ? const Center(child: Text('Enter a player name'))
                      : _buildPlayerStats(_selectedPlayer!),
            ),
          ],
        ),
      ),
    );
  }
}
