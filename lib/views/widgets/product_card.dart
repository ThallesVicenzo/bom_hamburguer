import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bom_hamburguer/models/product.dart';
import 'package:bom_hamburguer/viewmodels/cart_viewmodel.dart';
import 'package:bom_hamburguer/viewmodels/utils/formatters/currency_formatter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
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
            product.type == 'sandwich'
                ? '🍔'
                : product.name == 'fries'
                    ? '🍟'
                    : '🥤',
            style: const TextStyle(fontSize: 20),
          ),
        ),
        title: Text(
          _getLocalizedProductName(product, l10n),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          CurrencyFormatter.formatCurrency(product.price),
          style: TextStyle(
            fontSize: 14,
            color: Colors.orange.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: ElevatedButton(
          onPressed: () {
            final error = cartViewModel.addItem(product);
            if (error.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_getLocalizedErrorMessage(error, l10n)),
                  backgroundColor: Colors.red,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      l10n.itemAdded(_getLocalizedProductName(product, l10n))),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(l10n.add),
        ),
      ),
    );
  }

  String _getLocalizedProductName(Product product, AppLocalizations l10n) {
    switch (product.name) {
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
        return product.name;
    }
  }

  String _getLocalizedErrorMessage(String errorKey, AppLocalizations l10n) {
    switch (errorKey) {
      case 'onlyOneSandwich':
        return l10n.onlyOneSandwich;
      case 'onlyOneFries':
        return l10n.onlyOneFries;
      case 'onlyOneDrink':
        return l10n.onlyOneDrink;
      case 'itemAlreadyInCart':
        return l10n.itemAlreadyInCart;
      default:
        return errorKey;
    }
  }
}
