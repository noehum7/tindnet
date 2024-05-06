import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Service {
  final String name;
  final IconData icon;

  Service({required this.name, required this.icon});
}

List<Service> services = [
  Service(name: 'Productos', icon: Icons.shopping_cart),
  Service(name: 'Viajes', icon: Icons.flight),
  Service(name: 'Eventos', icon: Icons.event),
  Service(name: 'Ocio', icon: Icons.sports_esports),
  Service(name: 'Restauración', icon: Icons.restaurant),
  Service(name: 'Otros', icon: Icons.more_horiz),
];