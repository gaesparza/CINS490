import 'package:flutter/material.dart';
import 'package:game_aide/main.dart';
import 'package:url_launcher/url_launcher.dart';
import '/services/apex_news_api.dart';
import '/models/apex_models/apex_news.dart';

class ApexNewsPage extends StatefulWidget {
  const ApexNewsPage({Key? key}) : super(key: key);

  @override
  _ApexNewsPageState createState() => _ApexNewsPageState();
}

class _ApexNewsPageState extends State<ApexNewsPage> {
  final NewsApiService _newsApiService = NewsApiService();
  late Future<List<NewsArticle>> _futureNewsArticles;

  @override
  void initState() {
    super.initState();
    _futureNewsArticles = _newsApiService.fetchNewsArticle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color4,
        title: const Text('Apex Legend News'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'logos/logo-Apex-Legends.png',
            fit: BoxFit.contain,
            height: 32,
          ),
        ),
      ),
      body: FutureBuilder<List<NewsArticle>>(
        future: _futureNewsArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData) {
            return _buildNewsList(snapshot.data!);
          } else {
            return const Center(
              child: Text('No news available.'),
            );
          }
        },
      ),
    );
  }

  Widget _buildNewsList(List<NewsArticle> articles) {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return _buildNewsItem(articles[index]);
      },
    );
  }

//Builds individual article item(img,descrpt,link)
  Widget _buildNewsItem(NewsArticle article) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.network(
          article.img,
          width: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, StackTrace) {
            return const Icon(Icons.image_not_supported);
          },
        ),
        title: Text(article.title),
        subtitle: Text(article.shortDesc),
        onTap: () => _launchURL(article.link),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch the article')),
      );
    }
  }
}
