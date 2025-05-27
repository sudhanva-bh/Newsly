import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:news_reader/Services/news_services.dart';
import 'package:news_reader/Widgets/country_selector.dart';
import 'package:news_reader/Widgets/widgets_nav.dart';
import 'package:news_reader/Widgets/widgets_news.dart';
import 'package:news_reader/utils.dart';

class LocalNewsPage extends StatefulWidget {
  final String apiKey;
  const LocalNewsPage({super.key, required this.apiKey});

  @override
  _LocalNewsPageState createState() => _LocalNewsPageState();
}

class _LocalNewsPageState extends State<LocalNewsPage> {
  final ScrollController _scrollController = ScrollController();
  final List<NewsArticles> _localNews = [];

  String? selectedCountry;
  String? selectedCategory = "world";

  final List<String> _categories = [
    "business",
    "crime",
    "domestic",
    "education",
    "entertainment",
    "environment",
    "food",
    "health",
    "lifestyle",
    "politics",
    "science",
    "sports",
    "technology",
    "top",
    "tourism",
    "world",
    "other",
  ];

  String? categoryParam = '&category=world';

  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    NewsService.resetLocalPagination();
    _fetchMoreNews();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _fetchMoreNews();
    }
  }

  Future<void> _fetchMoreNews() async {
    setState(() => _isLoading = true);
    try {
      final newNews = await NewsService.fetchLocalNewsPaginated(
        apiKey: widget.apiKey,
        country: selectedCountry,
        categoryParam: categoryParam,
      );

      setState(() {
        _localNews.addAll(newNews);
        _hasMore = newNews.isNotEmpty;
      });
    } catch (e) {
      debugPrint('Failed to load local news: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildNewsTile(NewsArticles article, int index) {
    if ((index + 1) % 5 == 0) {
      return BigHomeCard(article: article);
    } else {
      return SmallCard(article: article, alignment: CardAlignment.left);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Colors.transparent,
        centerTitle: false, // Align left to fit logo + title nicely
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 39, 147, 255),
                Color.fromARGB(255, 142, 208, 255),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            tooltip: 'Tutorial',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Welcome to Newsly!'),
                    content: const Text(
                      'Here are some tips to get you started:\n\n'
                      '- Pull down to refresh the latest weather, stocks, and news.\n'
                      '- Tap on any news item to read more details.\n'
                      '- Double Tap on any news item add/remove it from bookmarks\n'
                      '- Long press any news item to get a preview\n\n'
                      'Enjoy your experience!',
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Got it'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
        // App bar with logo and title
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png', // your logo image path here
              height: 32,
              width: 32,
            ),
            const SizedBox(width: 2.5),
            const Text(
              "ewsly",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Reset pagination and reload first page
          NewsService.resetLocalPagination();
          setState(() {
            _localNews.clear(); // Clear current articles
            _hasMore = true; // Reset "has more" flag
          });
          await _fetchMoreNews(); // Fetch new data
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: CategoryChipSelector(
                      categories: _categories,
                      onCategorySelected: (selectedCategory) {
                        setState(() {
                          // Store the selected category, then refetch or filter your news accordingly
                          selectedCategory = selectedCategory;
                          categoryParam =
                              selectedCategory != null
                                  ? '&category=$selectedCategory'
                                  : null;

                          NewsService.resetLocalPagination();
                          _localNews.clear();
                          _hasMore = true;
                          _fetchMoreNews(); // Ideally pass selectedCategory to your API fetch
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CountrySelector(
                        selectedCountryCode: selectedCountry,
                        onCountrySelected: (code) {
                          setState(() {
                            selectedCountry =
                                (code == 'WORLD' || code == null) ? null : code;
                            NewsService.resetLocalPagination();
                            _localNews.clear();
                            _hasMore = true;
                          });
                          _fetchMoreNews();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _localNews.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < _localNews.length) {
                    return Column(
                      children: [
                        _buildNewsTile(_localNews[index], index),
                        const SizedBox(height: 5),
                      ],
                    );
                  } else {
                    return SizedBox(
                      height: 165,
                      child: Center(
                        child: Column(
                          children: [
                            LoadingAnimationWidget.waveDots(
                              color: Colors.blue,
                              size: 40,
                            ),
                            Text("Hang on Tight!"),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
