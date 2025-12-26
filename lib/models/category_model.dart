import 'package:flutter/material.dart';

class Category {
  final IconData icon;
  final String label;
  final int count;

  const Category({
    required this.icon,
    required this.label,
    required this.count,
  });
}

// contoh kategori seperti di screenshot
const List<Category> dummyCategories = [
  Category(icon: Icons.coffee_outlined, label: 'Beverages', count: 5),
  Category(icon: Icons.lunch_dining_rounded, label: 'Foods', count: 1),
  Category(icon: Icons.cake_outlined, label: 'Desserts', count: 2),
];
