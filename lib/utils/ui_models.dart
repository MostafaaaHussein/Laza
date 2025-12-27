import 'package:flutter/material.dart';

typedef Product = Object;

class CartItemUi {
  final Product product;
  final String title;
  final String subtitle;
  final String price;
  final int quantity;
  final String? imageUrl;

  const CartItemUi({
    required this.product,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });
}

class ProfileMenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

