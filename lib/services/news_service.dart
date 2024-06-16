import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:news_app/models/article_model.dart';

/// A service class for fetching news articles from an API.
class NewsService {
  late String _apiKey; // Stores the API key for accessing the news API.

  NewsService() {
    _initialize(); // Calls _initialize method to load API key from environment variables.
  }

  /// Asynchronously initializes the NewsService instance.
  Future<void> _initialize() async {
    await dotenv.load(fileName: ".env"); // Loads environment variables from .env file.
    _apiKey = dotenv.get(
      'NEWSAPIKEY',
      fallback: 'API Key not found',
    ); // Retrieves the API key from environment variables.
  }

  /// Fetches a list of articles based on a specific category.
  Future<List<Article>> fetchArticles(String category,
      {int page = 1, int pageSize = 20}) async {
    await _initialize(); // Ensures apiKey is initialized before fetching news.

    // Makes an HTTP GET request to fetch top headlines based on category and pagination parameters.
    final response = await http.get(Uri.https(
      'newsapi.org',
      '/v2/top-headlines',
      {
        'country': 'in', // Country code for India.
        'category': category,
        'page': page.toString(),
        'pageSize': pageSize.toString(),
        'apiKey': _apiKey,
      },
    ));

    // Checks if the response status code is successful (200).
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Checks if the response contains 'articles' and it's a List.
      if (data.containsKey('articles') && data['articles'] is List) {
        // Maps each article JSON object to an Article model instance and returns a List of articles.
        return (data['articles'] as List)
            .map((articleJson) => Article.fromJson(articleJson))
            .toList();
      } else {
        throw Exception(
            'No articles found'); // Throws an exception if no articles are found.
      }
    } else {
      throw Exception(
          'Failed to load articles'); // Throws an exception if the HTTP request fails.
    }
  }

  /// Searches for articles based on a query string.
  Future<List<Article>> searchArticles(String query,
      {int page = 1, int pageSize = 20}) async {
    await _initialize(); // Ensures apiKey is initialized before searching articles.

    // Makes an HTTP GET request to search for articles based on query and pagination parameters.
    final response = await http.get(Uri.https(
      'newsapi.org',
      '/v2/everything',
      {
        'q': query, // Query string parameter.
        'page': page.toString(), // Converts page number to string.
        'pageSize': pageSize.toString(), // Converts pageSize to string.
        'apiKey': _apiKey, // Passes API key for authentication.
      },
    ));

    // Checks if the response status code is successful (200).
    if (response.statusCode == 200) {
      final data =
          json.decode(response.body); // Decodes JSON response body into a Map.

      // Checks if the response contains 'articles' and it's a List.
      if (data.containsKey('articles') && data['articles'] is List) {
        // Maps each article JSON object to an Article model instance and returns a List of articles.
        return (data['articles'] as List)
            .map((articleJson) => Article.fromJson(articleJson))
            .toList();
      } else {
        throw Exception(
            'No articles found'); // Throws an exception if no articles are found.
      }
    } else {
      throw Exception(
          'Failed to search articles'); // Throws an exception if the HTTP request fails.
    }
  }
}
