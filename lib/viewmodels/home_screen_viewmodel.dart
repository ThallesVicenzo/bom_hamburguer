import 'package:flutter/material.dart';
import 'package:bom_hamburguer/models/product.dart';
import 'package:bom_hamburguer/repositories/product_repository.dart';
import 'package:bom_hamburguer/viewmodels/utils/ui_models.dart';

class HomeScreenViewModel extends ChangeNotifier {
  final ProductRepository _repository;

  List<Product> _products = [];
  bool _isLoading = false;
  UIMessage? _uiMessage;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  UIMessage? get uiMessage => _uiMessage;

  List<Product> get sandwiches =>
      _products.where((p) => p.type == 'sandwich').toList();
  List<Product> get extras =>
      _products.where((p) => p.type == 'extra').toList();

  HomeScreenViewModel(this._repository) {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    final result = await _repository.getProducts();
    result.fold(
      (failure) {
        _products = [];
      },
      (products) {
        _products = products;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  void clearUIMessage() {
    _uiMessage = null;
    notifyListeners();
  }
}
