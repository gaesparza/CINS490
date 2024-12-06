import 'package:flutter/material.dart';
import 'package:game_aide/main.dart';
import 'package:game_aide/services/valorant_api_service.dart';
import '/models/val_models/valorant_account_stats.dart';
import '/models/val_models/valorant_ranked_stats.dart';
import 'package:intl/intl.dart';

class ValStatTrackingPage extends StatefulWidget {
  const ValStatTrackingPage({Key? key}) : super(key: key);

  @override
  _ValStatTrackingPageState createState() => _ValStatTrackingPageState();
}

class _ValStatTrackingPageState extends State<ValStatTrackingPage> {
  final ValorantApiService _apiService = ValorantApiService();
  final TextEditingController _playerNameController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  Future<Map<String, dynamic>>? _futureStats;

  void _fetchStats() {
    if (_playerNameController.text.isEmpty || _tagController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter player name and tag')),
      );
      return;
    }
    setState(() {
      _futureStats = _apiService.fetchCombinedStats(
        name: _playerNameController.text.trim(),
        tag: _tagController.text.trim(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color4,
        title: const Text('Valorant Stat Tracking'),
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: Image.asset(
            'logos/logo-valorant.png',
            fit: BoxFit.contain,
            height: 60,
            width: 60,
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
              decoration: const InputDecoration(
                labelText: 'Enter Player Name',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _tagController,
              decoration: const InputDecoration(labelText: 'Enter Player Tag'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetchStats,
              child: const Text('Fetch Stats'),
            ),
            const SizedBox(height: 20),
            _futureStats == null
                ? const Center(child: Text('Enter player name and tag'))
                : FutureBuilder<Map<String, dynamic>>(
                    future: _futureStats,
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
                        final accountStats = snapshot.data!['accountStats']
                            as ValorantAccountStats;
                        final rankedStats = snapshot.data!['rankedStats']
                            as ValorantRankedStats;
                        return _buildStatsView(accountStats, rankedStats);
                      } else {
                        return const Center(child: Text('No Stats Found'));
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsView(
      ValorantAccountStats accountStats, ValorantRankedStats rankedStats) {
    final formattedDate =
        DateFormat('yyyy-MM-dd HH:mm').format(accountStats.lastUpdated);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        width: 650,
        height: 450,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Player: ${accountStats.name}#${accountStats.tag}',
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Text('Account Level: ${accountStats.accountLevel}'),
              Text('Last Updated: $formattedDate'),
              const SizedBox(height: 10),
              const Text(
                'Ranked Stats',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('Ranked: ${rankedStats.currentTierPatched ?? 'Unranked'}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Elo: ${rankedStats.elo ?? 'N/A'}'),
            ],
          ),
        ),
      ),
    );
  }
}
