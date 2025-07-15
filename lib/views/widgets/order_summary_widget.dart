import 'package:flutter/material.dart';
import 'package:bom_hamburguer/viewmodels/cart_viewmodel.dart';
import 'package:bom_hamburguer/viewmodels/utils/formatters/currency_formatter.dart';
import 'package:bom_hamburguer/injector.dart';
import 'package:bom_hamburguer/l10n/global_app_localizations.dart';

class OrderSummaryWidget extends StatelessWidget {
  final CartViewModel cartViewModel;

  const OrderSummaryWidget({
    super.key,
    required this.cartViewModel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = sl<GlobalAppLocalizations>().current;

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.orderSummary,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.subtotal),
              Text(CurrencyFormatter.formatCurrency(
                  cartViewModel.getSubtotal())),
            ],
          ),
          if (cartViewModel.getDiscount() > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.discount,
                  style: TextStyle(color: Colors.green.shade600),
                ),
                Text(
                  '- ${CurrencyFormatter.formatCurrency(cartViewModel.getDiscount())}',
                  style: TextStyle(color: Colors.green.shade600),
                ),
              ],
            ),
            if (cartViewModel.getDiscountDescription().isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                _getLocalizedDiscountDescription(
                    cartViewModel.getDiscountDescription(), l10n),
                style: TextStyle(
                  color: Colors.green.shade600,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.total,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                CurrencyFormatter.formatCurrency(cartViewModel.getTotal()),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getLocalizedDiscountDescription(
      String discountKey, AppLocalizations l10n) {
    switch (discountKey) {
      case 'comboDiscount':
        return l10n.comboDiscount;
      case 'drinkDiscount':
        return l10n.drinkDiscount;
      case 'friesDiscount':
        return l10n.friesDiscount;
      default:
        return discountKey;
    }
  }
}
