class ValorantEvent {
  final String bannerUrl;
  final String category;
  final DateTime date;
  final String? externalLink;
  final String title;
  final String url;

  ValorantEvent({
    required this.bannerUrl,
    required this.category,
    required this.date,
    required this.externalLink,
    required this.title,
    required this.url,
  });

  factory ValorantEvent.fromJson(Map<String, dynamic> json) {
    return ValorantEvent(
      bannerUrl: json['banner_url'] as String,
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
      externalLink: json['external_link'] as String?,
      title: json['title'] as String,
      url: json['url'] as String,
    );
  }
}