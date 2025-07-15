import 'package:bom_hamburguer/models/product.dart';

class ProductRepository {
  Future<List<Product>> getProducts() async {
    return [
      Product(id: 1, name: 'xBurger', price: 5.00, type: 'sandwich'),
      Product(id: 2, name: 'xEgg', price: 4.50, type: 'sandwich'),
      Product(id: 3, name: 'xBacon', price: 7.00, type: 'sandwich'),
      Product(id: 4, name: 'fries', price: 2.00, type: 'extra'),
      Product(id: 5, name: 'softDrink', price: 2.50, type: 'extra'),
    ];
  }
}
