import 'package:flutter/material.dart';
import 'package:bom_hamburguer/models/product.dart';
import 'package:bom_hamburguer/models/cart_item.dart';
import 'package:bom_hamburguer/repositories/product_repository.dart';

class CartService extends ChangeNotifier {
  final ProductRepository _repository;
  final List<CartItem> _items = [];
  bool _isLoading = false;
  String? _errorMessage;

  CartService(this._repository) {
    _loadSavedCart();
  }

  Future<void> _loadSavedCart() async {
    await initializeCart(showLoading: false);
  }

  List<CartItem> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  int get itemCount => _items.length;

  int get totalQuantity =>
      _items.fold(0, (total, item) => total + item.quantity);

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> initializeCart({bool showLoading = true}) async {
    if (showLoading) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    final result = await _repository.getCartItems();
    result.fold(
      (failure) {
        _errorMessage = 'Erro ao carregar carrinho: ${failure.message}';
        _items.clear();
      },
      (savedItems) {
        _items.clear();
        _items.addAll(savedItems);
      },
    );

    if (showLoading) {
      _isLoading = false;
    }

    notifyListeners();
  }

  Future<String> addItem(Product product) async {
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
      final newItem = CartItem(product: product);
      _items.add(newItem);
      final result = await _repository.saveCartItem(newItem);
      result.fold(
        (failure) {
          _errorMessage = 'Erro ao salvar item: ${failure.message}';
          _items.remove(newItem);
          notifyListeners();
        },
        (_) {},
      );
    }

    notifyListeners();
    return '';
  }

  void removeItem(CartItem cartItem) {
    _items.remove(cartItem);
    notifyListeners();
    _removeCartItem(cartItem);
  }

  Future<void> _removeCartItem(CartItem item) async {
    final result = await _repository.removeCartItem(item.product.id);
    result.fold(
      (failure) {
        _errorMessage = 'Erro ao remover item: ${failure.message}';
        notifyListeners();
      },
      (_) {},
    );
  }

  Future<void> clearCart() async {
    _items.clear();
    notifyListeners();

    final result = await _repository.clearCart();
    result.fold(
      (failure) {
        _errorMessage = 'Erro ao limpar carrinho: ${failure.message}';
      },
      (_) {},
    );
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

  Future<bool> hasStoredCart() async {
    final result = await _repository.hasCartItems();
    return result.fold(
      (failure) => false,
      (hasItems) => hasItems,
    );
  }
}
