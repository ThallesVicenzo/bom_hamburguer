import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bom_hamburguer/viewmodels/cart_viewmodel.dart';
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
                  '${l10n.total} R\$ ${cartViewModel.getTotal().toStringAsFixed(2)}'),
              if (cartViewModel.getDiscount() > 0) ...[
                const SizedBox(height: 4),
                Text(
                  l10n.discountApplied(
                      'R\$ ${cartViewModel.getDiscount().toStringAsFixed(2)}'),
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
          ? _buildEmptyCart(l10n)
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      ...cartViewModel.items.map(
                          (item) => _buildCartItem(item, cartViewModel, l10n)),
                      const SizedBox(height: 20),
                      _buildOrderSummary(cartViewModel, l10n),
                      const SizedBox(height: 20),
                      _buildCustomerInput(l10n),
                    ],
                  ),
                ),
                _buildPayButton(cartViewModel, pay, l10n),
              ],
            ),
    );
  }

  Widget _buildEmptyCart(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.emptyCart,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.emptyCartSubtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(
      item, CartViewModel cartViewModel, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.orange.shade100,
          child: Text(
            item.product.type == 'sandwich'
                ? '🍔'
                : item.product.name == 'fries'
                    ? '🍟'
                    : '🥤',
            style: const TextStyle(fontSize: 20),
          ),
        ),
        title: Text(
          _getLocalizedProductName(item.product.name, l10n),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          'R\$ ${item.product.price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.orange.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.remove_circle, color: Colors.red),
          onPressed: () {
            cartViewModel.removeItem(item);
          },
        ),
      ),
    );
  }

  Widget _buildOrderSummary(
      CartViewModel cartViewModel, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
            l10n.orderSummary,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.subtotal),
              Text('R\$ ${cartViewModel.getSubtotal().toStringAsFixed(2)}'),
            ],
          ),
          if (cartViewModel.getDiscount() > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.discount,
                  style: TextStyle(color: Colors.green.shade600),
                ),
                Text(
                  '- R\$ ${cartViewModel.getDiscount().toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.green.shade600),
                ),
              ],
            ),
            if (cartViewModel.getDiscountDescription().isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                _getLocalizedDiscountDescription(
                    cartViewModel.getDiscountDescription(), l10n),
                style: TextStyle(
                  color: Colors.green.shade600,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.total,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'R\$ ${cartViewModel.getTotal().toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInput(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
            l10n.customerData,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: l10n.yourName,
              hintText: l10n.yourNameHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.person),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton(
      CartViewModel cartViewModel, VoidCallback onPay, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ElevatedButton(
        onPressed: onPay,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          '${l10n.finalizeOrder} - R\$ ${cartViewModel.getTotal().toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _getLocalizedProductName(String productName, AppLocalizations l10n) {
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

  String _getLocalizedDiscountDescription(
      String discountKey, AppLocalizations l10n) {
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
}
