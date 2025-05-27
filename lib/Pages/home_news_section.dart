import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_reader/Pages/localised_news_page.dart';
import 'package:news_reader/Widgets/widgets_nav.dart';
import 'package:news_reader/Widgets/widgets_news.dart';
import 'package:news_reader/utils.dart';

class NewsSection extends StatefulWidget {
  final Map<String, dynamic> newsData;
  const NewsSection({super.key, required this.newsData});

  @override
  State<NewsSection> createState() => _NewsSectionState();
}

class _NewsSectionState extends State<NewsSection> {
  @override
  Widget build(BuildContext context) {
    // Prepare a list of hot topics from world news (max 10)
    final List<NewsArticles> hotTopics = [
      for (
        int i = 0;
        i < (widget.newsData['worldNews']?.length ?? 0).clamp(0, 10);
        i++
      )
        widget.newsData['worldNews']![i],
    ];
    return Column(
      children: [
        // Section: Around the World
        SizedBox(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            "Around the World",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 5),
        SlidingWidgets(hotTopics: hotTopics),
        SizedBox(height: 15),
        Divider(),
        SizedBox(height: 10),

        // Section: Breaking News
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            "Breaking News",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 15),
        // First big breaking news card
        BigHomeCard(article: widget.newsData['breakingNews'][0]),
        // Small cards for breaking news 1-8
        for (int i = 1; i < 9; i++)
          SmallCard(
            article: widget.newsData['breakingNews'][i],
            alignment: i % 2 == 0 ? CardAlignment.left : CardAlignment.right,
          ),
        // Last big breaking news card
        BigHomeCard(article: widget.newsData['breakingNews'][9]),
        SizedBox(height: 10),

        // Button to navigate to local news
        TapNavigate(
          navigateToPage: LocalNewsPage(apiKey: dotenv.env['NEWS_API_KEY']!),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25), // rounded edges
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 39, 147, 255),
                  Color.fromARGB(255, 142, 208, 255),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.4),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Text(
              "View More",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
