import 'package:flutter/material.dart';
import 'package:bom_hamburguer/models/product.dart';
import 'package:bom_hamburguer/viewmodels/utils/formatters/currency_formatter.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final String productName;
  final String buttonText;
  final String addedMessage;
  final VoidCallback? onAddPressed;
  final Function(String)? onError;
  final Function(String)? onSuccess;
  final Color primaryColor;
  final Color backgroundColor;

  const ProductCard({
    super.key,
    required this.product,
    required this.productName,
    required this.buttonText,
    required this.addedMessage,
    this.onAddPressed,
    this.onError,
    this.onSuccess,
    this.primaryColor = Colors.orange,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: primaryColor.withValues(alpha: 0.2),
          child: Text(
            _getProductEmoji(product),
            style: const TextStyle(fontSize: 20),
          ),
        ),
        title: Text(
          productName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          CurrencyFormatter.formatCurrency(product.price),
          style: TextStyle(
            fontSize: 14,
            color: primaryColor.withValues(alpha: 0.8),
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: ElevatedButton(
          onPressed: onAddPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(buttonText),
        ),
      ),
    );
  }

  String _getProductEmoji(Product product) {
    if (product.type == 'sandwich') return '🍔';
    if (product.name == 'fries') return '🍟';
    return '🥤';
  }
}
