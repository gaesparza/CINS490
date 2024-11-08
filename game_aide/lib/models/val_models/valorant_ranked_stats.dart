class ValorantRankedStats {
  final String? currentTierPatched;
  final int? elo;


  ValorantRankedStats({
    required this.currentTierPatched,
    required this.elo,
  });

  factory ValorantRankedStats.fromJson(Map<String, dynamic> json) {
    return ValorantRankedStats(
      currentTierPatched: json['currenttier_patched'] as String?,
      elo: json['elo'] as int?,
    );
  }
}