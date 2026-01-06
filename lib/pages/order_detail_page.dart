import 'package:flutter/material.dart';
import '../models/order_model.dart';
import 'package:ombe/pages/checkout/tracking_order_page.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailPage extends StatefulWidget {
  final Order order;
  const OrderDetailPage({super.key, required this.order});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  static const Color kGreen = Color(0xFF1E6B4C);
  static const Color kSoftGrey = Color(0xFFF5F5F5);
  late Order _currentOrder;

  @override
  void initState() {
    super.initState();
    _currentOrder = widget.order;
    // Check status if pending
    if (_currentOrder.status == 'pending') {
      _checkStatus();
    }
  }
  
  // Simple periodic check or just manual refresh
  // For better UX, we could use a Timer, but for now let's just allow manual refresh 
  // or refresh on resuming app (WidgetsBindingObserver)
  
  Future<void> _checkStatus() async {
      // In a real app we would fetch the latest order status from API here
      // But we need to add getOrderById to OrderApi first or reuse existing
      // For now we just keep the passed order. 
      // User can go back and forth to refresh list.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // ... (Keep existing AppBar)
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Order Detail',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _currentOrder.items.isNotEmpty &&
                      _currentOrder.items.first.productImage != null
                  ? Image.network(
                      _currentOrder.items.first.productImage!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 60,
                          ),
                        );
                      },
                    )
                  : Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.local_cafe,
                        color: Colors.grey,
                        size: 60,
                      ),
                    ),
            ),
            const SizedBox(height: 20),

            // Product name
            Text(
              _currentOrder.orderNumber,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.local_shipping_outlined,
                    color: kGreen, size: 20),
                const SizedBox(width: 8),
                Text(
                  _currentOrder.status.toUpperCase(),
                  style: TextStyle(
                    color: _getStatusColor(_currentOrder.status), // Use dynamic color
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Divider
            const Divider(),

            // Order details
            const SizedBox(height: 10),
            _buildInfoRow('Order Number', _currentOrder.orderNumber),
            _buildInfoRow('Total Items', '${_currentOrder.totalItems} items'),
            _buildInfoRow('Total Amount', '\$${_currentOrder.totalAmount.toStringAsFixed(2)}'),
            _buildInfoRow('Payment Method', _currentOrder.paymentMethod),
            _buildInfoRow('Status', _currentOrder.status.toUpperCase()),

            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kSoftGrey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_on_outlined, color: kGreen, size: 24),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${_currentOrder.deliveryAddress?['fullAddress'] ?? 'No address provided'}\n(Estimated delivery: 1-2 days)',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
        child: SizedBox(
          height: 60,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              // If pending and has payment URL, launch it
              if (_currentOrder.status.toLowerCase() == 'pending' && 
                  _currentOrder.paymentUrl != null && 
                  _currentOrder.paymentUrl!.isNotEmpty) {
                 final Uri url = Uri.parse(_currentOrder.paymentUrl!);
                 if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                    if (context.mounted) {
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('Could not launch payment page')),
                       );
                    }
                 }
              } else {
                // Otherwise navigate to tracking
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TrackingOrderPage()),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: (_currentOrder.status.toLowerCase() == 'pending' && _currentOrder.paymentUrl != null) 
                  ? Colors.orange 
                  : kGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              elevation: 0,
            ),
            child: Text(
              (_currentOrder.status == 'pending' && _currentOrder.paymentUrl != null) 
                  ? 'PAY NOW' 
                  : 'TRACK ORDER',
              style: const TextStyle(
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return Colors.orange;
      case 'paid': return Colors.blueAccent;
      case 'processing': return Colors.blue; 
      case 'shipped': return Colors.purple;
      case 'completed': return kGreen;
      case 'cancelled': return Colors.red;
      default: return Colors.black;
    }
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15.5,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

