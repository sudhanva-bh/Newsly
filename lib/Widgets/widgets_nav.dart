import 'package:flutter/material.dart';
import 'package:news_reader/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Widget to show a preview overlay on long press
class LongPressPreview extends StatefulWidget {
  final Widget child;
  final Widget preview;

  const LongPressPreview({
    super.key,
    required this.child,
    required this.preview,
  });

  @override
  State<LongPressPreview> createState() => _LongPressPreviewState();
}

class _LongPressPreviewState extends State<LongPressPreview> {
  OverlayEntry? _overlayEntry;

  // Show the preview overlay
  void _showPreview(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned.fill(
            child: Material(
              color: Colors.black54,
              child: Center(child: widget.preview),
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  // Hide the preview overlay
  void _hidePreview() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPressStart: (_) => _showPreview(context),
      onLongPressEnd: (_) => _hidePreview(),
      onLongPressCancel: _hidePreview,
      child: widget.child,
    );
  }
}

// Widget for tapping to navigate to a page or show dialog if article is empty
class TapNavigateURL extends StatelessWidget {
  final Widget child;
  final NewsArticles article;
  final Widget navigateToPage;

  const TapNavigateURL({
    super.key,
    required this.child,
    required this.article,
    required this.navigateToPage,
  });

  // Handle tap: show dialog if article is empty, otherwise navigate
  void _handleTap(BuildContext context) {
    if (article.content.trim().isEmpty) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text("Open in Browser"),
              content: const Text(
                "This article has no content. Do you want to open it in the browser?",
                style: TextStyle(fontSize: 14),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context), // Dismiss dialog
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Dismiss dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InAppWebViewPage(url: article.url),
                      ),
                    );
                  },
                  child: const Text("Open"),
                ),
              ],
            ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => navigateToPage),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () => _handleTap(context), child: child);
  }
}

// Widget for tapping to navigate to a given page
class TapNavigate extends StatelessWidget {
  final Widget child;
  final Widget navigateToPage;

  const TapNavigate({
    super.key,
    required this.child,
    required this.navigateToPage,
  });

  void _navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => navigateToPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () => _navigate(context), child: child);
  }
}

// Widget for tapping to launch a URL in an in-app webview
class TapLaunchUrl extends StatelessWidget {
  final Widget child;
  final String url;

  const TapLaunchUrl({super.key, required this.child, required this.url});

  void _launchUrl(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => InAppWebViewPage(url: url)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () => _launchUrl(context), child: child);
  }
}

// In-app webview page for displaying a URL
class InAppWebViewPage extends StatelessWidget {
  final String url;

  const InAppWebViewPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}

// Widget for selecting a news category using horizontal chips
class CategoryChipSelector extends StatefulWidget {
  final List<String> categories;
  final ValueChanged<String?> onCategorySelected;

  const CategoryChipSelector({
    Key? key,
    required this.categories,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  _CategoryChipSelectorState createState() => _CategoryChipSelectorState();
}

class _CategoryChipSelectorState extends State<CategoryChipSelector> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          final isSelected = category == _selectedCategory;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(category[0].toUpperCase() + category.substring(1)),
              selected: isSelected,
              selectedColor: Colors.blue,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = selected ? category : null;
                });
                widget.onCategorySelected(_selectedCategory);
              },
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
              backgroundColor: Colors.grey.shade200,
            ),
          );
        },
      ),
    );
  }
}
