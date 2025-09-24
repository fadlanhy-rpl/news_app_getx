import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
// import 'package:news_app/data/dummy_data.dart';
// import 'package:news_app/screens/detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:news_app_getx/api/api.dart';
import 'package:news_app_getx/screens/detail.dart';
// import 'package:news_app/screens/search_screen.dart';

class ScreenApi1 extends StatefulWidget {
  const ScreenApi1({super.key});

  @override
  State<ScreenApi1> createState() => _ScreenApi1State();
}

class _ScreenApi1State extends State<ScreenApi1> {
  final _selectedCategory = ''.obs;
  // final _selectedBottomIndex = 0.obs;
  PageController _pageController = PageController();

  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allNews = [];
  List<Map<String, dynamic>> _filterNews = [];
  final isLoading = false.obs;

  List<Map<String, dynamic>> get breakingNews {
    return _allNews.take(3).toList();
  }

  List<Map<String, dynamic>> get recommendationNews {
    return _allNews.skip(3).take(5).toList();
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

  Widget buttonCategory(String label, String category) {
    return GestureDetector(
      onTap: () {
        _selectedCategory.value = category;
        fetchNews(category);
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: _selectedCategory == category ? Colors.blue : Colors.grey[100],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: _selectedCategory == category
                ? Colors.white
                : Colors.grey[700],
            fontWeight: _selectedCategory == category
                ? FontWeight.w600
                : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd MM yyyy, HH:mm').format(dateTime);
  }

  String getRelativeTime(String date) {
    DateTime dateTime = DateTime.parse(date);
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.menu, size: 28, color: Colors.grey[800]),
                  Text(
                    'SkyNews',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Row(
                    children: [
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

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Breaking News',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            'View all',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    Container(
                      height: 200,
                      child: isLoading.value
                          ? Center(child: CircularProgressIndicator())
                          : PageView.builder(
                              controller: _pageController,
                              itemCount: breakingNews.length,
                              itemBuilder: (context, index) {
                                final item = breakingNews[index];
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 16),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SportsNewsScreen(
                                                newsDetail: item,
                                              ),
                                        ),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Stack(
                                        children: [
                                          Image.network(
                                            item['image']['small'],
                                            height: 200,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black.withOpacity(0.7),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 16,
                                            left: 16,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                getCategoryFromTitle(
                                                  item['title'],
                                                ),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 16,
                                            left: 16,
                                            right: 16,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item['title'],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 6,
                                                            vertical: 2,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        'LIVE',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      'Trending • ${getRelativeTime(item['isoDate'])}',
                                                      style: TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
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

                    SizedBox(height: 32),

                    SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 16),
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

                    SizedBox(height: 24),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recommendation',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            'View all',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            itemCount: recommendationNews.length,
                            itemBuilder: (context, index) {
                              final item = recommendationNews[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SportsNewsScreen(newsDetail: item),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 16),
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 6,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          item['image']['small'],
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.blue.withOpacity(
                                                  0.1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                getCategoryFromTitle(
                                                  item['title'],
                                                ),
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 6),
                                            Text(
                                              item['title'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: Colors.grey[800],
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time,
                                                  size: 12,
                                                  color: Colors.grey[500],
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  getRelativeTime(
                                                    item['isoDate'],
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.grey[500],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
