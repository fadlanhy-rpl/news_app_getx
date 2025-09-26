import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app_getx/api/api.dart';
import 'package:news_app_getx/screens/detail.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  PageController _pageController = PageController();

  final _selectedCategory = ''.obs;

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allNews = [];
  List<Map<String, dynamic>> _filterNews = [];
  final isLoading = false.obs;

  List<Map<String, dynamic>> get breakingNews {
    return _allNews.take(3).toList();
  }

  Future<void> fetchNews(String type) async {
    isLoading.value = true;

    final data = await Api().getApi(category: type);
    setState(() {
      _allNews = data;
      _filterNews = data;
    });
    isLoading.value = false;
  }

  _applySearch(String query) {
    if (query.isEmpty) {
      _filterNews = _allNews;
    } else {
      setState(() {
        _filterNews = _allNews.where((item) {
          final title = item['title'].toString().toLowerCase();
          final snippet = item['contentSnippet'].toString().toLowerCase();
          final search = query.toLowerCase();
          return title.contains(search) || snippet.contains(search);
        }).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNews(_selectedCategory.value);
    _searchController.addListener(() {
      _applySearch(_searchController.text);
    });
  }

  String getCategoryFromTitle(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('olahraga') ||
        lowerTitle.contains('sepak') ||
        lowerTitle.contains('bola')) {
      return 'Sports';
    } else if (lowerTitle.contains('politik') ||
        lowerTitle.contains('pemerintah')) {
      return 'Politics';
    } else if (lowerTitle.contains('ekonomi') ||
        lowerTitle.contains('bisnis')) {
      return 'Business';
    } else if (lowerTitle.contains('teknologi') ||
        lowerTitle.contains('digital')) {
      return 'Technology';
    }
    return 'News';
  }

  Widget buttonCategory(String label, String category) {
    return GestureDetector(
      onTap: () {
        _selectedCategory.value = category;
        fetchNews(category);
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _selectedCategory.value == category
              ? Colors.blue
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            (label),
            style: TextStyle(
              color: _selectedCategory.value == category
                  ? Colors.white
                  : Colors.grey[600],
              fontWeight: _selectedCategory.value == category
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd MM yyyy, HH:mm').format(dateTime);
  }

  bool isBoomarked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.menu, size: 28, color: Colors.grey[800]),
                Row(
                  children: [
                    // Icon(Icons.search, size: 24, color: Colors.grey[600]),
                    // SizedBox(width: 16),
                    Icon(
                      Icons.notifications_outlined,
                      size: 24,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1.0,
                    ),
                  ),
                  // Border saat difokus (diklik)
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 1.0,
                    ), // Beri warna beda saat diklik
                  ),
                  hintText: 'Search any Product..',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: IconButton(
                    onPressed: () {
                      _searchController.clear();
                      _applySearch(_searchController.text);
                    },
                    icon: Icon(Icons.search, color: Colors.grey[400]),
                  ),
                  suffixIcon: Icon(
                    Icons.mic_none_outlined,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(10),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                buttonCategory('semua', ''),
                buttonCategory('nasional', 'nasional'),
                buttonCategory('internasional', 'internasional'),
                buttonCategory('ekonomi', 'ekonomi'),
                buttonCategory('olahraga', 'olahraga'),
                buttonCategory('teknologi', 'teknologi'),
                buttonCategory('hiburan', 'hiburan'),
                buttonCategory('gaya-hidup', 'gaya-hidup'),
              ],
            ),
          ),
          Expanded(
            child: isLoading.value
                ? Center(child: CircularProgressIndicator())
                : _filterNews.isEmpty
                ? Center(child: Text('No news Found'))
                : Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: _filterNews.length,
                      itemBuilder: (context, index) {
                        final item = _filterNews[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailScreen(newsDetail: item, heroTag: 'hero-$index'),
                              ),
                            );
                          },
                          child: Card(
                            margin: EdgeInsets.only(bottom: 16.0),
                            elevation: 2.0,
                            shadowColor: Colors.black.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      item['image']['small'],
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(height: 12),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item['link'],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isBoomarked = !isBoomarked;
                                          });
                                        },
                                        icon: Icon(
                                          isBoomarked
                                              ? Icons.bookmark
                                              : Icons.bookmark_border,
                                        ),
                                        constraints: BoxConstraints(),
                                        padding: EdgeInsets.zero,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),

                                  Text(
                                    item['title'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 2),

                                  Text(
                                    item['contentSnippet'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 12),

                                  Text(
                                    formatDate(item['isoDate']),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
