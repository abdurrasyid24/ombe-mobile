class ProductApi {
  final int id;
  final String name;
  final String description;
  final double price;
  final double? oldPrice;
  final String? image;
  final int categoryId;
  final CategoryInfo? category;
  final bool isFeatured;
  final int stock;
  final bool isActive;
  final double rating;
  final int? points;
  final String? imagePublicId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductApi({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.oldPrice,
    this.image,
    required this.categoryId,
    this.category,
    required this.isFeatured,
    required this.stock,
    required this.isActive,
    required this.rating,
    this.points,
    this.imagePublicId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductApi.fromJson(Map<String, dynamic> json) {
    return ProductApi(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: _parseDouble(json['price']),
      oldPrice: json['oldPrice'] != null ? _parseDouble(json['oldPrice']) : null,
      image: json['image'] as String?,
      categoryId: json['categoryId'] as int,
      category: json['category'] != null 
          ? CategoryInfo.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      isFeatured: json['isFeatured'] as bool? ?? false,
      stock: json['stock'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      rating: _parseDouble(json['rating']),
      points: json['points'] as int?,
      imagePublicId: json['imagePublicId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // Helper method to parse string or number to double
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'oldPrice': oldPrice,
      'image': image,
      'categoryId': categoryId,
      'category': category?.toJson(),
      'isFeatured': isFeatured,
      'stock': stock,
      'isActive': isActive,
      'rating': rating,
      'points': points,
      'imagePublicId': imagePublicId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Get image URL or fallback to placeholder
  String get imageUrl {
    if (image != null && image!.isNotEmpty) {
      return image!;
    }
    return 'https://via.placeholder.com/300x300.png?text=${Uri.encodeComponent(name)}';
  }
}

class CategoryInfo {
  final int id;
  final String name;
  final String? icon;

  CategoryInfo({
    required this.id,
    required this.name,
    this.icon,
  });

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }
}
