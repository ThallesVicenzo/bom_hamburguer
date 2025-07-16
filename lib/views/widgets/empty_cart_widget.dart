import 'package:flutter/material.dart';

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.shopping_cart_outlined,
    this.iconSize = 80.0,
    this.iconColor = Colors.grey,
    this.titleStyle,
    this.subtitleStyle,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: titleStyle ??
                const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: subtitleStyle ??
                const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }
}
