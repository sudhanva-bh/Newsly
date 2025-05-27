import 'package:flutter/material.dart';
import 'package:news_reader/Pages/bookmarks_page.dart';
import 'package:news_reader/Pages/weather_page.dart';
import 'package:news_reader/Widgets/widgets_nav.dart';

// Skeleton container for loading/error states
Widget containerSkeleton({required Widget child}) {
  return Container(
    height: 165,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Color.fromARGB(255, 39, 147, 255),
          Color.fromARGB(255, 142, 208, 255),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 3)),
      ],
    ),
    child: child,
  );
}

// Weather card widget for displaying current weather info
class WeatherCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const WeatherCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final currentTemp = data['current']['main']['temp'] - 273.15;
    final currentCondition = data['current']['weather'][0]['main'];
    return TapNavigate(
      navigateToPage: WeatherPage(weatherData: data),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: containerSkeleton(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // City name row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text(
                    data['city'],
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              // Weather icon
              Icon(
                WeatherPage.weatherIcons[currentCondition],
                size: 50,
                color:
                    currentCondition == 'Clear'
                        ? Colors.yellow
                        : Colors.grey[400],
              ),
              // Temperature
              Text(
                "${currentTemp.toStringAsFixed(1)}°C",
                style: TextStyle(fontSize: 28, color: Colors.white),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

// Model for stock data
class StockData {
  final String symbol;
  final double price;
  final double change;
  final Color color;

  // Color is green for positive change, red for negative
  StockData({required this.symbol, required this.price, required this.change})
    : color = change >= 0 ? Colors.green : Colors.red;
}

// Row widget for displaying a single stock's info
class StockRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const StockRow({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              Icon(
                color == Colors.green
                    ? Icons.arrow_upward_outlined
                    : Icons.arrow_downward_outlined,
                size: 16,
                color: color,
              ),
              Text(value, style: TextStyle(color: color)),
            ],
          ),
        ],
      ),
    );
  }
}

// Card widget for displaying a list of stocks
class StockCard extends StatelessWidget {
  final List<StockData> data;

  const StockCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return TapLaunchUrl(
      url: 'https://www.google.com/finance',
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: containerSkeleton(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.show_chart, size: 18, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    "Money",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // List of stocks
              ...data.map(
                (stock) => StockRow(
                  label: stock.symbol,
                  value: stock.price.toStringAsFixed(2),
                  color: stock.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Card for navigating to Bookmarks/Top News
class TopNewsTile extends StatelessWidget {
  const TopNewsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return TapNavigate(
      navigateToPage: BookmarksPage(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          height: 165,
          width: 150,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 39, 147, 255),
                Color.fromARGB(255, 142, 208, 255),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(2, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.newspaper, size: 36, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                'Top News',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Search bar widget for news search
class NewsSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String hintText;

  const NewsSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText = "Search",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(Icons.search, color: Colors.grey[600]),
        ],
      ),
    );
  }
}
