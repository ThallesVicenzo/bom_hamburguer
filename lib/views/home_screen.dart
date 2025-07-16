import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bom_hamburguer/viewmodels/home_screen_viewmodel.dart';
import 'package:bom_hamburguer/services/cart_service.dart';
import 'package:bom_hamburguer/views/widgets/app_bar_with_cart.dart';
import 'package:bom_hamburguer/views/widgets/welcome_section.dart';
import 'package:bom_hamburguer/views/widgets/product_section.dart';
import 'package:bom_hamburguer/views/widgets/product_card.dart';
import 'package:bom_hamburguer/views/widgets/promotion_info.dart';
import 'package:bom_hamburguer/injector.dart';
import 'package:bom_hamburguer/l10n/global_app_localizations.dart';
import 'package:bom_hamburguer/viewmodels/utils/routes/app_navigator/app_navigator.dart';
import 'package:bom_hamburguer/viewmodels/utils/routes/main_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final l10n = sl<GlobalAppLocalizations>().current;

  // void _handleUIMessage(HomeScreenViewModel homeScreenViewModel) {
  //   final uiMessage = homeScreenViewModel.uiMessage;
  //   if (uiMessage != null) {
  //     Color backgroundColor;
  //     switch (uiMessage.type) {
  //       case UIMessageType.success:
  //         backgroundColor = Colors.green;
  //         break;
  //       case UIMessageType.error:
  //         backgroundColor = Colors.red;
  //         break;
  //       case UIMessageType.warning:
  //         backgroundColor = Colors.orange;
  //         break;
  //       case UIMessageType.info:
  //         backgroundColor = Colors.blue;
  //         break;
  //     }

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(uiMessage.message),
  //         backgroundColor: backgroundColor,
  //         action: uiMessage.actionLabel != null
  //             ? SnackBarAction(
  //                 label: uiMessage.actionLabel!,
  //                 textColor: Colors.white,
  //                 onPressed: uiMessage.onAction ?? () {},
  //               )
  //             : null,
  //         duration: const Duration(seconds: 4),
  //       ),
  //     );
  //     homeScreenViewModel.clearUIMessage();
  //   }
  // }

  String _getLocalizedProductName(String productName) {
    switch (productName) {
      case 'xBurger':
        return l10n.xBurger;
      case 'xEgg':
        return l10n.xEgg;
      case 'xBacon':
        return l10n.xBacon;
      case 'fries':
        return l10n.fries;
      case 'softDrink':
        return l10n.softDrink;
      default:
        return productName;
    }
  }

  void _handleAddToCart(dynamic product) async {
    final cartService = Provider.of<CartService>(context, listen: false);
    final error = await cartService.addItem(product);

    if (!mounted) return;

    if (error.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_getLocalizedErrorMessage(error)),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.itemAdded(_getLocalizedProductName(product.name))),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  String _getLocalizedErrorMessage(String errorKey) {
    switch (errorKey) {
      case 'onlyOneSandwich':
        return l10n.onlyOneSandwich;
      case 'onlyOneFries':
        return l10n.onlyOneFries;
      case 'onlyOneDrink':
        return l10n.onlyOneDrink;
      case 'itemAlreadyInCart':
        return l10n.itemAlreadyInCart;
      default:
        return errorKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);

    return ChangeNotifierProvider(
      create: (_) => HomeScreenViewModel(sl()),
      child: Consumer<HomeScreenViewModel>(
        builder: (context, homeScreenViewModel, child) {
          return Scaffold(
            backgroundColor: Colors.orange.shade50,
            appBar: AppBarWithCart(
              cartCount: cartService.itemCount,
              title: l10n.appTitle,
              onCartPressed: () =>
                  AppNavigator(context).pushNamed(MainRoutes.checkout.name),
            ),
            body: homeScreenViewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WelcomeSection(
                          title: l10n.welcome,
                          subtitle: l10n.welcomeSubtitle,
                        ),
                        const SizedBox(height: 24),
                        ProductSection(
                          title: l10n.sandwiches,
                          children: homeScreenViewModel.sandwiches
                              .map(
                                (product) => ProductCard(
                                  product: product,
                                  productName:
                                      _getLocalizedProductName(product.name),
                                  buttonText: l10n.add,
                                  addedMessage: l10n.itemAdded(
                                      _getLocalizedProductName(product.name)),
                                  onAddPressed: () => _handleAddToCart(product),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                        ProductSection(
                          title: l10n.extras,
                          children: homeScreenViewModel.extras
                              .map(
                                (product) => ProductCard(
                                  product: product,
                                  productName:
                                      _getLocalizedProductName(product.name),
                                  buttonText: l10n.add,
                                  addedMessage: l10n.itemAdded(
                                      _getLocalizedProductName(product.name)),
                                  onAddPressed: () => _handleAddToCart(product),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                        PromotionInfo(
                          title: l10n.specialPromotions,
                          promotions: [
                            l10n.promoCombo,
                            l10n.promoDrink,
                            l10n.promoFries,
                          ],
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
