import 'dart:async';
import 'package:news_reader/Pages/expanded_news_page.dart';
import 'package:news_reader/Widgets/bookmark_widgets.dart';
import 'package:news_reader/utils.dart';
import 'package:flutter/material.dart';
import 'package:news_reader/Widgets/widgets_nav.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:intl/intl.dart';

// Returns the number of hours since the given date/time string
String hoursSince(String dateTimeString) {
  final inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  final inputTime = inputFormat.parse(dateTimeString, true).toUtc();
  final now = DateTime.now().toUtc();

  final duration = now.difference(inputTime);
  return '${duration.inHours}h';
}

// Big card widget for main news articles
class BigHomeCard extends StatelessWidget {
  final NewsArticles article;

  const BigHomeCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return DoubleTapBookmark(
      article: article,
      child: TapNavigateURL(
        navigateToPage: ShowArticlePage(article: article),
        article: article,
        child: LongPressPreview(
          preview: OverlayNewsWidget(article: article),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Card(
              margin: const EdgeInsets.all(2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: Colors.grey, // Outline color
                  width: 1.0, // Outline width
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main image
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child:
                          article.mainImgUrl.startsWith('http')
                              ? Image.network(
                                article.mainImgUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/error_placeholder.jpg',
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                              : Image.asset(
                                article.mainImgUrl,
                                fit: BoxFit.cover,
                              ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Source image
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  child:
                                      article.srcImgUrl.startsWith('http')
                                          ? Image.network(
                                            article.srcImgUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return Image.asset(
                                                'assets/error_placeholder.jpg',
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          )
                                          : Image.asset(
                                            article.srcImgUrl,
                                            fit: BoxFit.cover,
                                          ),
                                ),
                              ),
                              SizedBox(width: 10),
                              // Source name
                              SizedBox(
                                height: 20,
                                child: Center(
                                  child: Text(
                                    article.source,
                                    style: TextStyle(color: Colors.grey[600]),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              Spacer(),
                              // Time since published
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: SizedBox(
                                  height: 20,
                                  child: Text(
                                    hoursSince(article.pubDate),
                                    style: TextStyle(color: Colors.grey[600]),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          // Article heading
                          Text(
                            article.heading,
                            style: TextStyle(
                              fontFamily: 'Newsreader',
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Enum for card alignment (left or right)
enum CardAlignment { left, right }

// Small card widget for news articles (used in lists)
class SmallCard extends StatelessWidget {
  final NewsArticles article;
  final CardAlignment alignment;

  const SmallCard({super.key, required this.article, required this.alignment});

  @override
  Widget build(BuildContext context) {
    // News image with rounded corners
    Widget image = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 160,
        height: 150,
        child: Stack(
          children: [
            // Main image
            Positioned.fill(
              child:
                  article.mainImgUrl.startsWith('http')
                      ? Image.network(
                        article.mainImgUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/error_placeholder.jpg',
                            fit: BoxFit.cover,
                          );
                        },
                      )
                      : Image.asset(article.mainImgUrl, fit: BoxFit.cover),
            ),
            // Source image positioned based on alignment
            Positioned(
              bottom: 8,
              left: alignment == CardAlignment.right ? 8 : null,
              right: alignment == CardAlignment.left ? 8 : null,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child:
                      article.srcImgUrl.startsWith('http')
                          ? Image.network(
                            article.srcImgUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/error_placeholder.jpg',
                                fit: BoxFit.cover,
                              );
                            },
                          )
                          : Image.asset(article.srcImgUrl, fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // Article heading text
    Widget text = Expanded(
      child: Container(
        padding: const EdgeInsets.all(2),
        child: Text(
          article.heading,
          style: const TextStyle(fontFamily: 'Newsreader', fontSize: 18),
          overflow: TextOverflow.ellipsis,
          textAlign:
              alignment == CardAlignment.left
                  ? TextAlign.left
                  : TextAlign.right,
          maxLines: 4,
        ),
      ),
    );

    // Card layout with tap, double-tap, and long-press actions
    return DoubleTapBookmark(
      article: article,
      child: TapNavigateURL(
        navigateToPage: ShowArticlePage(article: article),
        article: article,
        child: LongPressPreview(
          preview: OverlayNewsWidget(article: article),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Card(
              margin: const EdgeInsets.all(2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.grey, width: 1.0),
              ),
              child: Container(
                height: 140,
                width: double.infinity,
                padding: const EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:
                      alignment == CardAlignment.left
                          ? [image, const SizedBox(width: 6), text]
                          : [text, const SizedBox(width: 6), image],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Widget for a single entry in the sliding hot topics carousel
class SlidingWidgetsEntry extends StatefulWidget {
  final NewsArticles article;

  const SlidingWidgetsEntry({super.key, required this.article});

  @override
  State<SlidingWidgetsEntry> createState() => _SlidingWidgetsEntry();
}

class _SlidingWidgetsEntry extends State<SlidingWidgetsEntry> {
  @override
  Widget build(BuildContext context) {
    return DoubleTapBookmark(
      article: widget.article,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Main image
            widget.article.mainImgUrl.startsWith('http')
                ? Image.network(
                  widget.article.mainImgUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/error_placeholder.jpg',
                      fit: BoxFit.cover,
                    );
                  },
                )
                : Image.asset(
                  widget.article.mainImgUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
            // Article heading overlay
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.article.heading,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black54,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Sliding carousel widget for hot topics/news
class SlidingWidgets extends StatefulWidget {
  final List<NewsArticles> hotTopics;

  const SlidingWidgets({super.key, required this.hotTopics});

  @override
  State<SlidingWidgets> createState() => _SlidingWidgets();
}

class _SlidingWidgets extends State<SlidingWidgets> {
  final controller = PageController(viewportFraction: 0.8, keepPage: true);
  Timer? _timer; // Timer for auto-scroll
  int _currentPage = 0; // Track current page

  @override
  void initState() {
    super.initState();
    _startAutoScroll(4);
  }

  // Start auto-scrolling the carousel every [duration] seconds
  void _startAutoScroll(int duration) {
    _timer = Timer.periodic(Duration(seconds: duration), (Timer timer) {
      if (controller.hasClients && widget.hotTopics.isNotEmpty) {
        int nextPage = _currentPage + 1;
        if (nextPage >= widget.hotTopics.length) {
          nextPage = 0;
        }
        controller.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentPage = nextPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Generate a list of hot topic pages
    final pages = List.generate(
      widget.hotTopics.length,
      (index) => LongPressPreview(
        preview: OverlayNewsWidget(article: widget.hotTopics[index]),
        child: TapNavigateURL(
          navigateToPage: ShowArticlePage(article: widget.hotTopics[index]),
          article: widget.hotTopics[index],
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey.shade300,
            ),
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: SizedBox(
              height: 400,
              child: SlidingWidgetsEntry(article: widget.hotTopics[index]),
            ),
          ),
        ),
      ),
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 8),
          // Carousel of hot topics
          SizedBox(
            height: 250,
            child: PageView.builder(
              controller: controller,
              itemCount: widget.hotTopics.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
                _timer?.cancel(); // Cancel the old timer
                _startAutoScroll(8); // Start a new timer
              },
              itemBuilder: (_, index) {
                return pages[index % pages.length];
              },
            ),
          ),
          Padding(padding: const EdgeInsets.only(top: 24, bottom: 12)),
          // Page indicator
          SmoothPageIndicator(
            controller: controller,
            count: pages.length,
            effect: const SwapEffect(dotHeight: 12, dotWidth: 12),
          ),
        ],
      ),
    );
  }
}
