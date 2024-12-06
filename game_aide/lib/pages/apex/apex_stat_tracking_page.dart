import 'package:flutter/material.dart';
import 'package:game_aide/main.dart';
import 'package:game_aide/models/apex_models/apex_playerstats.dart';
import 'package:game_aide/services/apex_api_service.dart';

class ApexStatTrackingPage extends StatefulWidget {
  const ApexStatTrackingPage({Key? key}) : super(key: key);

  @override
  _ApexStatTrackingPageState createState() => _ApexStatTrackingPageState();
}

class _ApexStatTrackingPageState extends State<ApexStatTrackingPage> {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color4,
        title: const Text('Apex Legends Stat Tracking'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'logos/logo-Apex-Legends.png',
            fit: BoxFit.contain,
            height: 32,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: _playerNameController,
              decoration: InputDecoration(
                labelText: 'Enter Player Name',
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedPlatform,
              decoration: InputDecoration(
                labelText: 'Select Platform',
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
            const SizedBox(height: 15),
            Expanded(
              child: _futurePlayerStats == null
                  ? const Center(child: Text('Enter player name'))
                  : FutureBuilder<ApexPlayerStats>(
                      future: _futurePlayerStats,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
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
      ),
    );
  }

  Widget _buildStatsView(ApexPlayerStats stats) {
    Legend legend = stats.legends.selected;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 650,
        height: 450,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Player: ${stats.global.name}',
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Text(
                  'Level: ${stats.global.level} (${stats.global.toNextLevelPercent}% to next level)'),
              const SizedBox(height: 10),
              Text(
                  'Rank: ${stats.global.rank.rankName} Division ${stats.global.rank.rankDiv}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Image.asset(
                getRankImageAsset(
                    stats.global.rank.rankName, stats.global.rank.rankDiv),
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 10),
              Text('Rank Score: ${stats.global.rank.rankScore} RP'),
              const SizedBox(height: 10),
              Text(
                'Selected Legend: ${stats.legends.selected.legendName}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Image.asset(getLegendImageAsset(legend.legendName), height: 100),
              const SizedBox(height: 10),
              Text('Total Kills: ${stats.total.kills}',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
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

//switch to match legend name to local asset
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
    case 'lifeline':
      return 'assets/legends/lifeline.png';
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
      return 'No legend Data found';
  }
}
