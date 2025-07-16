import 'package:flutter/material.dart';
import 'package:bom_hamburguer/viewmodels/utils/ui_models.dart';
import 'package:bom_hamburguer/services/cart_service.dart';
import 'package:bom_hamburguer/injector.dart';
import 'package:bom_hamburguer/l10n/global_app_localizations.dart';

class CheckoutViewModel extends ChangeNotifier {
  final CartService _cartService;
  UIMessage? _uiMessage;
  OrderResult? _orderResult;
  final TextEditingController nameController = TextEditingController();
  final _l10n = sl<GlobalAppLocalizations>().current;

  CheckoutViewModel(this._cartService);

  UIMessage? get uiMessage => _uiMessage;
  OrderResult? get orderResult => _orderResult;
  CartService get cartService => _cartService;

  void clearUIMessage() {
    _uiMessage = null;
    notifyListeners();
  }

  void clearOrderResult() {
    _orderResult = null;
    notifyListeners();
  }

  void showErrorMessage(String message) {
    _uiMessage = UIMessage(
      message: message,
      type: UIMessageType.error,
      actionLabel: _l10n.ok,
      onAction: clearUIMessage,
    );
    notifyListeners();
  }

  void processPayment() {
    final customerName = nameController.text.trim();

    if (customerName.isEmpty) {
      _uiMessage = UIMessage(
        message: _l10n.pleaseEnterName,
        type: UIMessageType.error,
      );
      notifyListeners();
      return;
    }

    if (_cartService.isEmpty) {
      _uiMessage = UIMessage(
        message: _l10n.cartIsEmpty,
        type: UIMessageType.warning,
      );
      notifyListeners();
      return;
    }

    _orderResult = OrderResult(
      customerName: customerName,
      total: _cartService.getTotal(),
      discount: _cartService.getDiscount(),
      itemCount: _cartService.itemCount,
    );
    notifyListeners();
  }

  void completeOrder() {
    _cartService.clearCart();
    nameController.clear();
    _orderResult = null;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
