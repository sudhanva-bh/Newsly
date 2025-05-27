import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:news_reader/Services/news_services.dart';
import 'package:news_reader/Services/stock_services.dart';
import 'package:news_reader/Services/weather_services.dart';
import 'package:news_reader/Widgets/widgets_main.dart';

// Returns a greeting string based on the current time of day
String getGreeting() {
  final hour = DateTime.now().hour;

  if (hour < 12) {
    return 'Good Morning';
  } else if (hour < 17) {
    return 'Good Afternoon';
  } else {
    return 'Good Evening';
  }
}

// Enum for news categories
enum NewsCategory {
  Business,
  Entertainment,
  General,
  Health,
  Science,
  Sports,
  Technology,
}

// Model class for news articles
class NewsArticles {
  final String articleId;
  final String heading;
  final String content;
  final String mainImgUrl;
  final String url;
  final String source;
  final String srcImgUrl;
  final String newsCategory;
  final String pubDate;
  final String next;

  const NewsArticles({
    required this.articleId,
    required this.heading,
    required this.content,
    required this.mainImgUrl,
    required this.url,
    required this.source,
    required this.srcImgUrl,
    required this.newsCategory,
    required this.pubDate,
    required this.next,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsArticles &&
          runtimeType == other.runtimeType &&
          articleId == other.articleId;

  @override
  int get hashCode => articleId.hashCode;
}

// Widget for a centered loading animation
Widget loadingAnimation() {
  return Center(
    child: LoadingAnimationWidget.staggeredDotsWave(
      color: Colors.white,
      size: 200,
    ),
  );
}

// Fetches stock data for a list of symbols
Future<List<StockData>> getStocksData() async {
  final symbols = ['MSFT', 'AMZN', 'AAPL', 'TSLA'];

  try {
    final stockApiKey = dotenv.env['STOCK_API_KEY']!;

    final results = await Future.wait(
      symbols.map((symbol) => fetchStock(symbol: symbol, apiKey: stockApiKey)),
    );

    return [for (int i = 0; i < symbols.length; i++) results[i]];
  } catch (e) {
    throw Exception('$e (getStocksData)');
  }
}

// Fetches weather data using the WeatherService
Future<Map<String, dynamic>> getWeatherData() async {
  final weatherApiKey = dotenv.env['WEATHER_API_KEY']!;
  try {
    final weatherData = await WeatherService.fetchWeatherData(
      apiKey: weatherApiKey,
    );
    return weatherData;
  } catch (e) {
    throw ('$e (getWeatherData)');
  }
}

// Fetches world and breaking news using the NewsService
Future<Map<String, dynamic>> getNewsData() async {
  final newsApiKey = dotenv.env['NEWS_API_KEY']!;
  List<NewsArticles>? worldNews;
  List<NewsArticles>? breakingNews;

  try {
    final newsMap = await NewsService.fetchWorldAndBreakingNews(
      apiKey: newsApiKey,
    );
    worldNews = newsMap['worldNews'];
    breakingNews = newsMap['breakingNews'];
  } catch (e) {
    throw ('$e (fetchWorldAndBreakingNews)');
  }

  return {'worldNews': worldNews, 'breakingNews': breakingNews};
}
