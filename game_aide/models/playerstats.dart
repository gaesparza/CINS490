class PlayerStats {
  final String name;
  final String uid;
  final int level;
  final int toNextLevelPercent;
  final Rank rank;
  final Legend selectedLegend;

  PlayerStats({
    required this.name,
    required this.uid,
    required this.level,
    required this.toNextLevelPercent,
    required this.rank,
    required this.selectedLegend,
  });

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      name: json['global']['name'],
      uid: json['global']['uid'],
      level: json['global']['level'],
      toNextLevelPercent: json['global']['toNextLevelPercent'],
      rank: Rank.fromJson(json['global']['rank']),
      selectedLegend: Legend.fromJson(json['legends']['selected']),
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

class Legend {
  final String legendName;
  final List<Tracker> data;
  final ImgAssets imgAssets;

  Legend({
    required this.legendName,
    required this.data,
    required this.imgAssets,
  });

  factory Legend.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List<dynamic>? ?? [];
    List<Tracker> trackers =
        dataList.map((item) => Tracker.fromJson(item)).toList();

    return Legend(
      legendName: json['LegendName'],
      data: trackers,
      imgAssets: ImgAssets.fromJson(json['ImgAssets']),
    );
  }
}

class Tracker {
  final String name;
  final dynamic value;
  final String key;
  final bool global;

  Tracker({
    required this.name,
    required this.value,
    required this.key,
    required this.global,
  });

  factory Tracker.fromJson(Map<String, dynamic> json) {
    return Tracker(
      name: json['name'],
      value: json['value'],
      key: json['key'],
      global: json['global'] ?? false,
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
