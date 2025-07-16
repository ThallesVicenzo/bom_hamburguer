import 'package:bom_hamburguer/models/product.dart';
import 'package:bom_hamburguer/models/cart_item.dart';
import 'package:bom_hamburguer/services/database_service.dart';
import 'package:bom_hamburguer/services/errors/failure.dart';
import 'package:bom_hamburguer/services/errors/failure_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, Product?>> getProductById(int id);
  Future<Either<Failure, void>> addProduct(Product product);
  Future<Either<Failure, void>> updateProduct(Product product);
  Future<Either<Failure, void>> deleteProduct(int id);
  Future<Either<Failure, List<Product>>> getProductsByType(String type);
  Future<Either<Failure, void>> saveCartItem(CartItem cartItem);
  Future<Either<Failure, List<CartItem>>> getCartItems();
  Future<Either<Failure, void>> updateCartItemQuantity(
      int productId, int quantity);
  Future<Either<Failure, void>> removeCartItem(int productId);
  Future<Either<Failure, void>> clearCart();
  Future<Either<Failure, bool>> hasCartItems();
  Future<Either<Failure, CartItem?>> getCartItemByProductId(int productId);
}

class ProductRepositoryImpl implements ProductRepository {
  final DatabaseService _databaseService;

  ProductRepositoryImpl(this._databaseService);

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps =
          await db.query(_databaseService.productsTable);

      final products = List.generate(maps.length, (i) {
        return Product.fromMap(maps[i]);
      });

      return Right(products);
    } catch (e) {
      if (e.toString().contains('DatabaseException')) {
        return Left(ServiceError('Database error: ${e.toString()}'));
      }
      return Left(GenericFailure('Failed to load products: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByType(String type) async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        _databaseService.productsTable,
        where: 'type = ?',
        whereArgs: [type],
      );

      final products = List.generate(maps.length, (i) {
        return Product.fromMap(maps[i]);
      });

      return Right(products);
    } catch (e) {
      if (e.toString().contains('DatabaseException')) {
        return Left(ServiceError('Database error: ${e.toString()}'));
      }
      return Left(
          GenericFailure('Failed to load products by type: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Product?>> getProductById(int id) async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        _databaseService.productsTable,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return Right(Product.fromMap(maps.first));
      }
      return const Right(null);
    } catch (e) {
      if (e.toString().contains('DatabaseException')) {
        return Left(ServiceError('Database error: ${e.toString()}'));
      }
      return Left(
          GenericFailure('Failed to get product by id: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> saveCartItem(CartItem cartItem) async {
    try {
      final db = await _databaseService.database;
      await db.insert(
        _databaseService.cartTable,
        {
          'product_id': cartItem.product.id,
          'product_name': cartItem.product.name,
          'product_price': cartItem.product.price,
          'product_type': cartItem.product.type,
          'product_image_url': cartItem.product.imageUrl,
          'quantity': cartItem.quantity,
          'created_at': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return const Right(null);
    } catch (e) {
      if (e.toString().contains('DatabaseException')) {
        return Left(ServiceError('Database error: ${e.toString()}'));
      }
      return Left(GenericFailure('Failed to save cart item: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> getCartItems() async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        _databaseService.cartTable,
        orderBy: 'created_at ASC',
      );

      final cartItems = List.generate(maps.length, (i) {
        final map = maps[i];
        final product = Product(
          id: map['product_id'],
          name: map['product_name'],
          price: map['product_price'],
          type: map['product_type'],
          imageUrl: map['product_image_url'],
        );

        return CartItem(
          product: product,
          quantity: map['quantity'],
        );
      });

      return Right(cartItems);
    } catch (e) {
      if (e.toString().contains('DatabaseException')) {
        return Left(ServiceError('Database error: ${e.toString()}'));
      }
      return Left(GenericFailure('Failed to get cart items: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateCartItemQuantity(
      int productId, int quantity) async {
    try {
      final db = await _databaseService.database;
      await db.update(
        _databaseService.cartTable,
        {'quantity': quantity},
        where: 'product_id = ?',
        whereArgs: [productId],
      );
      return const Right(null);
    } catch (e) {
      if (e.toString().contains('DatabaseException')) {
        return Left(ServiceError('Database error: ${e.toString()}'));
      }
      return Left(GenericFailure(
          'Failed to update cart item quantity: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> removeCartItem(int productId) async {
    try {
      final db = await _databaseService.database;
      await db.delete(
        _databaseService.cartTable,
        where: 'product_id = ?',
        whereArgs: [productId],
      );
      return const Right(null);
    } catch (e) {
      if (e.toString().contains('DatabaseException')) {
        return Left(ServiceError('Database error: ${e.toString()}'));
      }
      return Left(
          GenericFailure('Failed to remove cart item: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      final db = await _databaseService.database;
      await db.delete(_databaseService.cartTable);
      return const Right(null);
    } catch (e) {
      if (e.toString().contains('DatabaseException')) {
        return Left(ServiceError('Database error: ${e.toString()}'));
      }
      return Left(GenericFailure('Failed to clear cart: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> hasCartItems() async {
    try {
      final db = await _databaseService.database;
      final result = await db.rawQuery(
          'SELECT COUNT(*) as count FROM ${_databaseService.cartTable}');
      final count = result.first['count'] as int;
      return Right(count > 0);
    } catch (e) {
      if (e.toString().contains('DatabaseException')) {
        return Left(ServiceError('Database error: ${e.toString()}'));
      }
      return Left(
          GenericFailure('Failed to check cart items: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, CartItem?>> getCartItemByProductId(
      int productId) async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        _databaseService.cartTable,
        where: 'product_id = ?',
        whereArgs: [productId],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        final map = maps.first;
        final product = Product(
          id: map['product_id'],
          name: map['product_name'],
          price: map['product_price'],
          type: map['product_type'],
          imageUrl: map['product_image_url'],
        );

        final cartItem = CartItem(
          product: product,
          quantity: map['quantity'],
        );
        return Right(cartItem);
      }
      return const Right(null);
    } catch (e) {
      if (e.toString().contains('DatabaseException')) {
        return Left(ServiceError('Database error: ${e.toString()}'));
      }
      return Left(GenericFailure(
          'Failed to get cart item by product id: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> addProduct(Product product) async {
    try {
      final db = await _databaseService.database;
      await db.insert(
        _databaseService.productsTable,
        product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return const Right(null);
    } catch (e) {
      if (e.toString().contains('DatabaseException')) {
        return Left(ServiceError('Database error: ${e.toString()}'));
      }
      return Left(GenericFailure('Failed to add product: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(Product product) async {
    try {
      final db = await _databaseService.database;
      await db.update(
        _databaseService.productsTable,
        product.toMap(),
        where: 'id = ?',
        whereArgs: [product.id],
      );
      return const Right(null);
    } catch (e) {
      if (e.toString().contains('DatabaseException')) {
        return Left(ServiceError('Database error: ${e.toString()}'));
      }
      return Left(GenericFailure('Failed to update product: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(int id) async {
    try {
      final db = await _databaseService.database;
      await db.delete(
        _databaseService.productsTable,
        where: 'id = ?',
        whereArgs: [id],
      );
      return const Right(null);
    } catch (e) {
      if (e.toString().contains('DatabaseException')) {
        return Left(ServiceError('Database error: ${e.toString()}'));
      }
      return Left(GenericFailure('Failed to delete product: ${e.toString()}'));
    }
  }
}
