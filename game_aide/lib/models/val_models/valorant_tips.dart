class Tip {
  final String title;
  final String url;
  final String? thumbnailUrl;

  Tip({
    required this.title,
    required this.url,
    this.thumbnailUrl,
  });

  factory Tip.fromJson(Map<String, dynamic> json) {
    return Tip(
      title: json['title'],
      url: json['url'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }
}
