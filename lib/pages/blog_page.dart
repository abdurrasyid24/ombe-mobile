import 'dart:ui';
import 'package:flutter/material.dart';
import 'blog_detail_page.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final TextEditingController _searchC = TextEditingController();

  static const Color kGreen = Color(0xFF1E6B4C);
  static const EdgeInsets kScreenPad = EdgeInsets.symmetric(horizontal: 16);

  final List<String> tags = const [
    'Coffee',
    'Black Coffee',
    'Cappuccino',
    'Espresso',
    'Cold brew',
    'Affogato',
    'Latte',
    'Americano',
  ];

  final List<Map<String, String>> posts = const [
    {
      'title': "Nature's Ingredients",
      'author': 'Admin',
      'date': 'October 4, 2022',
      'image': 'assets/images/blog_1.jpg',
      'content':
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
    },
    {
      'title': "Nature's Ingredients",
      'author': 'Admin',
      'date': 'September 3, 2022',
      'image': 'assets/images/blog_2.jpg',
      'content':
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. It has survived not only five centuries, but also the leap into electronic typesetting.',
    },
    {
      'title': "Nature's Ingredients",
      'author': 'Admin',
      'date': 'October 1, 2022',
      'image': 'assets/images/blog_3.jpg',
      'content':
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. It has survived not only five centuries, but also the leap into electronic typesetting.',
    },
  ];

  void _openDetail(Map<String, String> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlogDetailPage(
          title: data['title'] ?? '',
          imagePath: data['image'] ?? '',
          content: data['content'] ?? '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filterPosts();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Blog',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: kScreenPad,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F5F7),
                borderRadius: BorderRadius.circular(28),
              ),
              child: TextField(
                controller: _searchC,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: kScreenPad,
            child: const Text(
              'Blog Tags',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: kScreenPad,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: tags.map((t) {
                return GestureDetector(
                  onTap: () => _openDetail(posts.first),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: kGreen,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Text(
                      t,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          ListView.builder(
            itemCount: filtered.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, i) {
              final p = filtered[i];
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: GestureDetector(
                  onTap: () => _openDetail(p),
                  child: _PostCard(
                    imagePath: p['image']!,
                    title: p['title']!,
                    subtitle: 'By ${p['author']} ${p['date']}',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> _filterPosts() {
    final q = _searchC.text.trim().toLowerCase();
    if (q.isEmpty) return posts;
    return posts.where((p) {
      return (p['title'] ?? '').toLowerCase().contains(q) ||
          (p['author'] ?? '').toLowerCase().contains(q);
    }).toList();
  }
}

class _PostCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;

  const _PostCard({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width - 32;
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final cacheW = (w * dpr).round();

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                cacheWidth: cacheW,
                filterQuality: FilterQuality.low,
                gaplessPlayback: true,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
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
