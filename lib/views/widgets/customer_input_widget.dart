import 'package:flutter/material.dart';

class CustomerInputWidget extends StatelessWidget {
  final TextEditingController nameController;
  final String title;
  final String labelText;
  final String hintText;
  final IconData? prefixIcon;
  final Color? backgroundColor;
  final double borderRadius;

  const CustomerInputWidget({
    super.key,
    required this.nameController,
    required this.title,
    required this.labelText,
    required this.hintText,
    this.prefixIcon = Icons.person,
    this.backgroundColor = Colors.white,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
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
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            ),
          ),
        ],
      ),
    );
  }
}
