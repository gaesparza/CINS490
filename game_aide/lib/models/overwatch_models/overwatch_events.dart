class EventsArticle {
  final String title;
  final String url;
  final String thumbnailUrl;
  final String shortDesc;

  EventsArticle({
    required this.title,
    required this.url,
    required this.thumbnailUrl,
    required this.shortDesc,
  });

  factory EventsArticle.fromJson(Map<String, dynamic> json) {
    return EventsArticle(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      shortDesc: json['short_desc'] ?? '',
    );
  }
}
