import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bom_hamburguer/viewmodels/cart_viewmodel.dart';
import 'package:bom_hamburguer/viewmodels/utils/formatters/currency_formatter.dart';
import 'package:bom_hamburguer/views/widgets/empty_cart_widget.dart';
import 'package:bom_hamburguer/views/widgets/cart_item_widget.dart';
import 'package:bom_hamburguer/views/widgets/order_summary_widget.dart';
import 'package:bom_hamburguer/views/widgets/customer_input_widget.dart';
import 'package:bom_hamburguer/views/widgets/pay_button_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CartScreen extends StatelessWidget {
  final _nameController = TextEditingController();

  CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context);
    final l10n = AppLocalizations.of(context)!;

    void pay() {
      if (_nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.pleaseEnterName),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (cartViewModel.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.cartIsEmpty),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.orderCreated),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.thankYou(_nameController.text)),
              const SizedBox(height: 8),
              Text(
                  '${l10n.total} ${CurrencyFormatter.formatCurrency(cartViewModel.getTotal())}'),
              if (cartViewModel.getDiscount() > 0) ...[
                const SizedBox(height: 4),
                Text(
                  l10n.discountApplied(CurrencyFormatter.formatCurrency(
                      cartViewModel.getDiscount())),
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                cartViewModel.clearCart();
                _nameController.clear();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
    }

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
      body: cartViewModel.isEmpty
          ? const EmptyCartWidget()
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      ...cartViewModel.items.map((item) => CartItemWidget(
                            item: item,
                            cartViewModel: cartViewModel,
                          )),
                      const SizedBox(height: 20),
                      OrderSummaryWidget(cartViewModel: cartViewModel),
                      const SizedBox(height: 20),
                      CustomerInputWidget(nameController: _nameController),
                    ],
                  ),
                ),
                PayButtonWidget(
                  cartViewModel: cartViewModel,
                  onPay: pay,
                ),
              ],
            ),
    );
  }
}
