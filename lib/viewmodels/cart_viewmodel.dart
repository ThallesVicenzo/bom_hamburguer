import 'package:flutter/material.dart';
import 'package:bom_hamburguer/models/product.dart';
import 'package:bom_hamburguer/models/cart_item.dart';

class CartViewModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  int get itemCount => _items.fold(0, (total, item) => total + item.quantity);

  String addItem(Product product) {
    if (product.type == 'sandwich') {
      final sandwichCount =
          _items.where((item) => item.product.type == 'sandwich').length;
      if (sandwichCount >= 1) {
        return 'onlyOneSandwich';
      }
    }

    if (product.name == 'fries') {
      final friesCount =
          _items.where((item) => item.product.name == 'fries').length;
      if (friesCount >= 1) {
        return 'onlyOneFries';
      }
    }

    if (product.name == 'softDrink') {
      final drinkCount =
          _items.where((item) => item.product.name == 'softDrink').length;
      if (drinkCount >= 1) {
        return 'onlyOneDrink';
      }
    }

    final existingItemIndex =
        _items.indexWhere((item) => item.product.id == product.id);

    if (existingItemIndex >= 0) {
      return 'itemAlreadyInCart';
    } else {
      _items.add(CartItem(product: product));
    }

    notifyListeners();
    return '';
  }

  void removeItem(CartItem cartItem) {
    _items.remove(cartItem);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double getSubtotal() {
    return _items.fold(0, (total, item) => total + item.totalPrice);
  }

  double getDiscount() {
    bool hasSandwich = _items.any((item) => item.product.type == 'sandwich');
    bool hasFries = _items.any((item) => item.product.name == 'fries');
    bool hasSoftDrink = _items.any((item) => item.product.name == 'softDrink');

    if (hasSandwich && hasFries && hasSoftDrink) {
      return getSubtotal() * 0.20;
    }
    if (hasSandwich && hasSoftDrink) {
      return getSubtotal() * 0.15;
    }
    if (hasSandwich && hasFries) {
      return getSubtotal() * 0.10;
    }
    return 0;
  }

  double getTotal() {
    return getSubtotal() - getDiscount();
  }

  String getDiscountDescription() {
    bool hasSandwich = _items.any((item) => item.product.type == 'sandwich');
    bool hasFries = _items.any((item) => item.product.name == 'fries');
    bool hasSoftDrink = _items.any((item) => item.product.name == 'softDrink');

    if (hasSandwich && hasFries && hasSoftDrink) {
      return 'comboDiscount';
    }
    if (hasSandwich && hasSoftDrink) {
      return 'drinkDiscount';
    }
    if (hasSandwich && hasFries) {
      return 'friesDiscount';
    }
    return '';
  }
}
