class OverwatchPlayerSearchResult {
  final Summary summary;
  final Stats stats;

  OverwatchPlayerSearchResult({
    required this.summary,
    required this.stats,
  });

  factory OverwatchPlayerSearchResult.fromJson(Map<String, dynamic> json) {
    return OverwatchPlayerSearchResult(
      summary: Summary.fromJson(json['summary'] ?? {}),
      stats: Stats.fromJson(json['stats'] ?? {}),
    );
  }
}

class Summary {
  final String username;
  final String rankDivision;
  final int rankTier;
  final String rankIconUrl;

  Summary({
    required this.username,
    required this.rankDivision,
    required this.rankTier,
    required this.rankIconUrl,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    String username = json['username'] ?? '';
    String rankDivision = 'Unranked';
    int rankTier = 0;
    String rankIconUrl = '';

    // Parse competitive rank details
    final competitive = json['competitive'] ?? {};
    final pcCompetitive = competitive['pc'] ?? {};
    final openQueue = pcCompetitive['open'] ?? {};

    rankDivision = openQueue['division'] ?? 'Unranked';
    rankTier = openQueue['tier'] ?? 0;
    rankIconUrl = openQueue['rank_icon'] ?? '';

    return Summary(
      username: username,
      rankDivision: rankDivision,
      rankTier: rankTier,
      rankIconUrl: rankIconUrl,
    );
  }
}

class Stats {
  final int eliminations;
  final int deaths;
  final int gamesWon;
  final int gamesLost;

  Stats({
    required this.eliminations,
    required this.deaths,
    required this.gamesWon,
    required this.gamesLost,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    int eliminations = 0;
    int deaths = 0;
    int gamesWon = 0;
    int gamesLost = 0;

    final pcStats = json['pc'] ?? {};
    final competitiveStats = pcStats['competitive'] ?? {};
    final careerStats = competitiveStats['career_stats'] ?? {};
    final allHeroes = careerStats['all-heroes'] as List<dynamic>? ?? [];

    for (var category in allHeroes) {
      final categoryMap = category as Map<String, dynamic>;
      final statsList = categoryMap['stats'] as List<dynamic>? ?? [];

      for (var statItem in statsList) {
        final statMap = statItem as Map<String, dynamic>;
        final key = statMap['key'] ?? '';
        final value = statMap['value'] ?? 0;

        switch (key) {
          case 'eliminations':
            eliminations = value;
            break;
          case 'deaths':
            deaths = value;
            break;
          case 'games_won':
            gamesWon = value;
            break;
          case 'games_lost':
            gamesLost = value;
            break;
          default:
            break;
        }
      }
    }

    return Stats(
      eliminations: eliminations,
      deaths: deaths,
      gamesWon: gamesWon,
      gamesLost: gamesLost,
    );
  }
}
