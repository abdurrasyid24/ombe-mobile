class Product {
  final int? id;
  final String name;
  final double price;
  final double oldPrice;
  final String imagePath;
  final double rating;
  final int points;
  final String category;
  final String? description;

  const Product({
    this.id,
    required this.name,
    required this.price,
    required this.oldPrice,
    required this.imagePath,
    this.rating = 3.8,
    this.points = 50,
    this.category = 'Beverages',
    this.description,
  });

  // Convert ProductApi to Product for cart compatibility
  factory Product.fromApi(dynamic productApi) {
    return Product(
      id: productApi.id,
      name: productApi.name,
      price: productApi.price,
      oldPrice: productApi.oldPrice ?? productApi.price * 1.2, // Use API oldPrice or estimate 20% discount
      imagePath: productApi.image ?? '',
      rating: productApi.rating ?? 0.0,
      points: productApi.points ?? ((productApi.rating ?? 0.0) * 10).toInt(),
      category: productApi.category?.name ?? 'Beverages',
      description: productApi.description,
    );
  }
}
