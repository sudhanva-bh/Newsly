import 'package:flutter/material.dart';
import 'package:news_reader/utils.dart';
import 'package:provider/provider.dart';

// Provider for managing bookmarked articles
class BookmarkProvider with ChangeNotifier {
  final List<NewsArticles> _bookmarkedArticles = [];

  List<NewsArticles> get bookmarks => _bookmarkedArticles;

  // Add or remove an article from bookmarks
  void toggleBookmark(NewsArticles article) {
    if (_bookmarkedArticles.contains(article)) {
      _bookmarkedArticles.remove(article);
    } else {
      _bookmarkedArticles.add(article);
    }
    notifyListeners();
  }

  // Check if an article is bookmarked
  bool isBookmarked(NewsArticles article) =>
      _bookmarkedArticles.contains(article);
}

// Icon button for bookmarking/unbookmarking an article
class BookmarkIconButton extends StatelessWidget {
  final NewsArticles article;

  const BookmarkIconButton({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookmarkProvider>(
      builder: (context, bookmarkProvider, _) {
        final isBookmarked = bookmarkProvider.isBookmarked(article);
        return IconButton(
          icon: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: isBookmarked ? Colors.blue : Colors.grey,
          ),
          onPressed: () {
            bookmarkProvider.toggleBookmark(article);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isBookmarked
                      ? 'Removed from bookmarks'
                      : 'Added to bookmarks',
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        );
      },
    );
  }
}

// Widget that allows double-tap to bookmark/unbookmark with animation
class DoubleTapBookmark extends StatefulWidget {
  final NewsArticles article;
  final Widget child;

  const DoubleTapBookmark({
    super.key,
    required this.article,
    required this.child,
  });

  @override
  State<DoubleTapBookmark> createState() => _DoubleTapBookmarkState();
}

class _DoubleTapBookmarkState extends State<DoubleTapBookmark>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _showIcon = false;
  Offset? _tapPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    // Listen for animation status to hide icon after animation
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _controller.reverse();
        });
      } else if (status == AnimationStatus.dismissed) {
        setState(() => _showIcon = false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Store the tap position for icon animation
  void _onDoubleTapDown(TapDownDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = renderBox.globalToLocal(details.globalPosition);
    });
  }

  // Handle double-tap: toggle bookmark and show animation
  void _onDoubleTap(BookmarkProvider bookmarkProvider) {
    bookmarkProvider.toggleBookmark(widget.article);
    setState(() => _showIcon = true);
    _controller.forward(from: 0.0);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          bookmarkProvider.isBookmarked(widget.article)
              ? 'Added to bookmarks'
              : 'Removed from bookmarks',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookmarkProvider>(
      builder: (context, bookmarkProvider, _) {
        return GestureDetector(
          onDoubleTapDown: _onDoubleTapDown,
          onDoubleTap: () => _onDoubleTap(bookmarkProvider),
          child: Stack(
            children: [
              widget.child,
              if (_showIcon && _tapPosition != null)
                Positioned(
                  left: _tapPosition!.dx - 50, // Center the icon
                  top: _tapPosition!.dy - 50, // Center the icon
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child:
                        bookmarkProvider.isBookmarked(widget.article)
                            ? Icon(
                              Icons.bookmark_add_outlined,
                              color: Colors.green.withValues(alpha: 0.8),
                              size: 70,
                            )
                            : Icon(
                              Icons.bookmark_remove_outlined,
                              color: Colors.red.withValues(alpha: 0.8),
                              size: 70,
                            ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
