import 'package:flutter/material.dart';
import 'package:bom_hamburguer/models/cart_item.dart';
import 'package:bom_hamburguer/viewmodels/utils/formatters/currency_formatter.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final String productName;
  final VoidCallback? onRemove;
  final Color primaryColor;
  final Color backgroundColor;
  final IconData removeIcon;
  final Color removeIconColor;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.productName,
    this.onRemove,
    this.primaryColor = Colors.orange,
    this.backgroundColor = Colors.white,
    this.removeIcon = Icons.remove_circle,
    this.removeIconColor = Colors.red,
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
            _getProductEmoji(item.product),
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
          CurrencyFormatter.formatCurrency(item.product.price),
          style: TextStyle(
            fontSize: 14,
            color: primaryColor.withValues(alpha: 0.8),
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: IconButton(
          icon: Icon(removeIcon, color: removeIconColor),
          onPressed: onRemove,
        ),
      ),
    );
  }

  String _getProductEmoji(dynamic product) {
    if (product.type == 'sandwich') return '🍔';
    if (product.name == 'fries') return '🍟';
    return '🥤';
  }
}
