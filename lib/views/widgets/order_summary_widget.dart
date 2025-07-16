import 'package:flutter/material.dart';
import 'package:bom_hamburguer/viewmodels/utils/formatters/currency_formatter.dart';

class OrderSummaryWidget extends StatelessWidget {
  final String title;
  final String subtotalLabel;
  final String discountLabel;
  final String totalLabel;
  final double subtotal;
  final double discount;
  final double total;
  final String? discountDescription;
  final Color? primaryColor;
  final Color? discountColor;
  final Color? backgroundColor;

  const OrderSummaryWidget({
    super.key,
    required this.title,
    required this.subtotalLabel,
    required this.discountLabel,
    required this.totalLabel,
    required this.subtotal,
    required this.discount,
    required this.total,
    this.discountDescription,
    this.primaryColor = Colors.orange,
    this.discountColor,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveDiscountColor = discountColor ?? Colors.green.shade600;

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(subtotalLabel),
              Text(CurrencyFormatter.formatCurrency(subtotal)),
            ],
          ),
          if (discount > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  discountLabel,
                  style: TextStyle(color: effectiveDiscountColor),
                ),
                Text(
                  '- ${CurrencyFormatter.formatCurrency(discount)}',
                  style: TextStyle(color: effectiveDiscountColor),
                ),
              ],
            ),
            if (discountDescription != null &&
                discountDescription!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                discountDescription!,
                style: TextStyle(
                  color: effectiveDiscountColor,
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
                totalLabel,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                CurrencyFormatter.formatCurrency(total),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
