import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:news_reader/Pages/home_news_section.dart';
import 'package:news_reader/Widgets/widgets_main.dart';
import 'package:news_reader/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, dynamic>> weatherAPIData;
  late Future<Map<String, dynamic>> newsAPIData;
  late Future<List<StockData>> stockAPIData;

  // Refresh all API data
  Future<void> _refreshData() async {
    setState(() {
      weatherAPIData = getWeatherData();
      newsAPIData = getNewsData();
      stockAPIData = getStocksData();
    });
  }

  @override
  void initState() {
    super.initState();
    // Initial API data fetch
    weatherAPIData = getWeatherData();
    newsAPIData = getNewsData();
    stockAPIData = getStocksData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Colors.transparent,
        centerTitle: false,
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
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 32, width: 32),
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
      ),

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting section
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    getGreeting(),
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Weather and Stock cards row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(width: 24),
                    Expanded(
                      child: FutureBuilder(
                        future: weatherAPIData,
                        builder: (context, snapshot) {
                          // Show loading animation while waiting for weather data
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox(
                              height: 165,
                              child: Center(
                                child: Column(
                                  children: [
                                    LoadingAnimationWidget.waveDots(
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                    Text("Its Chilly"),
                                  ],
                                ),
                              ),
                            );
                          }
                          // Show error if weather API fails
                          if (snapshot.hasError) {
                            return containerSkeleton(
                              child: Center(
                                child: Text(snapshot.error.toString()),
                              ),
                            );
                          }
                          // Show weather card with fetched data
                          final weatherData = snapshot.data!;
                          return WeatherCard(data: weatherData);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FutureBuilder(
                        future: stockAPIData,
                        builder: (context, snapshot) {
                          // Show loading animation while waiting for stock data
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox(
                              height: 165,
                              child: Center(
                                child: Column(
                                  children: [
                                    LoadingAnimationWidget.waveDots(
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                    Text("Stonks"),
                                  ],
                                ),
                              ),
                            );
                          }
                          // Show error if stock API fails
                          if (snapshot.hasError) {
                            return containerSkeleton(
                              child: Center(
                                child: Text(snapshot.error.toString()),
                              ),
                            );
                          }
                          // Show stock card with fetched data
                          final stockData = snapshot.data!;
                          return StockCard(data: stockData);
                        },
                      ),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),
                const Divider(),
                // News section (breaking, world, etc.)
                FutureBuilder(
                  future: newsAPIData,
                  builder: (context, snapshot) {
                    // Show loading animation while waiting for news data
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LoadingAnimationWidget.waveDots(
                              color: Colors.blue,
                              size: 20,
                            ),
                            Text("Hang on Tight!"),
                          ],
                        ),
                      );
                    }
                    // Show error if news API fails
                    if (snapshot.hasError) {
                      return containerSkeleton(
                        child: Center(child: Text(snapshot.error.toString())),
                      );
                    }
                    // Show news section with fetched data
                    final newsData = snapshot.data!;
                    return NewsSection(newsData: newsData);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
