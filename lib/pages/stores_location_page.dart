import 'package:flutter/material.dart';
import 'package:ombe/pages/store_location_detail.dart';

const Color kDarkGreen = Color(0xFF1E6B4C);
const Color kBorderGrey = Color(0xFFE0E0E0);
const Color kTextGrey = Color(0xFF616161);

class OurStoresScreen extends StatelessWidget {
  const OurStoresScreen({super.key});

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
          'Our Stores',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search address',
              prefixIcon: Icon(Icons.search, color: kTextGrey),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: kBorderGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: kDarkGreen),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildFilterChip(text: 'Near Me', active: true),
              const SizedBox(width: 12),
              _buildFilterChip(text: 'Popular', active: false),
              const SizedBox(width: 12),
              _buildFilterChip(text: 'Top Rated', active: false),
            ],
          ),
          const SizedBox(height: 24),
          Text.rich(
            TextSpan(
              text: 'We have ',
              style: const TextStyle(color: kTextGrey, fontSize: 16),
              children: [
                TextSpan(
                  text: '46 Outlets',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const TextSpan(text: ' ready to serve you'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _StoreCard(
            imagePath: 'assets/images/toko_1.jpg',
            storeName: 'Centre Point Flaza',
            hours: '09:00 AM - 10:00 PM',
            distance: '3,5 Km',
          ),
          _StoreCard(
            imagePath: 'assets/images/toko_2.jpg',
            storeName: 'Kuningan City',
            hours: '10:00 AM - 09:00 PM',
            distance: '5,1 Km',
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({required String text, bool active = false}) {
    return ChoiceChip(
      label: Text(text),
      selected: active,
      onSelected: (selected) {},
      backgroundColor: active ? kDarkGreen : Colors.white,
      selectedColor: kDarkGreen,
      labelStyle: TextStyle(
        color: active ? Colors.white : kDarkGreen,
        fontWeight: FontWeight.w600,
      ),
      shape: StadiumBorder(
        side: BorderSide(color: active ? kDarkGreen : kBorderGrey),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
    );
  }
}

class _StoreCard extends StatelessWidget {
  final String imagePath;
  final String storeName;
  final String hours;
  final String distance;

  const _StoreCard({
    required this.imagePath,
    required this.storeName,
    required this.hours,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16.0),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 3,
      shadowColor: Colors.grey.withOpacity(0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                imagePath,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 160,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.storefront, color: Colors.grey, size: 50),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 12,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StoreLocationDetailPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.directions, size: 18),
                  label: const Text('Directions'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      storeName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hours,
                      style: const TextStyle(fontSize: 14, color: kTextGrey),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: kDarkGreen, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      distance,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
