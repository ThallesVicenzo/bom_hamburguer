import 'package:flutter/material.dart';

class ProductSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Color? titleColor;
  final double titleFontSize;
  final FontWeight titleFontWeight;
  final double spacing;

  const ProductSection({
    super.key,
    required this.title,
    required this.children,
    this.titleColor = Colors.orange,
    this.titleFontSize = 20.0,
    this.titleFontWeight = FontWeight.bold,
    this.spacing = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: titleFontWeight,
            color: titleColor,
          ),
        ),
        SizedBox(height: spacing),
        ...children,
      ],
    );
  }
}
