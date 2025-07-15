import 'package:flutter/material.dart';
import 'package:bom_hamburguer/models/product.dart';
import 'package:bom_hamburguer/views/widgets/product_card.dart';

class ProductSection extends StatelessWidget {
  final String title;
  final List<Product> products;

  const ProductSection({
    super.key,
    required this.title,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        const SizedBox(height: 12),
        ...products.map((product) => ProductCard(product: product)),
      ],
    );
  }
}
