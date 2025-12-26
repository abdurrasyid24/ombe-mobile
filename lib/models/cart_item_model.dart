import 'product_model.dart';

class CartItem {
  final String id;
  final Product product;
  int quantity;
  String size; // Small, Medium, Large, Xtra Large

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.size,
  });

  double get totalPrice => product.price * quantity;

  // Copy with method for easy updates
  CartItem copyWith({
    String? id,
    Product? product,
    int? quantity,
    String? size,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': {
        'name': product.name,
        'price': product.price,
        'imagePath': product.imagePath,
      },
      'quantity': quantity,
      'size': size,
    };
  }
}
