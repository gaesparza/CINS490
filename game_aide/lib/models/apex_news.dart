class NewsArticle {
  final String title;
  final String link;
  final String img;
  final String shortDesc;

  NewsArticle({
    required this.title,
    required this.link,
    required this.img,
    required this.shortDesc,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      link: json['link'] ?? '',
      img: json['img'] ?? '',
      shortDesc: json['short_desc'] ?? '',
    );
  }
}
