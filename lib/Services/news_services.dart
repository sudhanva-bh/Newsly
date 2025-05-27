// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_reader/utils.dart';

enum Countries { IN, AU, US, GB, DE, MX }

class NewsService {
  static Future<Map<String, List<NewsArticles>>> fetchWorldAndBreakingNews({
    required String apiKey,
  }) async {
    final String baseUrl =
        'https://newsdata.io/api/1/latest?apikey=$apiKey&domain=nytimes,bbc,google,theguardian,yahoo&category=world&image=1&prioritydomain=top&language=en';

    // 1. Fetch world news (first page)
    final response1 = await http.get(Uri.parse(baseUrl));
    if (response1.statusCode != 200) {
      throw Exception('Failed to load world news');
    }

    final decoded1 = json.decode(response1.body);
    final String? nextPage = decoded1['nextPage'];
    final List<NewsArticles> worldNews =
        (decoded1['results'] as List)
            .map(
              (json) => NewsArticles(
                articleId: json['article_id'],
                heading: json['title'] ?? 'No Title',
                content: json['description'] ?? '',
                mainImgUrl: json['image_url'] ?? 'assets/dummy.webp',
                url: json['link'] ?? '',
                source: json['source_name'] ?? 'Unknown',
                srcImgUrl: json['source_icon'] ?? 'assets/dummy_web.png',
                newsCategory: json['category']?[0] ?? 'World',
                pubDate: json['pubDate'],
                next: nextPage ?? '',
              ),
            )
            .toList();

    // 2. Fetch breaking news from next page (if available)
    List<NewsArticles> breakingNews = [];
    if (nextPage != null && nextPage.isNotEmpty) {
      final response2 = await http.get(Uri.parse('$baseUrl&page=$nextPage'));
      if (response2.statusCode == 200) {
        final decoded2 = json.decode(response2.body);
        breakingNews =
            (decoded2['results'] as List)
                .map(
                  (json) => NewsArticles(
                    articleId: json['article_id'],
                    heading: json['title'] ?? 'No Title',
                    content: json['description'] ?? '',
                    mainImgUrl: json['image_url'] ?? 'assets/dummy.webp',
                    url: json['link'] ?? '',
                    source: json['source_name'] ?? 'Unknown',
                    srcImgUrl: json['source_icon'] ?? 'assets/dummy_web.png',
                    newsCategory: json['category']?[0] ?? 'World',
                    pubDate: json['pubDate'],
                    next: decoded2['nextPage'] ?? '',
                  ),
                )
                .toList();
      }
    }

    return {'worldNews': worldNews, 'breakingNews': breakingNews};
  }

  static String? _nextLocalPage;

  static Future<List<NewsArticles>> fetchLocalNewsPaginated({
    required String apiKey,
    required String? categoryParam,
    required String? country,
  }) async {
    final pageParam = _nextLocalPage != null ? '&page=$_nextLocalPage' : '';
    var url =
        'https://newsdata.io/api/1/news?apikey=$apiKey&prioritydomain=top&language=en&image=1$pageParam';
    if (categoryParam != null) url = '$url$categoryParam';
    if (country != null) url = '$url&country=$country';
    print(url);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load local news');
    }

    final decoded = json.decode(response.body);
    _nextLocalPage = decoded['nextPage'];

    final List results = decoded['results'] ?? [];

    // Map each result to a NewsArticles object, handling missing/null fields
    return results
        .map(
          (json) => NewsArticles(
            articleId: json['article_id'],
            heading: json['title'] ?? 'No Title',
            content: json['description'] ?? '',
            mainImgUrl: json['image_url'] ?? 'assets/dummy.webp',
            url: json['link'] ?? '',
            source: json['source_name'] ?? 'Unknown',
            srcImgUrl: json['source_icon'] ?? 'assets/dummy_web.png',
            newsCategory: json['category']?[0] ?? 'Local',
            pubDate: json['pubDate'],
            next: _nextLocalPage ?? '',
          ),
        )
        .toList();
  }

  /// Reset pagination state for local news
  static void resetLocalPagination() {
    _nextLocalPage = null;
  }
}
