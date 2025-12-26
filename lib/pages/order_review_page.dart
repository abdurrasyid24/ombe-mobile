import 'package:flutter/material.dart';

class OrderReviewPage extends StatefulWidget {
  const OrderReviewPage({super.key});

  @override
  State<OrderReviewPage> createState() => _OrderReviewPageState();
}

class _OrderReviewPageState extends State<OrderReviewPage> {
  static const kPrimaryGreen = Color(0xFF1E6B4C);
  static const kDarkGrey = Color(0xFF424242);
  static const kMediumGrey = Color(0xFF9E9E9E);
  static const kLightGrey = Color(0xFFE0E0E0);
  static const kStarOrange = Color(0xFFFFA726);
  double _rating = 4.0; 
  late TextEditingController _reviewController;

  @override
  void initState() {
    super.initState();
    _reviewController = TextEditingController();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kDarkGrey),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Write Reviews',
          style: TextStyle(
            color: kDarkGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: kDarkGrey),
            onPressed: () {
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProductInfo(),
            const SizedBox(height: 32),
            _buildRatingSection(),
            const SizedBox(height: 32),
            _buildReviewTextField(),
            const SizedBox(height: 24),
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            'assets/images/featured_1.jpg',
            width:100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Brewed Coppuccino Latte with Creamy Milk',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kDarkGrey,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Breverages',
                style: TextStyle(
                  fontSize: 14,
                  color: kMediumGrey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildRatingSection() {
    return Column(
      children: [
        const Text(
          'What do you think?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: kDarkGrey,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Lorem ipsum dolor sit amet, consectetur\nadipiscing elit, sed do eiusmod',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: kMediumGrey,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _rating.toStringAsFixed(1), 
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: kDarkGrey,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            int starNumber = index + 1;
            return IconButton(
              onPressed: () {
                setState(() {
                  _rating = starNumber.toDouble();
                });
              },
              icon: Icon(
                starNumber <= _rating ? Icons.star : Icons.star_border,
                color: starNumber <= _rating ? kStarOrange : kLightGrey,
                size: 44,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildReviewTextField() {
    return TextField(
      controller: _reviewController,
      maxLines: 5,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        hintText: 'Write your review here',
        hintStyle: const TextStyle(color: kMediumGrey),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kLightGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kLightGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kPrimaryGreen),
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context); 
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryGreen,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        elevation: 0,
      ),
      child: const Text(
        'SEND',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}