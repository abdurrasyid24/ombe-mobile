import 'package:flutter/material.dart';
import 'package:ombe/pages/massage_page.dart';
import 'package:ombe/pages/my_orders_screen.dart';
import 'package:ombe/pages/blog_page.dart';
import 'package:ombe/pages/notifications_page.dart';
import 'package:ombe/pages/profile_page.dart';
import 'package:ombe/pages/checkout/tracking_order_page.dart';
import 'package:ombe/pages/order_review_page.dart';
import 'package:ombe/pages/rewards_page.dart';
import 'package:ombe/pages/stores_location_page.dart';
import 'package:ombe/pages/wishlist_page.dart';
import 'package:ombe/pages/products_screen.dart';
import 'package:ombe/services/auth_services.dart';
import 'package:ombe/pages/login_screen.dart';

class HomeNavbar extends StatelessWidget {
  const HomeNavbar({super.key});

  static const kGreen = Color(0xFF1E6B4C);
  static const kGrey = Color(0xFF9FA5B0);
  static const kSoftGrey = Color(0xFFE9ECEF);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/coffee_logo.png',
                    width: 60,
                    height: 60,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Ombe',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _NavItem(
                      icon: Icons.home_outlined,
                      title: 'Home',
                      active: true,
                    ),
                    _NavItem(
                      icon: Icons.shopping_bag_outlined,
                      title: 'My Order',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyOrdersScreen(),
                          ),
                        );
                      },
                    ),
                    _NavItem(
                      icon: Icons.inventory_2_outlined,
                      title: 'Products',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductsScreen(
                              initialCategory: 'Beverages',
                            ),
                          ),
                        );
                      },
                    ),
                    _NavItem(
                      icon: Icons.description_outlined,
                      title: 'Blog',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BlogPage(),
                          ),
                        );
                      },
                    ),
                    _NavItem(
                      icon: Icons.favorite_border,
                      title: 'Wishlist',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WishlistScreen(),
                          ),
                        );
                      },
                    ),
                    _NavItem(
                      icon: Icons.notifications_none,
                      title: 'Notifications (2)',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsPage(),
                          ),
                        );
                      },
                    ),
                    _NavItem(
                      icon: Icons.location_on_outlined,
                      title: 'Store Locations',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OurStoresScreen(),
                          ),
                        );
                      },
                    ),
                    _NavItem(
                      icon: Icons.access_time,
                      title: 'Delivery Tracking',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TrackingOrderPage(),
                          ),
                        );
                      },
                    ),
                    _NavItem(
                      icon: Icons.store_mall_directory_outlined,
                      title: 'Rewards',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RewardsPage(),
                          ),
                        );
                      },
                    ),
                    _NavItem(
                      icon: Icons.person_outline,
                      title: 'Profile',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(),
                          ),
                        );
                      },
                    ),
                    _NavItem(
                      icon: Icons.star_border,
                      title: 'Order Review',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderReviewPage(),
                          ),
                        );
                      },
                    ),
                    _NavItem(
                      icon: Icons.message_outlined,
                      title: 'Message',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MassagePage(),
                          ),
                        );
                      },
                    ),
                    const _NavItem(
                      icon: Icons.grid_view_outlined,
                      title: 'Elements',
                    ),
                    const _NavItem(
                      icon: Icons.settings_outlined,
                      title: 'Setting',
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1, color: HomeNavbar.kSoftGrey),

            _NavItem(
              icon: Icons.power_settings_new,
              title: 'Logout',
              color: Colors.red,
              onTap: () async {
                final authService = AuthService();
                await authService.logout();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 0, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Ombe Coffee App',
                    style: TextStyle(
                      color: HomeNavbar.kGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'App Version 1.3',
                    style: TextStyle(color: Color(0xFFCBD0D5), fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool active;
  final Color? color;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.title,
    this.active = false,
    this.color,
    this.onTap,
  });

  static const kGreen = Color(0xFF1E6B4C);
  static const kGrey = Color(0xFF9FA5B0);

  @override
  Widget build(BuildContext context) {
    final c = color ?? (active ? kGreen : kGrey);
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
      leading: Icon(icon, color: c, size: 22),
      horizontalTitleGap: 12,
      minLeadingWidth: 28,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15.5,
          color: c,
          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
