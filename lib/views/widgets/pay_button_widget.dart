import 'package:flutter/material.dart';

class PayButtonWidget extends StatelessWidget {
  final VoidCallback onPay;
  final String buttonText;
  final String? priceText;
  final Color backgroundColor;
  final Color textColor;
  final Color containerColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const PayButtonWidget({
    super.key,
    required this.onPay,
    required this.buttonText,
    this.priceText,
    this.backgroundColor = Colors.orange,
    this.textColor = Colors.white,
    this.containerColor = Colors.white,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final displayText =
        priceText != null ? '$buttonText - $priceText' : buttonText;

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ElevatedButton(
        onPressed: onPay,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          displayText,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
