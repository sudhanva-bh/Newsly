import 'package:flutter/material.dart';
import 'package:news_reader/Widgets/bookmark_widgets.dart';
import 'package:news_reader/Widgets/widgets_news.dart';
import 'package:provider/provider.dart';

// BookmarksPage displays all articles the user has bookmarked
class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with title
      appBar: AppBar(title: const Text('Bookmarked Articles')),
      body: Consumer<BookmarkProvider>(
        // Listen to changes in the BookmarkProvider
        builder: (context, provider, _) {
          final bookmarks = provider.bookmarks;

          // Show message if there are no bookmarks
          if (bookmarks.isEmpty) {
            return const Center(
              child: Text('No bookmarks yet.', style: TextStyle(fontSize: 16)),
            );
          }
          // Display the list of bookmarked articles
          // Use ListView.builder for efficient scrolling
          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final article = bookmarks[index];
              return SmallCard(article: article, alignment: CardAlignment.left);
            },
          );
        },
      ),
    );
  }
}
