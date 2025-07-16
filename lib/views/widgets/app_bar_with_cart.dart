import 'package:flutter/material.dart';

class AppBarWithCart extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWithCart({
    super.key,
    required this.cartCount,
    required this.title,
    this.backgroundColor = Colors.orange,
    this.foregroundColor = Colors.white,
    this.onCartPressed,
    this.elevation = 0,
  });

  final int cartCount;
  final String title;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback? onCartPressed;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: foregroundColor,
        ),
      ),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.shopping_cart, color: foregroundColor),
              onPressed: onCartPressed,
            ),
            if (cartCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    cartCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
