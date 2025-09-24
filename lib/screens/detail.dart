import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

class SportsNewsScreen extends StatefulWidget {
  final Map<String, dynamic> newsDetail;
  const SportsNewsScreen({super.key, required this.newsDetail});

  @override
  State<SportsNewsScreen> createState() => _SportsNewsScreenState();
}

class _SportsNewsScreenState extends State<SportsNewsScreen> {
  bool isBookmarked = false;

  String formatTimeAgo(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
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

  String getCategoryFromLink(String link) {
    if (link.contains('olahraga')) return 'Sports';
    if (link.contains('teknologi')) return 'Technology';
    if (link.contains('ekonomi')) return 'Economy';
    if (link.contains('internasional')) return 'International';
    if (link.contains('nasional')) return 'Nasional';
    if (link.contains('hiburan')) return 'Entertainment';
    if (link.contains('gaya-hidup')) return 'Lifestyle';
    return 'News';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Hero Image Section with Overlay
          Flexible(
            flex: 60,
            child: Container(
              decoration:  BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.newsDetail['image']['small']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      // Top Navigation Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isBookmarked = !isBookmarked;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Icon(
                                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    // Show share options
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(
                                      Icons.more_horiz,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Article Info Overlay
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Sports Category Tag
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E88E5),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                getCategoryFromLink(widget.newsDetail['link']),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Article Title
                             Text(
                              widget.newsDetail['title'],
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Trending and Time
                            Row(
                              children: [
                                const Text(
                                  'Trending',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: const BoxDecoration(
                                    color: Colors.white70,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                 Text(
                                  '• ${formatTimeAgo(widget.newsDetail['isoDate'])}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white70,
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
            ),
          ),
          
          // Article Content Section
          Flexible(
            flex: 40,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CNN Indonesia Logo and Verified Badge
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCC0000),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'CNN',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'CNN Indonesia',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.verified,
                        size: 16,
                        color: Color(0xFF1DA1F2),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Article Content
                   Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.newsDetail['contentSnippet'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF333333),
                              height: 1.6,
                            ),
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                  
                  // Action Buttons
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ActionButton(
                        icon: Icons.thumb_up_outlined,
                        label: 'Like',
                        onTap: () {},
                      ),
                      _ActionButton(
                        icon: Icons.comment_outlined,
                        label: 'Comment',
                        onTap: () {},
                      ),
                      _ActionButton(
                        icon: Icons.share_outlined,
                        label: 'Share',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE0E0E0)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: const Color(0xFF666666),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
