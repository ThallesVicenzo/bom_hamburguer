import 'package:flutter/material.dart';

class GenericCard extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry margin;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final List<BoxShadow>? boxShadow;

  const GenericCard({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.contentPadding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.only(bottom: 12),
    this.backgroundColor = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBoxShadow = [
      BoxShadow(
        color: Colors.grey.withValues(alpha: 0.1),
        spreadRadius: 1,
        blurRadius: 5,
        offset: const Offset(0, 2),
      ),
    ];

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        boxShadow: boxShadow ?? defaultBoxShadow,
      ),
      child: ListTile(
        contentPadding: contentPadding,
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
