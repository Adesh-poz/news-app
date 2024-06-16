import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'article_model.g.dart'; // Part of the generated file article_model.g.dart

@HiveType(typeId: 0) // Annotation for Hive to generate adapter for this class
class Article {
  @HiveField(0)
  final String title; // Article title

  @HiveField(1)
  final String author; // Author of the article

  @HiveField(2)
  final String description; // Description of the article

  @HiveField(3)
  final String url; // URL of the article

  @HiveField(4)
  final String urlToImage; // URL to the image associated with the article

  @HiveField(5)
  final String sourceName; // Name of the source of the article

  @HiveField(6)
  final DateTime publishedAt; // Date and time when the article was published

  @HiveField(7)
  final String content; // Main content of the article

  Article({
    required this.title,
    required this.author,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.sourceName,
    required this.publishedAt,
    required this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      // Initialize with JSON data or default values
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      sourceName: json['source']['name'] ?? '',
      publishedAt: DateTime.parse(json['publishedAt'] ?? ''),
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'sourceName': sourceName,
      'publishedAt': DateFormat('dd MMMM, yyyy hh:mm a').format(publishedAt), // Use formatted date string
      'content': content,
    };
  }
}