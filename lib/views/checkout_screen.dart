import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bom_hamburguer/viewmodels/checkout_viewmodel.dart';
import 'package:bom_hamburguer/services/cart_service.dart';
import 'package:bom_hamburguer/viewmodels/utils/formatters/currency_formatter.dart';
import 'package:bom_hamburguer/views/widgets/empty_cart_widget.dart';
import 'package:bom_hamburguer/views/widgets/cart_item_widget.dart';
import 'package:bom_hamburguer/views/widgets/order_summary_widget.dart';
import 'package:bom_hamburguer/views/widgets/customer_input_widget.dart';
import 'package:bom_hamburguer/views/widgets/pay_button_widget.dart';
import 'package:bom_hamburguer/injector.dart';
import 'package:bom_hamburguer/l10n/global_app_localizations.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final l10n = sl<GlobalAppLocalizations>().current;

  void _handleOrderResult(CheckoutViewModel viewModel) {
    final orderResult = viewModel.orderResult;
    if (orderResult != null) {
      final l10n = sl<GlobalAppLocalizations>().current;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.orderCreated),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.thankYou(orderResult.customerName)),
              const SizedBox(height: 8),
              Text(
                  '${l10n.total} ${CurrencyFormatter.formatCurrency(orderResult.total)}'),
              if (orderResult.discount > 0) ...[
                const SizedBox(height: 4),
                Text(
                  l10n.discountApplied(
                      CurrencyFormatter.formatCurrency(orderResult.discount)),
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                viewModel.completeOrder();
              },
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
      viewModel.clearOrderResult();
    }
  }

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

  String _getLocalizedDiscountDescription(String discountKey) {
    switch (discountKey) {
      case 'comboDiscount':
        return l10n.comboDiscount;
      case 'drinkDiscount':
        return l10n.drinkDiscount;
      case 'friesDiscount':
        return l10n.friesDiscount;
      default:
        return discountKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);

    return ChangeNotifierProvider(
      create: (_) => CheckoutViewModel(cartService),
      child: Consumer2<CheckoutViewModel, CartService>(
        builder: (context, checkoutViewModel, cartService, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleOrderResult(checkoutViewModel);
          });

          return Scaffold(
            backgroundColor: Colors.orange.shade50,
            appBar: AppBar(
              title: Text(
                l10n.myCart,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            body: cartService.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                  )
                : cartService.isEmpty
                    ? EmptyCartWidget(
                        title: l10n.emptyCart,
                        subtitle: l10n.emptyCartSubtitle,
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: ListView(
                              padding: const EdgeInsets.all(16),
                              children: [
                                ...cartService.items
                                    .map((item) => CartItemWidget(
                                          item: item,
                                          productName: _getLocalizedProductName(
                                              item.product.name),
                                          onRemove: () =>
                                              cartService.removeItem(item),
                                        )),
                                const SizedBox(height: 20),
                                OrderSummaryWidget(
                                  title: l10n.orderSummary,
                                  subtotalLabel: l10n.subtotal,
                                  discountLabel: l10n.discount,
                                  totalLabel: l10n.total,
                                  subtotal: cartService.getSubtotal(),
                                  discount: cartService.getDiscount(),
                                  total: cartService.getTotal(),
                                  discountDescription: cartService
                                          .getDiscountDescription()
                                          .isNotEmpty
                                      ? _getLocalizedDiscountDescription(
                                          cartService.getDiscountDescription())
                                      : null,
                                ),
                                const SizedBox(height: 20),
                                CustomerInputWidget(
                                  nameController:
                                      checkoutViewModel.nameController,
                                  title: l10n.customerData,
                                  labelText: l10n.yourName,
                                  hintText: l10n.yourNameHint,
                                ),
                              ],
                            ),
                          ),
                          PayButtonWidget(
                            buttonText: l10n.finalizeOrder,
                            priceText: CurrencyFormatter.formatCurrency(
                                cartService.getTotal()),
                            onPay: () {
                              checkoutViewModel.processPayment();
                            },
                          ),
                        ],
                      ),
          );
        },
      ),
    );
  }
}
