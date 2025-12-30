import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/cart_service.dart';
import '../../services/checkout_service.dart';
import '../../services/auth_services.dart';
import '../../api/order_api.dart';
import 'order_success_page.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  static const Color kGreen = Color(0xFF1E6B4C);
  List<Map<String, dynamic>> _paymentMethods = [];
  bool _isLoadingMethods = true;
  String selectedMethod = 'Credit Card';
  bool _isProcessing = false;
  String _userName = 'John Doe';

  final PageController _pageController = PageController(viewportFraction: 0.9);
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    try {
      // Get total amount from cart provider context later or just pass dummy amount for fee calc
      // Ideally we access provider here but initState cannot access context normally for provider unless in build or post-frame
      // We'll call it with default first
      final methods = await OrderApi.getPaymentMethods();
      if (mounted) {
        setState(() {
          _paymentMethods = methods;
          _isLoadingMethods = false;
          // Set first one as default if any
          if (_paymentMethods.isNotEmpty && selectedMethod == 'Credit Card') {
            selectedMethod = _paymentMethods[0]['paymentMethod'];
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingMethods = false);
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Failed to load payment methods: $e')),
        );
      }
    }
  }

  Future<void> _loadUserName() async {
    final user = await _authService.getUser();
    if (user != null && mounted) {
      setState(() {
        _userName = user['fullName'] ?? user['username'] ?? 'John Doe';
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepIndicator(),
            const SizedBox(height: 40),

            const Text(
              "Select Payment Method",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),

            if (_isLoadingMethods)
              const Center(child: CircularProgressIndicator())
            else if (_paymentMethods.isEmpty)
              const Text("No payment methods available.")
            else
               ..._paymentMethods.map((method) {
                 return Column(
                   children: [
                     _buildPaymentOption(
                       value: method['paymentMethod'], // Codes like 'SP', 'BC'
                       title: method['paymentName'],
                       imageUrl: method['paymentImage'],
                       child: Padding(
                         padding: const EdgeInsets.all(16.0),
                         child: Text(
                           "Pay using ${method['paymentName']}",
                           style: const TextStyle(color: Colors.grey),
                         ),
                       ),
                     ),
                     const Divider(height: 16),
                   ],
                 );
               }).toList(),

            const SizedBox(height: 32),
            _buildTotalSection(),
          ],
        ),
      ),
      bottomNavigationBar: _buildNextButton(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leadingWidth: 60,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
      ),
      title: const Text(
        'Checkout',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Shipping',
              style: TextStyle(color: Colors.grey[400], fontSize: 13),
            ),
            Text(
              'Order Detail',
              style: TextStyle(color: Colors.grey[400], fontSize: 13),
            ),
            const Text(
              'Payment',
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(height: 1.5, color: Colors.grey[300]),
            Container(
              height: 2,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Color(0xFF1E6B4C),
                  ],
                  stops: [0.0, 0.67, 1.0],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E6B4C),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required String value,
    required String title,
    String? imageUrl,
    required Widget child,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        initiallyExpanded: selectedMethod == value,
        onExpansionChanged: (expanded) {
          if (expanded) setState(() => selectedMethod = value);
        },
        leading: Radio<String>(
          value: value,
          groupValue: selectedMethod,
          activeColor: kGreen,
          onChanged: (v) => setState(() => selectedMethod = v!),
        ),
        title: Row(
          children: [
            if (imageUrl != null && imageUrl.isNotEmpty)
               Padding(
                 padding: const EdgeInsets.only(right: 10),
                 child: Image.network(imageUrl, width: 40, errorBuilder: (_,__,___) => const Icon(Icons.payment)),
               ),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 14
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 0, bottom: 8),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildCreditCardCarousel() {
    final cards = [
      [const Color(0xFF9D4EDD), const Color(0xFF6C63FF)],
      [const Color(0xFF4ECDC4), const Color(0xFF556270)],
      [const Color(0xFF232526), const Color(0xFF414345)],
    ];

    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _pageController,
        padEnds: false,
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cards[index],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: cards[index][1].withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Credit Card",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text(
                  "1234 **** **** ****",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "04 / 25",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      _userName.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBankTransferForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text("Card Holder Name", style: TextStyle(color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(
          _userName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Divider(color: Colors.grey[300]),
        const SizedBox(height: 12),
        Text("Card Number", style: TextStyle(color: Colors.grey[600])),
        const SizedBox(height: 4),
        const Text(
          "1234 5678 9101 1121",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Divider(color: Colors.grey[300]),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Month/Year", style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 4),
                  const Text("12/27", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("CVV", style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 4),
                  const Text("123", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTotalSection() {
    final cart = Provider.of<CartService>(context);
    final checkoutService = Provider.of<CheckoutService>(context);

    final subtotal = cart.totalAmount;
    final discount = checkoutService.discount;
    final total = subtotal - discount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        children: [
          // Title
          const Row(
            children: [
              Icon(Icons.receipt_long, color: kGreen, size: 20),
              SizedBox(width: 8),
              Text(
                'Payment Summary',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              ),
              Text(
                '\$${subtotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          // Discount (if applied)
          if (discount > 0) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Discount',
                      style: TextStyle(fontSize: 15, color: Colors.red[700]),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: kGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        checkoutService.couponCode ?? '',
                        style: const TextStyle(
                          fontSize: 11,
                          color: kGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  '- \$${discount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.red[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
          ],

          const SizedBox(height: 12),

          // Total
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Payment',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: kGreen,
                  ),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    final cart = Provider.of<CartService>(context);
    final checkoutService = Provider.of<CheckoutService>(
      context,
      listen: false,
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        24 + MediaQuery.of(context).padding.bottom,
      ),
      child: ElevatedButton(
        onPressed: _isProcessing
            ? null
            : () async {
                // Set payment method with dummy data
                checkoutService.setPaymentMethod(selectedMethod);

                // Set dummy credit card data
                if (selectedMethod == 'Credit Card') {
                  checkoutService.setCreditCardInfo(
                    cardNumber: '1234 5678 9101 1121',
                    cardHolderName: _userName,
                    expiryDate: '12/27',
                    cvv: '123',
                  );
                }

                // Get payment summary before reset
                final subtotal = cart.totalAmount;
                final discount = checkoutService.discount;
                final couponCode = checkoutService.couponCode;

                // Show loading
                setState(() => _isProcessing = true);

                try {
                  // Prepare order items from cart
                  final items = cart.items.map((item) {
                    return {
                      'productId': item.product.id,
                      'quantity': item.quantity,
                      'size': item.size,
                    };
                  }).toList();

                  // Create order
                  final order = await OrderApi.createOrder(
                    items: items,
                    paymentMethod: selectedMethod,
                    deliveryAddress: checkoutService.getDeliveryAddressMap(),
                    notes: null,
                    discount: discount > 0 ? discount : null,
                    couponCode: checkoutService.couponCode,
                    finalTotal: subtotal - discount,
                  );

                  // Clear cart after successful order
                  cart.clearCart();

                  // Reset checkout service
                  checkoutService.reset();

                  // Navigate to success page
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderSuccessPage(
                          order: order,
                          subtotal: subtotal,
                          discount: discount,
                          couponCode: couponCode,
                        ),
                      ),
                      (route) => route.isFirst, // Keep only home page in stack
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Failed to create order: ${e.toString()}',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } finally {
                  if (mounted) {
                    setState(() => _isProcessing = false);
                  }
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: kGreen,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          disabledBackgroundColor: kGreen.withOpacity(0.5),
        ),
        child: _isProcessing
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'PROCEED TO ORDER',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 16,
                    color: Colors.white,
                  ),
                ],
              ),
      ),
    );
  }
}
