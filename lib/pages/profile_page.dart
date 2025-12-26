import 'package:flutter/material.dart';
import '../models/order_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const kGreen = Color(0xFF1E6B4C);
  static const kGrey = Color(0xFF9FA5B0);

  List<_MostItem> _buildMostOrdered() {
    final Map<String, int> count = {};
    for (final o in dummyOrders) {
      // Calculate total items from order
      count[o.firstProductName] = (count[o.firstProductName] ?? 0) + o.totalItems;
    }
    final items =
        count.entries.map((e) => _MostItem(name: e.key, qty: e.value)).toList()
          ..sort((a, b) => b.qty.compareTo(a.qty));
    return items.take(10).toList();
  }

  String _img(String name) {
    final n = name.toLowerCase();
    if (n.contains('lemon')) return 'assets/images/featured_1.jpg';
    if (n.contains('mocha')) return 'assets/images/featured_2.jpg';
    if (n.contains('latte')) return 'assets/images/cup_3.png';
    if (n.contains('cappu')) return 'assets/images/cup_2.png';
    if (n.contains('espresso')) return 'assets/images/cup_1.png';
    return 'assets/images/cup_1.png';
  }

  @override
  Widget build(BuildContext context) {
    final most = _buildMostOrdered();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
        children: [
          Center(
            child: Column(
              children: const [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                    'assets/images/profile_avatar.jpg',
                  ),
                ),
                SizedBox(height: 18),
                Text(
                  'William Smith',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'London, England',
                  style: TextStyle(
                    color: kGreen,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          _ContactTile(
            icon: Icons.call,
            title: 'Mobile Phone',
            value: '+12 345 678 92',
          ),
          const SizedBox(height: 20),
          _ContactTile(
            icon: Icons.email_outlined,
            title: 'Email Address',
            value: 'example@gmail.com',
          ),
          const SizedBox(height: 20),
          _ContactTile(
            icon: Icons.location_on_outlined,
            title: 'Address',
            value: 'Franklin Avenue, Corner St.\nLondon, 24125151',
          ),
          const SizedBox(height: 32),
          const Text(
            'Most Ordered',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 156,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: most.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, i) {
                final m = most[i];
                return Container(
                  width: 300,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kGreen,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 92,
                        height: 92,
                        child: Image.asset(_img(m.name), fit: BoxFit.contain),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'Beverages',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.open_in_new,
                                  size: 16,
                                  color: Colors.white70,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ContactTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  static const kGreen = Color(0xFF1E6B4C);
  static const kGrey = Color(0xFF9FA5B0);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(child: Icon(icon, color: kGreen, size: 28)),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: kGrey,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MostItem {
  final String name;
  final int qty;
  const _MostItem({required this.name, required this.qty});
}
