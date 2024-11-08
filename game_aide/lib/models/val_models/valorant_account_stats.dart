class ValorantAccountStats {
  final String? name;
  final String? tag;
  final int? accountLevel;
  final DateTime lastUpdated;

  ValorantAccountStats({
    required this.name,
    required this.tag,
    required this.accountLevel,
    required this.lastUpdated,
  });

  factory ValorantAccountStats.fromJson(Map<String, dynamic> json) {
    return ValorantAccountStats(
      name: json['name'] as String?,
      tag: json['tag'] as String?,
      accountLevel: json['account_level'] as int?,
      lastUpdated: DateTime.parse(json['updated_at'] as String),
    );
  }
}