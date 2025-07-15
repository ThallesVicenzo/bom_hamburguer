import 'package:flutter/material.dart';
import 'package:bom_hamburguer/viewmodels/cart_viewmodel.dart';
import 'package:bom_hamburguer/viewmodels/utils/formatters/currency_formatter.dart';
import 'package:bom_hamburguer/injector.dart';
import 'package:bom_hamburguer/l10n/global_app_localizations.dart';

class PayButtonWidget extends StatelessWidget {
  final CartViewModel cartViewModel;
  final VoidCallback onPay;

  const PayButtonWidget({
    super.key,
    required this.cartViewModel,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = sl<GlobalAppLocalizations>().current;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ElevatedButton(
        onPressed: onPay,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          '${l10n.finalizeOrder} - ${CurrencyFormatter.formatCurrency(cartViewModel.getTotal())}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
