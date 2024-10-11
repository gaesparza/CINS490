class Tip {
  final String title;
  final String url;

  Tip({
    required this.title,
    required this.url,
  });

  factory Tip.fromJson(Map<String, dynamic> json) {
    return Tip(
      title: json['title'],
      url: json['url'],
    );
  }
}
