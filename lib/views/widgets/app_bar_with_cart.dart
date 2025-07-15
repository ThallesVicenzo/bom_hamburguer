import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bom_hamburguer/viewmodels/cart_viewmodel.dart';
import 'package:bom_hamburguer/viewmodels/utils/routes/app_navigator/app_navigator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppBarWithCart extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWithCart({super.key});

  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context);
    final l10n = AppLocalizations.of(context)!;

    return AppBar(
      title: Text(
        l10n.appTitle,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.orange,
      elevation: 0,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () => AppNavigator(context).pushNamed('cart'),
            ),
            if (cartViewModel.isNotEmpty)
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
                    '${cartViewModel.itemCount}',
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
