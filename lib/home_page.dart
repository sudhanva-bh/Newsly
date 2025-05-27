import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_reader/Pages/bookmarks_page.dart';
import 'package:news_reader/Pages/home_screen.dart';
import 'package:news_reader/Pages/localised_news_page.dart';

// Main home page with bottom navigation
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Currently selected tab index

  late final List<Widget> _pages; // List of pages for navigation

  @override
  void initState() {
    super.initState();
    // Initialize the list of pages for each tab
    _pages = [
      const HomeScreen(),
      LocalNewsPage(apiKey: dotenv.env['NEWS_API_KEY']!),
      BookmarksPage(),
    ];
  }

  // Handle bottom navigation tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Show the selected page
      body: IndexedStack(index: _selectedIndex, children: _pages),
      // Bottom navigation bar for switching tabs
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 0,
        unselectedFontSize: 0,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'News'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmark',
          ),
        ],
      ),
    );
  }
}
