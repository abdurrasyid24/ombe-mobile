class OrderItem {
  final int? id;
  final int productId;
  final String productName;
  final String? productImage;
  final int quantity;
  final double price;
  final String size;

  OrderItem({
    this.id,
    required this.productId,
    required this.productName,
    this.productImage,
    required this.quantity,
    required this.price,
    required this.size,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      productId: json['productId'],
      productName: json['product']?['name'] ?? '',
      productImage: json['product']?['image'],
      quantity: json['quantity'],
      price: double.parse(json['price'].toString()),
      size: json['size'] ?? 'medium',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'price': price,
      'size': size,
    };
  }
}

class Order {
  final int id;
  final String orderNumber;
  final int userId;
  final List<OrderItem> items;
  final double totalAmount;
  final String status;
  final String paymentMethod;
  final Map<String, dynamic>? deliveryAddress;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? discount;
  final double? finalTotal;
  final String? couponCode;

  Order({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    this.deliveryAddress,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.discount,
    this.finalTotal,
    this.couponCode,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    List<OrderItem> orderItems = [];
    if (json['items'] != null) {
      orderItems = (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList();
    }

    return Order(
      id: json['id'],
      orderNumber: json['orderNumber'] ?? '',
      userId: json['userId'],
      items: orderItems,
      totalAmount: double.parse(json['totalAmount'].toString()),
      status: json['status'] ?? 'pending',
      paymentMethod: json['paymentMethod'] ?? '',
      deliveryAddress: json['deliveryAddress'] != null
          ? Map<String, dynamic>.from(json['deliveryAddress'])
          : null,
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      discount: json['discount'] != null
          ? double.parse(json['discount'].toString())
          : null,
      finalTotal: json['finalTotal'] != null
          ? double.parse(json['finalTotal'].toString())
          : null,
      couponCode: json['couponCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'paymentMethod': paymentMethod,
      'deliveryAddress': deliveryAddress,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'discount': discount,
      'finalTotal': finalTotal,
      'couponCode': couponCode,
    };
  }

  // Helper getters
  String get firstProductName =>
      items.isNotEmpty ? items.first.productName : '';
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
}

// Dummy Data - will be replaced by API data
List<Order> dummyOrders = [];
