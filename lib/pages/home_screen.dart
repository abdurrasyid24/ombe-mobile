import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ombe/pages/my_cart_screen.dart';
import 'package:ombe/pages/notifications_page.dart';
import 'package:ombe/services/auth_services.dart';
import 'package:ombe/services/notification_service.dart';
import 'package:ombe/widgets/home_navbar.dart';
import '../models/product_model.dart';
import '../models/product_api_model.dart';
import '../models/category_model.dart';
import '../services/cart_service.dart';
import '../api/product_api.dart';
import 'product_detail_pages.dart';
import 'products_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  static const Color kGreen = Color(0xFF1E6B4C);
  static const Color kSearchBg = Color(0xFFF3F3F3);

  final AuthService _authService = AuthService();
  final NotificationService _notificationService = NotificationService();
  String _displayName = '';
  List<ProductApi> _featuredProducts = [];
  List<ProductApi> _beverageProducts = [];
  bool _isLoading = true;
  int _unreadNotificationCount = 0;

  // Auto refresh timer
  static const Duration _refreshInterval = Duration(seconds: 30);
  DateTime? _lastRefresh;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUser();
    _loadProducts();
    _checkNewNotifications();
    _lastRefresh = DateTime.now();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Auto refresh when app comes back to foreground
    if (state == AppLifecycleState.resumed) {
      final now = DateTime.now();
      if (_lastRefresh == null ||
          now.difference(_lastRefresh!) > _refreshInterval) {
        _refreshAll();
      }
    }
  }

  Future<void> _refreshAll() async {
    _lastRefresh = DateTime.now();
    await Future.wait([_loadProducts(), _checkNewNotifications()]);
  }

  Future<void> _checkNewNotifications() async {
    final count = await _notificationService.getUnreadCount();
    if (!mounted) return;

    setState(() {
      _unreadNotificationCount = count;
    });

    if (count > 0) {
      final result = await _notificationService.getNotifications();
      if (result['success'] == true && mounted) {
        final notifications = result['data'] as List<NotificationItem>;
        final unreadNotifications = notifications
            .where((n) => !n.isRead)
            .toList();

        if (unreadNotifications.isNotEmpty) {
          final latest = unreadNotifications.first;
          _showNotificationPopup(latest, count);
        }
      }
    }
  }

  void _showNotificationPopup(NotificationItem notification, int totalUnread) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.notifications_active,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    notification.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    totalUnread > 1
                        ? 'You have $totalUnread new notifications'
                        : notification.message,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: kGreen,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        action: SnackBarAction(
          label: 'VIEW',
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationsPage(),
              ),
            ).then((_) => _checkNewNotifications());
          },
        ),
      ),
    );
  }

  Future<void> _loadUser() async {
    final user = await _authService.getUser();
    if (!mounted) return;
    setState(() {
      _displayName =
          user?['fullName']?.toString() ??
          user?['username']?.toString() ??
          'Guest';
    });
  }

  Future<void> _loadProducts() async {
    try {
      print('Loading products from API...');
      final featured = await ProductApiService.getFeaturedProducts();
      print('Featured products loaded: ${featured.length}');
      final beverages = await ProductApiService.getProductsByCategory(
        'Beverages',
      );
      print('Beverage products loaded: ${beverages.length}');
      if (!mounted) return;
      setState(() {
        _featuredProducts = featured;
        _beverageProducts = beverages;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading products: $e');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      // Show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load products: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: HomeNavbar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshAll,
          color: kGreen,
          child: CustomScrollView(
            clipBehavior: Clip.none,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Good Morning',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _displayName.isEmpty ? '...' : _displayName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Notification Bell with Badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const NotificationsPage(),
                                ),
                              ).then((_) => _checkNewNotifications());
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Icon(
                                Icons.notifications_outlined,
                                color: kGreen,
                                size: 26,
                              ),
                            ),
                          ),
                          if (_unreadNotificationCount > 0)
                            Positioned(
                              right: 2,
                              top: 2,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Text(
                                  _unreadNotificationCount > 9
                                      ? '9+'
                                      : '${_unreadNotificationCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      // Orders Icon with Cart Badge
                      Consumer<CartService>(
                        builder: (context, cart, child) {
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const MyCartScreen(),
                                    ),
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Icon(
                                    Icons.shopping_bag_outlined,
                                    color: kGreen,
                                    size: 26,
                                  ),
                                ),
                              ),
                              if (cart.itemCount > 0)
                                Positioned(
                                  right: 2,
                                  top: 2,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: kGreen,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 18,
                                      minHeight: 18,
                                    ),
                                    child: Text(
                                      '${cart.itemCount}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      Builder(
                        builder: (ctx) => InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () => Scaffold.of(ctx).openDrawer(),
                          child: const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: _OmbeMenuIcon(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: kSearchBg,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: const [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search beverages or foods',
                              hintStyle: TextStyle(
                                color: Color(0xFFB0B0B0),
                                fontSize: 13.5,
                              ),
                              border: InputBorder.none,
                              isCollapsed: true,
                            ),
                          ),
                        ),
                        Icon(Icons.search, color: Color(0xFFB0B0B0), size: 22),
                      ],
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 60)),
              SliverToBoxAdapter(
                child: _isLoading
                    ? const SizedBox(
                        height: 260,
                        child: Center(
                          child: CircularProgressIndicator(color: kGreen),
                        ),
                      )
                    : _featuredProducts.isEmpty
                    ? const SizedBox(
                        height: 260,
                        child: Center(child: Text('No featured products')),
                      )
                    : SizedBox(
                        height: 260,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          clipBehavior: Clip.none,
                          itemCount: _featuredProducts.take(4).length,
                          itemBuilder: (context, index) {
                            final p = _featuredProducts[index];
                            final product = Product.fromApi(p);
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ProductDetailPage(product: product),
                                  ),
                                );
                              },
                              child: _heroProductCard(
                                title: product.name,
                                price: product.price,
                                oldPrice: product.oldPrice,
                                imagePath: product.imagePath,
                                isFirst: index == 0,
                              ),
                            );
                          },
                        ),
                      ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 22)),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 14)),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: dummyCategories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final c = dummyCategories[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductsScreen(initialCategory: c.label),
                            ),
                          );
                        },
                        child: _categoryCard(c),
                      );
                    },
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Text(
                        'Featured Beverages',
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductsScreen(initialCategory: 'Beverages'),
                            ),
                          );
                        },
                        child: const Text(
                          'More',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            color: kGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 14)),
              SliverList(
                delegate: SliverChildListDelegate([
                  Column(
                    children: _beverageProducts.map((apiProduct) {
                      final product = Product.fromApi(apiProduct);
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailPage(product: product),
                            ),
                          );
                        },
                        child: _featuredItem(
                          imagePath: product.imagePath,
                          name: product.name,
                          price: product.price,
                          points: product.points,
                          rating: product.rating,
                        ),
                      );
                    }).toList(),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heroProductCard({
    required String title,
    required double price,
    required double oldPrice,
    required String imagePath,
    bool isFirst = false,
  }) {
    const double cardWidth = 195.0;
    const double cardHeight = 240.0;

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.only(right: 14),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: cardHeight,
            decoration: BoxDecoration(
              color: kGreen,
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          Positioned(
            top: -40,
            left: 10,
            right: 10,
            child: imagePath.startsWith('http')
                ? Image.network(imagePath, width: 180, fit: BoxFit.contain)
                : Image.asset(imagePath, width: 180, fit: BoxFit.contain),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '\$${price.toStringAsFixed(1)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '\$${oldPrice.toStringAsFixed(1)}',
                          style: const TextStyle(
                            color: Colors.white70,
                            decoration: TextDecoration.lineThrough,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryCard(Category c) {
    return Container(
      width: 155,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E5E5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(c.icon, color: kGreen, size: 26),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  c.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${c.count} Menus',
                  style: const TextStyle(
                    color: kGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _featuredItem({
    required String imagePath,
    required String name,
    required double price,
    required int points,
    required double rating,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: imagePath.startsWith('http')
                    ? Image.network(
                        imagePath,
                        width: 88,
                        height: 120,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        imagePath,
                        width: 88,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
              ),
              Positioned(
                bottom: -8,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4A259),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.white, size: 12),
                        const SizedBox(width: 2),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '\$${price.toStringAsFixed(1)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$points Pts',
                style: const TextStyle(
                  color: kGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OmbeMenuIcon extends StatelessWidget {
  const _OmbeMenuIcon();

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF606060);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 12,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 24,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
      ],
    );
  }
}
