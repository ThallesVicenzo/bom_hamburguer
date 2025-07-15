import 'package:flutter/material.dart';
import 'package:bom_hamburguer/models/product.dart';
import 'package:bom_hamburguer/repositories/product_repository.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductRepository _repository = ProductRepository();
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  List<Product> get sandwiches =>
      _products.where((p) => p.type == 'sandwich').toList();
  List<Product> get extras =>
      _products.where((p) => p.type == 'extra').toList();

  ProductViewModel() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    _products = await _repository.getProducts();
    _isLoading = false;
    notifyListeners();
  }
}
