class ApexPlayerStats {
  final GlobalStats global;
  final Legends legends;
  final TotalStats total;

  ApexPlayerStats({
    required this.global,
    required this.legends,
    required this.total,
  });

  factory ApexPlayerStats.fromJson(Map<String, dynamic> json) {
    return ApexPlayerStats(
      global: GlobalStats.fromJson(json['global']),
      legends: Legends.fromJson(json['legends']),
      total: TotalStats.fromJson(json['total']),
    );
  }
}

class GlobalStats {
  final String name;
  final String uid;
  final int level;
  final int toNextLevelPercent;
  final Rank rank;

  GlobalStats({
    required this.name,
    required this.uid,
    required this.level,
    required this.toNextLevelPercent,
    required this.rank,
  });

  factory GlobalStats.fromJson(Map<String, dynamic> json) {
    return GlobalStats(
      name: json['name'],
      uid: json['uid'],
      level: json['level'],
      toNextLevelPercent: json['toNextLevelPercent'],
      rank: Rank.fromJson(json['rank']),
    );
  }
}

class Rank {
  final int rankScore;
  final String rankName;
  final int rankDiv;
  final String rankImg;

  Rank({
    required this.rankScore,
    required this.rankName,
    required this.rankDiv,
    required this.rankImg,
  });

  factory Rank.fromJson(Map<String, dynamic> json) {
    return Rank(
      rankScore: json['rankScore'],
      rankName: json['rankName'],
      rankDiv: json['rankDiv'],
      rankImg: json['rankImg'],
    );
  }
}

class Legends {
  final Legend selected;
  final Map<String, Legend> all;

  Legends({
    required this.selected,
    required this.all,
  });

  factory Legends.fromJson(Map<String, dynamic> json) {
    // Parse 'selected' legend
    Legend selectedLegend = Legend.fromJson(json['selected']);

    // Parse 'all' legends
    Map<String, Legend> allLegends = {};
    json['all'].forEach((key, value) {
      if (key != 'selected' && value is Map<String, dynamic>) {
        allLegends[key] = Legend.fromJson(value);
      }
    });

    return Legends(
      selected: selectedLegend,
      all: allLegends,
    );
  }
}

class Legend {
  final String legendName;
  final List<Tracker>? data;
  final ImgAssets imgAssets;

  Legend({
    required this.legendName,
    required this.data,
    required this.imgAssets,
  });

  factory Legend.fromJson(Map<String, dynamic> json) {
    List<Tracker>? trackers;
    if (json['data'] != null && json['data'] is List) {
      trackers =
          (json['data'] as List).map((item) => Tracker.fromJson(item)).toList();
    }

    return Legend(
      legendName: json['LegendName'] ?? '',
      data: trackers,
      imgAssets: ImgAssets.fromJson(json['ImgAssets']),
    );
  }
}

class Tracker {
  final String name;
  final dynamic value;
  final String key;
  final bool? global;

  Tracker({
    required this.name,
    required this.value,
    required this.key,
    this.global,
  });

  factory Tracker.fromJson(Map<String, dynamic> json) {
    return Tracker(
      name: json['name'],
      value: json['value'],
      key: json['key'],
      global: json['global'],
    );
  }
}

class ImgAssets {
  final String icon;
  final String banner;

  ImgAssets({
    required this.icon,
    required this.banner,
  });

  factory ImgAssets.fromJson(Map<String, dynamic> json) {
    return ImgAssets(
      icon: json['icon'],
      banner: json['banner'],
    );
  }
}

class TotalStats {
  final int kills;

  TotalStats({required this.kills});

  factory TotalStats.fromJson(Map<String, dynamic> json) {
    return TotalStats(
      kills: json['kills']['value'],
    );
  }
}
