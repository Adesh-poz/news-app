import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'package:news_app/reusables/constants.dart';
import 'package:news_app/models/article_model.dart';
import 'news_detail_screen.dart';

/// Screen widget displaying a list of favorite articles.
class FavoriteArticlesScreen extends StatelessWidget {
  const FavoriteArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the list of favorite articles using Provider
    final favoriteArticles = context.watch<FavoriteArticlesNotifier>().favoriteArticles;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Favorite Articles',
          style: TextStyle(
            fontFamily:
                GoogleFonts.oswald(fontWeight: FontWeight.bold).fontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: greyBlack,
          ),
        ),
        centerTitle: true,
        elevation: 6.0,
        shadowColor: Colors.black,
      ),
      body: favoriteArticles.isEmpty
          ? const Center(child: Text('No favorite articles yet!'))
          : ListView.builder(
              itemCount: favoriteArticles.length,
              itemBuilder: (context, index) {
                final article = favoriteArticles[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  elevation: 4.0,
                  color: cherryWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      article.title,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    subtitle: Text(article.sourceName),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: article.urlToImage.isNotEmpty
                          ? Image.network(
                              article.urlToImage,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/bg_1.png',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : Image.asset(
                              'assets/images/bg_1.png',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NewsDetailScreen(article: article),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

/// ChangeNotifier class managing favorite articles state.
class FavoriteArticlesNotifier extends ChangeNotifier {
  final Box<Article> _favoriteBox;
  List<Article> _favoriteArticles = [];

  FavoriteArticlesNotifier(this._favoriteBox) {
    _init();
  }

  /// Initializes the notifier by loading initial favorite articles and setting up listener.
  void _init() {
    _favoriteArticles =
        _favoriteBox.values.toList(); // Load initial favorite articles
    _favoriteBox.watch().listen((event) {
      _favoriteArticles = _favoriteBox.values
          .toList(); // Update favorite articles on box change
      notifyListeners(); // Notify listeners of state change
    });
  }

  /// Getter for the list of favorite articles.
  List<Article> get favoriteArticles => _favoriteArticles;

  /// Updates the list of favorite articles and notifies listeners.
  void updateFavorites() {
    _favoriteArticles =
        _favoriteBox.values.toList(); // Update favorite articles
    notifyListeners(); // Notify listeners of state change
  }
}
