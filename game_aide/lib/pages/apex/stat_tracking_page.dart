// ignore: unused_import
import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';
import 'package:game_aide/models/apex_playerstats.dart';
import 'package:game_aide/services/apex_api_service.dart';

class StatTrackingPage extends StatefulWidget {
  const StatTrackingPage({super.key, required String game});

  @override
  _StatTrackingPageState createState() => _StatTrackingPageState();
}

class _StatTrackingPageState extends State<StatTrackingPage> {
  final ApexApiService _apiService = ApexApiService();
  final TextEditingController _playerNameController = TextEditingController();
  String _selectedPlatform = 'PC';
  Future<ApexPlayerStats>? _futurePlayerStats;

  void _fetchStats() {
    if (_playerNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter player name')),
      );
      return;
    }

    setState(() {
      _futurePlayerStats = _apiService.fetchPlayerStats(
        playerName: _playerNameController.text.trim(),
        platform: _selectedPlatform,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Apex Legends Stat Tracking',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _playerNameController,
            decoration: const InputDecoration(
              labelText: 'Enter Player Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _selectedPlatform,
            decoration: const InputDecoration(
              labelText: 'Select Platform',
              border: OutlineInputBorder(),
            ),
            items: ['PC', 'PS', 'XBOX'].map((platform) {
              return DropdownMenuItem(
                value: platform,
                child: Text(platform),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedPlatform = value;
                });
              }
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _fetchStats,
            child: const Text('Fetch Stats'),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _futurePlayerStats == null
                ? const Center(child: Text('Enter player name'))
                : FutureBuilder<ApexPlayerStats>(
                    future: _futurePlayerStats,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        final stats = snapshot.data!;
                        return _buildStatsView(stats);
                      } else {
                        return const Center(child: Text('No Data foound'));
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsView(ApexPlayerStats stats) {
    Legend legend = stats.legends.selected;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Player: ${stats.global.name}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text('UID: ${stats.global.uid}'),
          Text(
              'Level: ${stats.global.level} (${stats.global.toNextLevelPercent}% to next level)'),
          const SizedBox(height: 10),
          const Text(
            'Rank',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Image.asset(
                getRankImageAsset(
                    stats.global.rank.rankName, stats.global.rank.rankDiv),
                width: 50,
                height: 50,
              ),
              const SizedBox(width: 10),
              Text(
                '${stats.global.rank.rankName} Division ${stats.global.rank.rankDiv}',
              ),
            ],
          ),
          Text('Rank Score: ${stats.global.rank.rankScore}'),
          const SizedBox(height: 10),
          Text(
            'Selected Legend: ${stats.legends.selected.legendName}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Image.asset(
            getLegendImageAsset(legend.legendName),
            height: 150,
          ),
          const SizedBox(height: 10),
          const Text(
            'Trackers:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ...?stats.legends.selected.data?.map((tracker) {
            return Text('${tracker.name}: ${tracker.value}');
          }).toList(),
          const SizedBox(height: 10),
          Text(
            'Total Kills: ${stats.total.kills}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

String getRankImageAsset(String rankName, int? rankDiv) {
  // Convert rank name to lowercase and replace spaces with underscores
  String formattedRankName = rankName.toLowerCase().replaceAll(' ', '_');

  // List of ranks with divisions
  List<String> ranksWithDivisions = [
    'rookie',
    'bronze',
    'silver',
    'gold',
    'platinum',
    'diamond',
  ];

  // Ranks with divisions
  if (ranksWithDivisions.contains(formattedRankName)) {
    // Ensure rankDiv is within valid range
    int division =
        (rankDiv != null && rankDiv >= 1 && rankDiv <= 4) ? rankDiv : 4;
    return 'assets/ranks/$formattedRankName$division.png';
  } else if (formattedRankName == 'master' ||
      formattedRankName == 'apex_predator') {
    // Ranks without divisions
    return 'assets/ranks/$formattedRankName.png';
  } else {
    throw Exception('legend not found.');
  }
}

String getLegendImageAsset(String legendName) {
  switch (legendName.toLowerCase()) {
    case 'alter':
      return 'assets/legends/alter.png';
    case 'ash':
      return 'assets/legends/ash.png';
    case 'ballistic':
      return 'assets/legends/ballistic.png';
    case 'bangalore':
      return 'assets/legends/bangalore.png';
    case 'bloodhound':
      return 'assets/legends/bloodhound.png';
    case 'catalyst':
      return 'assets/legends/catalyst.png';
    case 'caustic':
      return 'assets/legends/caustic.png';
    case 'conduit':
      return 'assets/legends/conduit.png';
    case 'crypt':
      return 'assets/legends/crypt.png';
    case 'fuse':
      return 'assets/legends/fuse.png';
    case 'gibraltar':
      return 'assets/legends/gibraltar.png';
    case 'horizon':
      return 'assets/legends/horizon';
    case 'loba':
      return 'assets/legends/loba.png';
    case 'maggie':
      return 'assets/legends/maggie.png';
    case 'mirage':
      return 'assets/legends/mirage.png';
    case 'newcastle':
      return 'assets/legends/newcastle.png';
    case 'octane':
      return 'assets/legends/octane.png';
    case 'pathfinder':
      return 'assets/legends/pathfinder.png';
    case 'rampart':
      return 'assets/legends/rampart.png';
    case 'revenant':
      return 'assets/legends/revenant.png';
    case 'seer':
      return 'assets/legends/seer.png';
    case 'valkyrie':
      return 'assets/legends/valkyrie.png';
    case 'vantage':
      return 'assets/legends/vantage.png';
    case 'wattson':
      return 'assets/legends/wattson.png';
    case 'wraith':
      return 'assets/legends/wraith.png';
    default:
      throw Exception('legend not found.');
  }
}
