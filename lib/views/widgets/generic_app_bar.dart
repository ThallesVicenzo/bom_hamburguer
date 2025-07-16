import 'package:flutter/material.dart';

class GenericAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final Color titleColor;
  final List<Widget>? actions;
  final Widget? leading;
  final bool? centerTitle;
  final double elevation;

  const GenericAppBar({
    super.key,
    required this.title,
    this.backgroundColor = Colors.orange,
    this.titleColor = Colors.white,
    this.actions,
    this.leading,
    this.centerTitle,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: titleColor,
        ),
      ),
      backgroundColor: backgroundColor,
      foregroundColor: titleColor,
      elevation: elevation,
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
