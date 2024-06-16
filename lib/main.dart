import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:news_app/screens/favourite_articles_screen.dart';
import 'package:news_app/screens/home_screen.dart';
import 'package:news_app/models/article_model.dart';

/// Entry point of the application.
Future<void> main() async {
  // Loads the .env file that contains the APIKey. Get your own API Key at [newsapi.org].
  await dotenv.load(fileName: '.env');

  // Ensures that Flutter bindings are initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Initializes Hive with the specified path.
  await Hive.initFlutter();

  // Registers the adapter for Article to facilitate serialization/deserialization.
  Hive.registerAdapter(ArticleAdapter());

  // Opens the 'favorites' box where favorite articles are stored.
  var favoriteBox = await Hive.openBox<Article>('favorites');

  // Runs the application with MyNewsApp as the root widget.
  runApp(MyNewsApp(favoriteBox: favoriteBox));
}

/// Root widget of the News App.
class MyNewsApp extends StatelessWidget {
  const MyNewsApp({super.key, required this.favoriteBox});

  // The Hive box where favorite articles are stored.
  final Box<Article> favoriteBox;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Provides the FavoriteArticlesNotifier with the favoriteBox instance.
      create: (_) => FavoriteArticlesNotifier(favoriteBox),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News App',
        home: HomeScreen(),
      ),
    );
  }
}
