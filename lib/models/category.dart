import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;

  Category({required this.name, required this.icon});
}

List<Category> categories = [
  Category(name: 'Productos', icon: Icons.shopping_cart),
  Category(name: 'Viajes', icon: Icons.flight),
  Category(name: 'Eventos', icon: Icons.event),
  Category(name: 'Ocio', icon: Icons.sports_esports),
  Category(name: 'Restauración', icon: Icons.restaurant),
  Category(name: 'Otros', icon: Icons.more_horiz),
];