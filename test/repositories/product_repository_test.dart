import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bom_hamburguer/repositories/product_repository.dart';
import 'package:bom_hamburguer/services/database_service.dart';
import 'package:bom_hamburguer/models/product.dart';
import 'package:bom_hamburguer/models/cart_item.dart';
import 'package:bom_hamburguer/services/errors/failure_impl.dart';

import 'product_repository_test.mocks.dart';

// Simple exception class for database errors
class TestDatabaseException implements Exception {
  final String message;
  TestDatabaseException(this.message);

  @override
  String toString() => 'DatabaseException: $message';
}

@GenerateMocks([DatabaseService, Database])
void main() {
  late ProductRepositoryImpl repository;
  late MockDatabaseService mockDatabaseService;
  late MockDatabase mockDatabase;

  setUp(() {
    mockDatabaseService = MockDatabaseService();
    mockDatabase = MockDatabase();
    repository = ProductRepositoryImpl(mockDatabaseService);

    when(mockDatabaseService.database).thenAnswer((_) async => mockDatabase);
    when(mockDatabaseService.productsTable).thenReturn('products');
    when(mockDatabaseService.cartTable).thenReturn('cart_items');
  });

  group('ProductRepository', () {
    group('getProducts', () {
      test('should return list of products successfully', () async {
        // Arrange
        final productsData = [
          {
            'id': 1,
            'name': 'Classic Burger',
            'price': 15.5,
            'type': 'sandwich',
            'imageUrl': null,
          },
          {
            'id': 2,
            'name': 'fries',
            'price': 8.0,
            'type': 'extra',
            'imageUrl': null,
          },
        ];

        when(mockDatabase.query('products'))
            .thenAnswer((_) async => productsData);

        // Act
        final result = await repository.getProducts();

        // Assert
        expect(result.isRight(), isTrue);
        final products = result.getOrElse(() => []);
        expect(products.length, equals(2));
        expect(products[0].name, equals('Classic Burger'));
        expect(products[1].name, equals('fries'));
        verify(mockDatabase.query('products')).called(1);
      });

      test('should handle database exception', () async {
        // Arrange
        when(mockDatabase.query('products'))
            .thenThrow(TestDatabaseException('Database error'));

        // Act
        final result = await repository.getProducts();

        // Assert
        expect(result.isLeft(), isTrue);
        final failure = result.fold((l) => l, (r) => null);
        expect(failure, isA<ServiceError>());
        expect(failure!.message, contains('Database error'));
      });

      test('should handle generic exception', () async {
        // Arrange
        when(mockDatabase.query('products'))
            .thenThrow(Exception('Generic error'));

        // Act
        final result = await repository.getProducts();

        // Assert
        expect(result.isLeft(), isTrue);
        final failure = result.fold((l) => l, (r) => null);
        expect(failure, isA<GenericFailure>());
        expect(failure!.message, contains('Failed to load products'));
      });
    });

    group('getProductsByType', () {
      test('should return products of specific type', () async {
        // Arrange
        final sandwichData = [
          {
            'id': 1,
            'name': 'Classic Burger',
            'price': 15.5,
            'type': 'sandwich',
            'imageUrl': null,
          },
        ];

        when(mockDatabase.query(
          'products',
          where: 'type = ?',
          whereArgs: ['sandwich'],
        )).thenAnswer((_) async => sandwichData);

        // Act
        final result = await repository.getProductsByType('sandwich');

        // Assert
        expect(result.isRight(), isTrue);
        final products = result.getOrElse(() => []);
        expect(products.length, equals(1));
        expect(products[0].type, equals('sandwich'));
        verify(mockDatabase.query(
          'products',
          where: 'type = ?',
          whereArgs: ['sandwich'],
        )).called(1);
      });

      test('should handle database exception for getProductsByType', () async {
        // Arrange
        when(mockDatabase.query(
          'products',
          where: 'type = ?',
          whereArgs: ['sandwich'],
        )).thenThrow(TestDatabaseException('Database error'));

        // Act
        final result = await repository.getProductsByType('sandwich');

        // Assert
        expect(result.isLeft(), isTrue);
        final failure = result.fold((l) => l, (r) => null);
        expect(failure, isA<ServiceError>());
      });
    });

    group('getProductById', () {
      test('should return product when found', () async {
        // Arrange
        final productData = [
          {
            'id': 1,
            'name': 'Classic Burger',
            'price': 15.5,
            'type': 'sandwich',
            'imageUrl': null,
          },
        ];

        when(mockDatabase.query(
          'products',
          where: 'id = ?',
          whereArgs: [1],
          limit: 1,
        )).thenAnswer((_) async => productData);

        // Act
        final result = await repository.getProductById(1);

        // Assert
        expect(result.isRight(), isTrue);
        final product = result.getOrElse(() => null);
        expect(product, isNotNull);
        expect(product!.id, equals(1));
        expect(product.name, equals('Classic Burger'));
      });

      test('should return null when product not found', () async {
        // Arrange
        when(mockDatabase.query(
          'products',
          where: 'id = ?',
          whereArgs: [999],
          limit: 1,
        )).thenAnswer((_) async => []);

        // Act
        final result = await repository.getProductById(999);

        // Assert
        expect(result.isRight(), isTrue);
        final product = result
            .getOrElse(() => Product(id: 0, name: '', price: 0, type: ''));
        expect(product, isNull);
      });

      test('should handle database exception for getProductById', () async {
        // Arrange
        when(mockDatabase.query(
          'products',
          where: 'id = ?',
          whereArgs: [1],
          limit: 1,
        )).thenThrow(TestDatabaseException('Database error'));

        // Act
        final result = await repository.getProductById(1);

        // Assert
        expect(result.isLeft(), isTrue);
        final failure = result.fold((l) => l, (r) => null);
        expect(failure, isA<ServiceError>());
      });
    });

    group('addProduct', () {
      test('should add product successfully', () async {
        // Arrange
        final product = Product(
          id: 1,
          name: 'Test Burger',
          price: 20.0,
          type: 'sandwich',
        );

        when(mockDatabase.insert(
          'products',
          product.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        )).thenAnswer((_) async => 1);

        // Act
        final result = await repository.addProduct(product);

        // Assert
        expect(result.isRight(), isTrue);
        verify(mockDatabase.insert(
          'products',
          product.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        )).called(1);
      });

      test('should handle database exception for addProduct', () async {
        // Arrange
        final product = Product(
          id: 1,
          name: 'Test Burger',
          price: 20.0,
          type: 'sandwich',
        );

        when(mockDatabase.insert(
          'products',
          product.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        )).thenThrow(TestDatabaseException('Database error'));

        // Act
        final result = await repository.addProduct(product);

        // Assert
        expect(result.isLeft(), isTrue);
        final failure = result.fold((l) => l, (r) => null);
        expect(failure, isA<ServiceError>());
      });
    });

    group('updateProduct', () {
      test('should update product successfully', () async {
        // Arrange
        final product = Product(
          id: 1,
          name: 'Updated Burger',
          price: 25.0,
          type: 'sandwich',
        );

        when(mockDatabase.update(
          'products',
          product.toMap(),
          where: 'id = ?',
          whereArgs: [1],
        )).thenAnswer((_) async => 1);

        // Act
        final result = await repository.updateProduct(product);

        // Assert
        expect(result.isRight(), isTrue);
        verify(mockDatabase.update(
          'products',
          product.toMap(),
          where: 'id = ?',
          whereArgs: [1],
        )).called(1);
      });

      test('should handle database exception for updateProduct', () async {
        // Arrange
        final product = Product(
          id: 1,
          name: 'Updated Burger',
          price: 25.0,
          type: 'sandwich',
        );

        when(mockDatabase.update(
          'products',
          product.toMap(),
          where: 'id = ?',
          whereArgs: [1],
        )).thenThrow(TestDatabaseException('Database error'));

        // Act
        final result = await repository.updateProduct(product);

        // Assert
        expect(result.isLeft(), isTrue);
        final failure = result.fold((l) => l, (r) => null);
        expect(failure, isA<ServiceError>());
      });
    });

    group('deleteProduct', () {
      test('should delete product successfully', () async {
        // Arrange
        when(mockDatabase.delete(
          'products',
          where: 'id = ?',
          whereArgs: [1],
        )).thenAnswer((_) async => 1);

        // Act
        final result = await repository.deleteProduct(1);

        // Assert
        expect(result.isRight(), isTrue);
        verify(mockDatabase.delete(
          'products',
          where: 'id = ?',
          whereArgs: [1],
        )).called(1);
      });

      test('should handle database exception for deleteProduct', () async {
        // Arrange
        when(mockDatabase.delete(
          'products',
          where: 'id = ?',
          whereArgs: [1],
        )).thenThrow(TestDatabaseException('Database error'));

        // Act
        final result = await repository.deleteProduct(1);

        // Assert
        expect(result.isLeft(), isTrue);
        final failure = result.fold((l) => l, (r) => null);
        expect(failure, isA<ServiceError>());
      });
    });

    group('saveCartItem', () {
      test('should save cart item successfully', () async {
        // Arrange
        final product = Product(
          id: 1,
          name: 'Classic Burger',
          price: 15.5,
          type: 'sandwich',
        );
        final cartItem = CartItem(product: product, quantity: 1);

        when(mockDatabase.insert(
          'cart_items',
          any,
          conflictAlgorithm: ConflictAlgorithm.replace,
        )).thenAnswer((_) async => 1);

        // Act
        final result = await repository.saveCartItem(cartItem);

        // Assert
        expect(result.isRight(), isTrue);
        verify(mockDatabase.insert(
          'cart_items',
          any,
          conflictAlgorithm: ConflictAlgorithm.replace,
        )).called(1);
      });

      test('should handle database exception for saveCartItem', () async {
        // Arrange
        final product = Product(
          id: 1,
          name: 'Classic Burger',
          price: 15.5,
          type: 'sandwich',
        );
        final cartItem = CartItem(product: product, quantity: 1);

        when(mockDatabase.insert(
          'cart_items',
          any,
          conflictAlgorithm: ConflictAlgorithm.replace,
        )).thenThrow(TestDatabaseException('Database error'));

        // Act
        final result = await repository.saveCartItem(cartItem);

        // Assert
        expect(result.isLeft(), isTrue);
        final failure = result.fold((l) => l, (r) => null);
        expect(failure, isA<ServiceError>());
      });
    });

    group('getCartItems', () {
      test('should return list of cart items successfully', () async {
        // Arrange
        final cartData = [
          {
            'product_id': 1,
            'product_name': 'Classic Burger',
            'product_price': 15.5,
            'product_type': 'sandwich',
            'product_image_url': null,
            'quantity': 1,
          },
          {
            'product_id': 2,
            'product_name': 'fries',
            'product_price': 8.0,
            'product_type': 'extra',
            'product_image_url': null,
            'quantity': 2,
          },
        ];

        when(mockDatabase.query(
          'cart_items',
          orderBy: 'created_at ASC',
        )).thenAnswer((_) async => cartData);

        // Act
        final result = await repository.getCartItems();

        // Assert
        expect(result.isRight(), isTrue);
        final cartItems = result.getOrElse(() => []);
        expect(cartItems.length, equals(2));
        expect(cartItems[0].product.name, equals('Classic Burger'));
        expect(cartItems[0].quantity, equals(1));
        expect(cartItems[1].quantity, equals(2));
      });

      test('should handle database exception for getCartItems', () async {
        // Arrange
        when(mockDatabase.query(
          'cart_items',
          orderBy: 'created_at ASC',
        )).thenThrow(TestDatabaseException('Database error'));

        // Act
        final result = await repository.getCartItems();

        // Assert
        expect(result.isLeft(), isTrue);
        final failure = result.fold((l) => l, (r) => null);
        expect(failure, isA<ServiceError>());
      });
    });

    group('updateCartItemQuantity', () {
      test('should update cart item quantity successfully', () async {
        // Arrange
        when(mockDatabase.update(
          'cart_items',
          {'quantity': 3},
          where: 'product_id = ?',
          whereArgs: [1],
        )).thenAnswer((_) async => 1);

        // Act
        final result = await repository.updateCartItemQuantity(1, 3);

        // Assert
        expect(result.isRight(), isTrue);
        verify(mockDatabase.update(
          'cart_items',
          {'quantity': 3},
          where: 'product_id = ?',
          whereArgs: [1],
        )).called(1);
      });

      test('should handle database exception for updateCartItemQuantity',
          () async {
        // Arrange
        when(mockDatabase.update(
          'cart_items',
          {'quantity': 3},
          where: 'product_id = ?',
          whereArgs: [1],
        )).thenThrow(TestDatabaseException('Database error'));

        // Act
        final result = await repository.updateCartItemQuantity(1, 3);

        // Assert
        expect(result.isLeft(), isTrue);
        final failure = result.fold((l) => l, (r) => null);
        expect(failure, isA<ServiceError>());
      });
    });

    group('removeCartItem', () {
      test('should remove cart item successfully', () async {
        // Arrange
        when(mockDatabase.delete(
          'cart_items',
          where: 'product_id = ?',
          whereArgs: [1],
        )).thenAnswer((_) async => 1);

        // Act
        final result = await repository.removeCartItem(1);

        // Assert
        expect(result.isRight(), isTrue);
        verify(mockDatabase.delete(
          'cart_items',
          where: 'product_id = ?',
          whereArgs: [1],
        )).called(1);
      });

      test('should handle database exception for removeCartItem', () async {
        // Arrange
        when(mockDatabase.delete(
          'cart_items',
          where: 'product_id = ?',
          whereArgs: [1],
        )).thenThrow(TestDatabaseException('Database error'));

        // Act
        final result = await repository.removeCartItem(1);

        // Assert
        expect(result.isLeft(), isTrue);
        final failure = result.fold((l) => l, (r) => null);
        expect(failure, isA<ServiceError>());
      });
    });

    group('clearCart', () {
      test('should clear cart successfully', () async {
        // Arrange
        when(mockDatabase.delete('cart_items')).thenAnswer((_) async => 5);

        // Act
        final result = await repository.clearCart();

        // Assert
        expect(result.isRight(), isTrue);
        verify(mockDatabase.delete('cart_items')).called(1);
      });

      test('should handle database exception for clearCart', () async {
        // Arrange
        when(mockDatabase.delete('cart_items'))
            .thenThrow(TestDatabaseException('Database error'));

        // Act
        final result = await repository.clearCart();

        // Assert
        expect(result.isLeft(), isTrue);
        final failure = result.fold((l) => l, (r) => null);
        expect(failure, isA<ServiceError>());
      });
    });

    group('hasCartItems', () {
      test('should return true when cart has items', () async {
        // Arrange
        when(mockDatabase.rawQuery('SELECT COUNT(*) as count FROM cart_items'))
            .thenAnswer((_) async => [
                  {'count': 3}
                ]);

        // Act
        final result = await repository.hasCartItems();

        // Assert
        expect(result.isRight(), isTrue);
        final hasItems = result.getOrElse(() => false);
        expect(hasItems, isTrue);
      });

      test('should return false when cart is empty', () async {
        // Arrange
        when(mockDatabase.rawQuery('SELECT COUNT(*) as count FROM cart_items'))
            .thenAnswer((_) async => [
                  {'count': 0}
                ]);

        // Act
        final result = await repository.hasCartItems();

        // Assert
        expect(result.isRight(), isTrue);
        final hasItems = result.getOrElse(() => true);
        expect(hasItems, isFalse);
      });

      test('should handle database exception for hasCartItems', () async {
        // Arrange
        when(mockDatabase.rawQuery('SELECT COUNT(*) as count FROM cart_items'))
            .thenThrow(TestDatabaseException('Database error'));

        // Act
        final result = await repository.hasCartItems();

        // Assert
        expect(result.isLeft(), isTrue);
        final failure = result.fold((l) => l, (r) => null);
        expect(failure, isA<ServiceError>());
      });
    });

    group('getCartItemByProductId', () {
      test('should return cart item when found', () async {
        // Arrange
        final cartData = [
          {
            'product_id': 1,
            'product_name': 'Classic Burger',
            'product_price': 15.5,
            'product_type': 'sandwich',
            'product_image_url': null,
            'quantity': 2,
          },
        ];

        when(mockDatabase.query(
          'cart_items',
          where: 'product_id = ?',
          whereArgs: [1],
          limit: 1,
        )).thenAnswer((_) async => cartData);

        // Act
        final result = await repository.getCartItemByProductId(1);

        // Assert
        expect(result.isRight(), isTrue);
        final cartItem = result.getOrElse(() => null);
        expect(cartItem, isNotNull);
        expect(cartItem!.product.id, equals(1));
        expect(cartItem.quantity, equals(2));
      });

      test('should return null when cart item not found', () async {
        // Arrange
        when(mockDatabase.query(
          'cart_items',
          where: 'product_id = ?',
          whereArgs: [999],
          limit: 1,
        )).thenAnswer((_) async => []);

        // Act
        final result = await repository.getCartItemByProductId(999);

        // Assert
        expect(result.isRight(), isTrue);
        final cartItem = result.getOrElse(() => CartItem(
              product: Product(id: 0, name: '', price: 0, type: ''),
              quantity: 0,
            ));
        expect(cartItem, isNull);
      });

      test('should handle database exception for getCartItemByProductId',
          () async {
        // Arrange
        when(mockDatabase.query(
          'cart_items',
          where: 'product_id = ?',
          whereArgs: [1],
          limit: 1,
        )).thenThrow(TestDatabaseException('Database error'));

        // Act
        final result = await repository.getCartItemByProductId(1);

        // Assert
        expect(result.isLeft(), isTrue);
        final failure = result.fold((l) => l, (r) => null);
        expect(failure, isA<ServiceError>());
      });
    });
  });
}
