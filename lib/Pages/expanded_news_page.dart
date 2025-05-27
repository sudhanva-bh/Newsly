import 'package:flutter/material.dart';
import 'package:news_reader/Widgets/bookmark_widgets.dart';
import 'package:news_reader/Widgets/widgets_nav.dart';
import 'package:news_reader/Widgets/widgets_news.dart';
import 'package:news_reader/utils.dart';
import 'package:provider/provider.dart';

class OverlayNewsWidget extends StatelessWidget {
  final NewsArticles article;

  const OverlayNewsWidget({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final bool hasContent = article.content.trim().isNotEmpty;
    final String displayedText =
        hasContent ? article.content.trim() : article.heading;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: screenWidth * 0.7,
          maxHeight: screenHeight * 0.7,
        ),
        child: Card(
          margin: const EdgeInsets.all(2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey, width: 1.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child:
                    article.mainImgUrl.startsWith('http')
                        ? Image.network(
                          article.mainImgUrl,
                          fit: BoxFit.cover,
                          height: screenHeight * 0.25,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/error_placeholder.jpg',
                              fit: BoxFit.cover,
                              height: screenHeight * 0.25,
                              width: double.infinity,
                            );
                          },
                        )
                        : Image.asset(
                          article.mainImgUrl,
                          fit: BoxFit.cover,
                          height: screenHeight * 0.25,
                          width: double.infinity,
                        ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 20,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                article.source,
                                style: TextStyle(color: Colors.grey[600]),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: SizedBox(
                            height: 20,
                            child: Text(
                              hoursSince(article.pubDate),
                              style: TextStyle(color: Colors.grey[600]),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (hasContent) // Show heading only if content exists
                      Text(
                        article.heading,
                        style: TextStyle(
                          fontFamily: 'Newsreader',
                          fontSize: 18,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      displayedText,
                      style: const TextStyle(fontSize: 16),
                      softWrap: true,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowArticlePage extends StatefulWidget {
  final NewsArticles article;

  const ShowArticlePage({super.key, required this.article});

  @override
  State<ShowArticlePage> createState() => _ShowArticlePageState();
}

class _ShowArticlePageState extends State<ShowArticlePage> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      // Set theme based on _isDarkMode
      data:
          _isDarkMode
              ? ThemeData.dark().copyWith(
                scaffoldBackgroundColor: Colors.black,
                cardColor: Colors.grey[900],
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                chipTheme: ChipThemeData.fromDefaults(
                  brightness: Brightness.dark,
                  secondaryColor: Colors.grey[800]!,
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              )
              : ThemeData.light().copyWith(
                scaffoldBackgroundColor: Colors.white,
                cardColor: Colors.white,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                chipTheme: ChipThemeData.fromDefaults(
                  brightness: Brightness.light,
                  secondaryColor: Colors.grey[300]!,
                  labelStyle: const TextStyle(color: Colors.black),
                ),
              ),
      child: Scaffold(
        appBar: AppBar(
          // App bar with article source and theme toggle
          title: Text(widget.article.source),
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                setState(() => _isDarkMode = !_isDarkMode);
              },
              tooltip: 'Toggle Theme',
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Main image ===
              widget.article.mainImgUrl.startsWith('http')
                  ? Image.network(
                    widget.article.mainImgUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
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
                  ),
              const SizedBox(height: 10),

              // === Source, category, bookmark ===
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    // Source image
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child:
                            widget.article.srcImgUrl.startsWith('http')
                                ? Image.network(
                                  widget.article.srcImgUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/error_placeholder.jpg',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                                : Image.asset(
                                  widget.article.srcImgUrl,
                                  fit: BoxFit.cover,
                                ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Source name
                    Text(
                      widget.article.source,
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            _isDarkMode ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                    const Spacer(),
                    // News category chip
                    Chip(
                      label: Text(
                        widget.article.newsCategory.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      backgroundColor: const Color(0xFFE0E0E0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0, // keep it flat
                    ),

                    const SizedBox(width: 8),
                    // Bookmark button (only for network images)
                    if (widget.article.mainImgUrl.startsWith('http'))
                      Center(
                        child: Consumer<BookmarkProvider>(
                          builder: (context, bookmarkProvider, _) {
                            return BookmarkIconButton(article: widget.article);
                          },
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // === Heading ===
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  widget.article.heading,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // === Content ===
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  widget.article.content,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),

              const SizedBox(height: 20),

              // === Read More Button ===
              if (widget.article.mainImgUrl.startsWith('http'))
                Center(
                  child: TapLaunchUrl(
                    url: widget.article.url,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
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
                        "Read More",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
