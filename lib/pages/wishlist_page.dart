import 'package:flutter/material.dart';
import 'package:ombe/pages/product_detail_pages.dart';
import '../models/product_model.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  static final List<Map<String, dynamic>> _wishlistItems = [
    {
      'imageUrl': 'assets/images/featured_1.jpg',
      'title': 'Brown Hand Watch',
      'variant': 'White Stripes',
      'price': '69.4'
    },
    {
      'imageUrl': 'assets/images/featured_2.jpg',
      'title': 'Possil Leather Watch',
      'variant': 'White Stripes',
      'price': '79.4'
    },
    {
      'imageUrl': 'assets/images/featured_3.jpg',
      'title': 'Super Red Naiki Shoes',
      'variant': 'Red Edition',
      'price': '99.9'
    },
    {
      'imageUrl': 'assets/images/featured_4.jpg',
      'title': 'Elegant Silver Watch',
      'variant': 'Metal Strap',
      'price': '88.0'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Wishlist',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _wishlistItems.length,
                itemBuilder: (context, index) {
                  final item = _wishlistItems[index];
                  return _WishlistItemCard(
                    imageUrl: item['imageUrl'],
                    title: item['title'],
                    variant: item['variant'],
                    price: item['price'],
                    onTap: () {
                      final product = Product(
                        name: item['title'],
                        price: double.parse(item['price']),
                        oldPrice: double.parse(item['price']) + 10,
                        imagePath: item['imageUrl'],
                        rating: 4.5,
                        points: 50,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailPage(product: product),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search Here',
        hintStyle: TextStyle(color: Colors.grey[500]),
        prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _WishlistItemCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String variant;
  final String price;
  final VoidCallback onTap;

  const _WishlistItemCard({
    required this.imageUrl,
    required this.title,
    required this.variant,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shadowColor: Colors.grey[50],
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[200],
                      child:
                          Icon(Icons.broken_image, color: Colors.grey[600]),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),

              // Info Produk
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Variant: $variant',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$$price',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.favorite, color: Color(0xFFF44336)),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
