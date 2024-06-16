import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:news_app/models/article_model.dart';
import 'favourite_articles_screen.dart';

/// A screen widget displaying detailed news article information.
class NewsDetailScreen extends StatefulWidget {
  final Article article; // Holds the article data passed to this screen.

  const NewsDetailScreen({super.key, required this.article});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  late Box<Article> favoriteBox; // Hive box for storing favorite articles.
  bool isFavorite = false; // Flag indicating if the current article is favorited.

  /// Using initState() to initialize the Hive Box
  /// and check if the article is favorited
  @override
  void initState() {
    super.initState();
    favoriteBox = Hive.box<Article>('favorites');
    isFavorite = favoriteBox.containsKey(widget.article.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.article.title,
          style: TextStyle(
            fontFamily: GoogleFonts.roboto().fontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              setState(() {
                if (isFavorite) {
                  favoriteBox.delete(widget.article.title);
                } else {
                  favoriteBox.put(widget.article.title, widget.article);
                }
                isFavorite = !isFavorite;

                // Notify the FavoriteArticlesNotifier of the change
                context.read<FavoriteArticlesNotifier>().updateFavorites();
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.article.urlToImage.isNotEmpty
                ? Image.network(
                    widget.article.urlToImage,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/bg_1.png');
                    },
                  )
                : Image.asset('assets/images/bg_1.png'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.article.title,
                    style: TextStyle(
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    // The line below displays article metadata (source, author, published date).
                    'Source: ${widget.article.sourceName} \nBy ${widget.article.author} \nPublished at: ${DateFormat('dd MMMM, yyyy hh:mm a').format(widget.article.publishedAt)}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.article.content.isNotEmpty
                        ? widget.article.content
                        : 'Content not available',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (await canLaunchUrl(Uri.parse(widget.article.url))) {
                        await launchUrl(Uri.parse(widget.article
                            .url)); // Launches full article URL in browser.
                      } else {
                        throw 'Could not launch ${widget.article.url}'; // Throws error if URL launch fails.
                      }
                    },
                    child: const Text('Read Full Article'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
