import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:news_app/models/article_model.dart';
import 'package:news_app/reusables/constants.dart';
import 'package:news_app/reusables/drawer.dart';
import 'package:news_app/screens/news_detail_screen.dart';
import 'package:news_app/services/news_service.dart';
import 'package:news_app/reusables/dropdown_menu_button.dart';


/// The main screen displaying a list of news articles.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsService _newsService = NewsService(); // Service for fetching news data
  List<Article> _articles = []; // List to store fetched articles
  bool _isLoading = true; // Flag indicating if data is loading
  bool _isFetchingMore = false; // Flag indicating if more data is being fetched
  String _selectedCategory = 'general'; // Currently selected news category
  final TextEditingController _searchController = TextEditingController(); // Controller for search input
  bool _showSearchResults = false; // Flag indicating if search results should be shown
  int _currentPage = 1; // Current page of news articles being fetched
  final int _pageSize = 20; // Number of articles per page

  @override
  void initState() {
    super.initState();
    _fetchTopHeadlines(); // Fetch top headlines when HomeScreen initializes
  }

  /// Fetches top headlines from the news service.
  Future<void> _fetchTopHeadlines({bool loadMore = false}) async {
    setState(() {
      if (!loadMore) {
        _isLoading = true;
        _articles
            .clear(); // Clear existing articles when refreshing or searching
        _currentPage = 1; // Reset page to 1 when refreshing or searching
      } else {
        _isFetchingMore = true; // Set fetching more flag
        _currentPage++; // Increment page for fetching more
      }
    });

    try {
      final articles = await _newsService.fetchArticles(
        _selectedCategory,
        page: _currentPage,
        pageSize: _pageSize,
      );

      setState(() {
        if (loadMore) {
          _articles.addAll(articles.where(_isValidArticle)); // Add fetched articles to the list
        } else {
          _articles = articles.where(_isValidArticle).toList(); // Set fetched articles
          _showSearchResults = false; // Reset to show top headlines
        }
        _isLoading = false;
        _isFetchingMore = false; // Reset fetching more flag
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isFetchingMore = false; // Ensure to reset fetching more flag on error
      });
    }
  }

  /// Searches articles based on the provided query.
  Future<void> _searchArticles(String query) async {
    setState(() {
      _isLoading = true;
      _articles.clear(); // Clear existing articles when starting search
      _currentPage = 1; // Reset page to 1 when starting search
    });

    try {
      final articles = await _newsService.searchArticles(
        query,
        page: _currentPage,
        pageSize: _pageSize,
      );

      setState(() {
        _articles = articles.where(_isValidArticle).toList(); // Set fetched search results
        _isLoading = false;
        _showSearchResults = true; // Set to show search results
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _showSearchResults =
            false; // Ensure to show top headlines if error occurs
      });
    }
  }

  /// Checks if an article is valid based on required fields.
  bool _isValidArticle(Article article) {
    return article.title.isNotEmpty &&
        article.urlToImage.isNotEmpty &&
        article.sourceName.isNotEmpty &&
        article.content.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: const MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          CategoryDropdown(
            selectedCategory: _selectedCategory,
            onChanged: (value) {
              setState(() {
                _selectedCategory = value!;
                _isLoading = true;
              });
              _fetchTopHeadlines();
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSearchInput(),
                const SizedBox(height: 12.0),
                _showSearchResults
                    ? _buildSectionHeader('Search Results')
                    : _buildSectionHeader('Top Headlines'),
              ],
            ),
          ),
          Expanded(
            child: _isLoading && !_isFetchingMore && _articles.isEmpty
                ? _buildLoadingIndicator()
                : _buildArticleList(),
          ),
        ],
      ),
    );
  }

  /// Builds the app bar with logo and title.
  PreferredSizeWidget? _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: 50,
            height: 50,
            fit: BoxFit.contain,
          ),
          Text(
            ' News Now   ',
            style: TextStyle(
              fontFamily:
                  GoogleFonts.oswald(fontWeight: FontWeight.bold).fontFamily,
              fontWeight: FontWeight.bold,
              fontSize: 38,
              color: greyBlack,
            ),
          ),
        ],
      ),
      centerTitle: true,
      elevation: 6.0,
      backgroundColor: Colors.white,
      shadowColor: Colors.black,
    );
  }

  /// Builds the search input field.
  Widget _buildSearchInput() {
    return TextField(
      controller: _searchController,
      cursorColor: greyBlack,
      style: const TextStyle(color: greyBlack),
      decoration: InputDecoration(
        hintText: 'Search...',
        hintStyle: const TextStyle(color: greyBlack),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        prefixIcon: const Icon(Icons.search, color: greyBlack),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear, color: greyBlack),
          onPressed: () {
            _searchController.clear(); // Clears search input field
            setState(() {
              _isLoading = true;
              _currentPage = 1; // Reset page when clearing search
            });
            _fetchTopHeadlines(); // Fetches top headlines after clearing search
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: greyBlack),
        ),
      ),
      onSubmitted: (value) {
        setState(() {
          _isLoading = true;
          _currentPage = 1; // Reset page when submitting search
        });
        _searchArticles(value); // Searches articles based on submitted value
      },
    );
  }

  /// Builds a section header with a specified title.
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily:
            GoogleFonts.notoSans(fontWeight: FontWeight.w900).fontFamily,
        fontWeight: FontWeight.bold,
        fontSize: 30,
        color: greyBlack,
      ),
    );
  }

  /// Builds a loading indicator widget.
  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  /// Builds the list of articles.
  Widget _buildArticleList() {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo is ScrollEndNotification &&
            scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 200 &&
            !_isLoading &&
            !_isFetchingMore) {
          _fetchTopHeadlines(loadMore: true); // Fetches more articles when scrolled to end
        }
        return false;
      },
      child: ListView.builder(
        itemCount: _articles.length + (_isFetchingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _articles.length && _isFetchingMore) {
            return _buildLoadingIndicator(); // Shows loading indicator when fetching more
          }
          final article = _articles[index];
          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            color: cherryWhite,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(
                article.title,
                style: TextStyle(
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.sourceName,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                  Text(
                    DateFormat('dd MMMM, yyyy hh:mm a').format(article.publishedAt),
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
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
                    builder: (context) => NewsDetailScreen(
                      article: article,
                    ),
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
