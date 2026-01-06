import 'package:flutter/material.dart';
import 'package:ombe/pages/checkout/tracking_order_page.dart';
import 'package:ombe/pages/order_detail_page.dart';
import '../models/order_model.dart';
import '../api/order_api.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  static const Color kGreen = Color(0xFF1E6B4C);

  String selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  
  List<Order> _orders = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final orders = await OrderApi.getOrders();
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<Order> get filteredOrders {
    List<Order> orders = _orders;
    final filter = selectedFilter;

    if (filter == 'Done Payment') {
      orders = orders
          .where((o) => o.status.toLowerCase() == 'paid')
          .toList();
    } else if (filter == 'On Delivery') {
      orders = orders
          .where((o) => o.status.toLowerCase() == 'processing' || o.status.toLowerCase() == 'shipped')
          .toList();
    } else if (filter == 'Done') {
      orders = orders
          .where((o) => o.status.toLowerCase() == 'completed')
          .toList();
    }

    if (_searchController.text.isNotEmpty) {
      final q = _searchController.text.toLowerCase();
      orders = orders
          .where((o) => 
              o.firstProductName.toLowerCase().contains(q) ||
              o.orderNumber.toLowerCase().contains(q))
          .toList();
    }
    return orders;
  }

  // ... (popups) ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... (AppBar) ...
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Orders',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black87),
            onPressed: _loadOrders,
          ),
          // IconButton(
          //   icon: const Icon(Icons.more_vert, color: Colors.black87),
          //   onPressed: _openLeftSidePopupMenu,
          // ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: kGreen))
          : _error != null
              ? Center(
                  child: Column(
                     // ... error UI
                     children: [
                       const Text('Error loading orders'),
                       ElevatedButton(onPressed: _loadOrders, child: const Text('Retry'))
                     ]
                  )
                ) // Simplified for brevity in tool call, standard error UI remains if not replacing chunks
              : Column(
        children: [
          // ... Search Bar ...
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: const Color(0xFFF6F6F6),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: 'Search Order ID or Product',
                        hintStyle: TextStyle(
                          color: Colors.black38,
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                    ),
                  ),
                  const Icon(Icons.search, color: Colors.black45, size: 24),
                ],
              ),
            ),
          ),

          // Filter buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildFilterButton('All'),
                const SizedBox(width: 10),
                _buildFilterButton('Done Payment'),
                const SizedBox(width: 10),
                _buildFilterButton('On Delivery'),
                const SizedBox(width: 10),
                _buildFilterButton('Done'),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          Expanded(
            child: filteredOrders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No orders found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 110),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderDetailPage(order: order),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 22),
                          child: Row(
                            children: [
                               // ... Image ...
                               ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: order.items.isNotEmpty && order.items.first.productImage != null
                                    ? Image.network(
                                        order.items.first.productImage!,
                                        width: 80, height: 80, fit: BoxFit.cover,
                                        errorBuilder: (_,__,___) => Container(width:80, height:80, color:Colors.grey[200]),
                                      )
                                    : Container(width: 80, height: 80, color: Colors.grey[200], child: const Icon(Icons.local_cafe)),
                               ),
                               const SizedBox(width: 18),
                               Expanded(
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text(order.orderNumber, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54)),
                                     const SizedBox(height: 4),
                                     Text(order.firstProductName, style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700, color: Colors.black), maxLines: 1),
                                     const SizedBox(height: 6),
                                     Text('${order.totalItems} items', style: const TextStyle(fontSize: 14, color: Colors.black45)),
                                   ],
                                 ),
                               ),
                               Column(
                                 crossAxisAlignment: CrossAxisAlignment.end,
                                 children: [
                                   Container(
                                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                     decoration: BoxDecoration(
                                       color: _getStatusColor(order.status).withOpacity(0.1),
                                       borderRadius: BorderRadius.circular(12),
                                     ),
                                     child: Text(
                                       order.status.toUpperCase().replaceAll('_', ' '),
                                       style: TextStyle(
                                         fontSize: 11,
                                         fontWeight: FontWeight.w600,
                                         color: _getStatusColor(order.status),
                                       ),
                                     ),
                                   ),
                                   const SizedBox(height: 8),
                                   Text('\$${order.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: kGreen)),
                                 ],
                               ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
        child: SizedBox(
          height: 60,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TrackingOrderPage()), // This might need logic to pass current order? It seems global tracking.
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              elevation: 0,
            ),
            child: const Text(
              'TRACK ORDER',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: 0.2,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // void _openLeftSidePopupMenu() {
  //   showGeneralDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     barrierLabel: 'Menu',
  //     barrierColor: Colors.black54,
  //     pageBuilder: (context, anim1, anim2) {
  //       return SafeArea(
  //         child: Align(
  //           alignment: Alignment.centerLeft,
  //           child: SizedBox(
  //             width: MediaQuery.of(context).size.width * 0.75,
  //             height: MediaQuery.of(context).size.height,
  //             child: Material(
  //               color: Colors.white,
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   // Header: Logo Ombe + tombol close
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(
  //                       horizontal: 20,
  //                       vertical: 16,
  //                     ),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Row(
  //                           children: const [
  //                             Icon(Icons.local_cafe, color: kGreen, size: 28),
  //                             SizedBox(width: 8),
  //                             Text(
  //                               'Ombe',
  //                               style: TextStyle(
  //                                 fontWeight: FontWeight.w900,
  //                                 fontSize: 22,
  //                                 color: kGreen,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         IconButton(
  //                           icon: const Icon(
  //                             Icons.close,
  //                             color: Colors.black87,
  //                           ),
  //                           onPressed: () => Navigator.of(context).pop(),
  //                         ),
  //                       ],
  //                     ),
  //                   ),

  //                   const Divider(height: 1, thickness: 1),

  //                   Expanded(
  //                     child: ListView(
  //                       padding: const EdgeInsets.symmetric(vertical: 12),
  //                       children: [
  //                         _buildMenuItem(
  //                           icon: Icons.home_outlined,
  //                           label: 'Home',
  //                         ),
  //                         _buildMenuItem(
  //                           icon: Icons.shopping_bag_outlined,
  //                           label: 'My Order',
  //                         ),
  //                         _buildMenuItem(
  //                           icon: Icons.menu_book_outlined,
  //                           label: 'Blog',
  //                         ),
  //                         _buildMenuItem(
  //                           icon: Icons.article_outlined,
  //                           label: 'Blog Detail',
  //                         ),
  //                         _buildMenuItem(
  //                           icon: Icons.favorite_border,
  //                           label: 'Wishlist',
  //                           isDisabled: true,
  //                         ),
  //                         _buildMenuItem(
  //                           icon: Icons.notifications_none,
  //                           label: 'Notifications (2)',
  //                           isDisabled: true,
  //                         ),
  //                         _buildMenuItem(
  //                           icon: Icons.store_mall_directory_outlined,
  //                           label: 'Store Locations',
  //                           isDisabled: true,
  //                         ),
  //                         _buildMenuItem(
  //                           icon: Icons.local_shipping_outlined,
  //                           label: 'Delivery Tracking',
  //                           isDisabled: true,
  //                         ),
  //                         _buildMenuItem(
  //                           icon: Icons.card_giftcard_outlined,
  //                           label: 'Rewards',
  //                           isDisabled: true,
  //                         ),
  //                         _buildMenuItem(
  //                           icon: Icons.person_outline,
  //                           label: 'Profile',
  //                           isDisabled: true,
  //                         ),
  //                         _buildMenuItem(
  //                           icon: Icons.star_border,
  //                           label: 'Order Review',
  //                           isDisabled: true,
  //                         ),
  //                         _buildMenuItem(
  //                           icon: Icons.message_outlined,
  //                           label: 'Message',
  //                           isDisabled: true,
  //                         ),
  //                         _buildMenuItem(
  //                           icon: Icons.grid_view_outlined,
  //                           label: 'Elements',
  //                           isDisabled: true,
  //                         ),
  //                         _buildMenuItem(
  //                           icon: Icons.settings_outlined,
  //                           label: 'Setting',
  //                           isDisabled: true,
  //                         ),

  //                         const Divider(),

  //                         _buildMenuItem(
  //                           icon: Icons.power_settings_new,
  //                           label: 'Logout',
  //                           iconColor: Colors.red,
  //                           textColor: Colors.red,
  //                           onTap: () {
  //                             Navigator.of(context).pop();
  //                           },
  //                         ),

  //                         const SizedBox(height: 24),

  //                         // Footer app info
  //                         const Padding(
  //                           padding: EdgeInsets.symmetric(horizontal: 20),
  //                           child: Text(
  //                             'Ombe Coffee App\nApp version 1.2',
  //                             style: TextStyle(
  //                               fontSize: 12,
  //                               color: Colors.black54,
  //                             ),
  //                           ),
  //                         ),
  //                         const SizedBox(height: 20),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //     transitionBuilder: (context, anim1, anim2, child) {
  //       return SlideTransition(
  //         position: Tween<Offset>(
  //           begin: const Offset(-1, 0),
  //           end: Offset.zero,
  //         ).animate(anim1),
  //         child: child,
  //       );
  //     },
  //     transitionDuration: const Duration(milliseconds: 300),
  //   );
  // }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    Color iconColor = Colors.black54,
    Color textColor = Colors.black87,
    bool isDisabled = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      enabled: !isDisabled,
      leading: Icon(icon, color: iconColor.withOpacity(isDisabled ? 0.4 : 1)),
      title: Text(
        label,
        style: TextStyle(
          color: textColor.withOpacity(isDisabled ? 0.4 : 1),
          fontSize: 16,
        ),
      ),
      onTap: isDisabled ? null : onTap ?? () => Navigator.of(context).pop(),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return Colors.orange;
      case 'paid': return Colors.blueAccent; // Paid but not processed
      case 'processing': return Colors.blue; 
      case 'shipped': return Colors.purple;
      case 'completed': return Colors.green;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }

  Widget _buildFilterButton(String label, {bool isFirst = false}) {
    final bool isActive = selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = label),
      child: Container(
        height: 42,
        width: 108,
        decoration: BoxDecoration(
          color: isActive ? kGreen : Colors.transparent,
          border: Border.all(color: kGreen, width: 1.4),
          borderRadius: BorderRadius.circular(22),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14.5,
            color: isActive ? Colors.white : kGreen,
          ),
        ),
      ),
    );
  }
}
