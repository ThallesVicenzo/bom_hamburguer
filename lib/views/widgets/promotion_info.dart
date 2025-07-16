import 'package:flutter/material.dart';

class PromotionInfo extends StatelessWidget {
  const PromotionInfo({
    super.key,
    required this.title,
    required this.promotions,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.icon = Icons.local_offer,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.all(16),
  });

  final String title;
  final List<String> promotions;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final IconData icon;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final defaultBackgroundColor = backgroundColor ?? Colors.green.shade50;
    final defaultBorderColor = borderColor ?? Colors.green.shade200;
    final defaultTextColor = textColor ?? Colors.green.shade700;

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: defaultBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: defaultBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: defaultTextColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: defaultTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            promotions.join('\n'),
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
