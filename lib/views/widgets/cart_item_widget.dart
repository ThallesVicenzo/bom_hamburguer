import 'package:flutter/material.dart';
import 'package:bom_hamburguer/models/cart_item.dart';
import 'package:bom_hamburguer/viewmodels/cart_viewmodel.dart';
import 'package:bom_hamburguer/viewmodels/utils/formatters/currency_formatter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final CartViewModel cartViewModel;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.cartViewModel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
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
          backgroundColor: Colors.orange.shade100,
          child: Text(
            item.product.type == 'sandwich'
                ? '🍔'
                : item.product.name == 'fries'
                    ? '🍟'
                    : '🥤',
            style: const TextStyle(fontSize: 20),
          ),
        ),
        title: Text(
          _getLocalizedProductName(item.product.name, l10n),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          CurrencyFormatter.formatCurrency(item.product.price),
          style: TextStyle(
            fontSize: 14,
            color: Colors.orange.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.remove_circle, color: Colors.red),
          onPressed: () {
            cartViewModel.removeItem(item);
          },
        ),
      ),
    );
  }

  String _getLocalizedProductName(String productName, AppLocalizations l10n) {
    switch (productName) {
      case 'xBurger':
        return l10n.xBurger;
      case 'xEgg':
        return l10n.xEgg;
      case 'xBacon':
        return l10n.xBacon;
      case 'fries':
        return l10n.fries;
      case 'softDrink':
        return l10n.softDrink;
      default:
        return productName;
    }
  }
}
