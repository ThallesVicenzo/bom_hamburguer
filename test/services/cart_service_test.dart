import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:bom_hamburguer/services/cart_service.dart';
import 'package:bom_hamburguer/repositories/product_repository.dart';
import 'package:bom_hamburguer/models/product.dart';
import 'package:bom_hamburguer/models/cart_item.dart';
import 'package:bom_hamburguer/services/errors/failure_impl.dart';

import 'cart_service_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late CartService cartService;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    when(mockRepository.getCartItems())
        .thenAnswer((_) async => const Right([]));
    cartService = CartService(mockRepository);
  });

  group('CartService', () {
    group('Initialization', () {
      test('should initialize with empty cart', () async {
        await Future.delayed(Duration.zero);

        expect(cartService.items, isEmpty);
        expect(cartService.isEmpty, isTrue);
        expect(cartService.isNotEmpty, isFalse);
        expect(cartService.itemCount, equals(0));
        expect(cartService.totalQuantity, equals(0));
      });

      test('should load saved cart on initialization', () async {
        final savedItems = [
          CartItem(
              product: Product(
                  id: 1, name: 'xBurger', price: 10.0, type: 'sandwich')),
          CartItem(
              product:
                  Product(id: 2, name: 'fries', price: 5.0, type: 'extra')),
        ];

        when(mockRepository.getCartItems())
            .thenAnswer((_) async => Right(savedItems));

        final newCartService = CartService(mockRepository);
        await newCartService.initializeCart();

        expect(newCartService.items.length, equals(2));
        expect(newCartService.itemCount, equals(2));
        expect(newCartService.isEmpty, isFalse);
        verify(mockRepository.getCartItems()).called(greaterThanOrEqualTo(2));
      });

      test('should handle error when loading saved cart', () async {
        when(mockRepository.getCartItems()).thenAnswer(
            (_) async => const Left(DatabaseFailure('Database error')));

        final newCartService = CartService(mockRepository);
        await newCartService.initializeCart();

        expect(newCartService.items, isEmpty);
        expect(
            newCartService.errorMessage, contains('Erro ao carregar carrinho'));
      });
    });

    group('Add Item', () {
      test('should add item to cart successfully', () async {
        final product =
            Product(id: 1, name: 'xBurger', price: 10.0, type: 'sandwich');
        when(mockRepository.getCartItems())
            .thenAnswer((_) async => const Right([]));
        when(mockRepository.saveCartItem(any))
            .thenAnswer((_) async => const Right(null));

        await cartService.initializeCart();

        final result = await cartService.addItem(product);

        expect(result, isEmpty);
        expect(cartService.items.length, equals(1));
        expect(cartService.items.first.product.id, equals(1));
        verify(mockRepository.saveCartItem(any)).called(1);
      });

      test('should prevent adding duplicate item', () async {
        final product =
            Product(id: 1, name: 'specialItem', price: 5.0, type: 'extra');
        final existingItems = [CartItem(product: product)];

        when(mockRepository.getCartItems())
            .thenAnswer((_) async => Right(existingItems));

        await cartService.initializeCart();

        final result = await cartService.addItem(product);

        expect(result, equals('itemAlreadyInCart'));
        expect(cartService.items.length, equals(1));
        verifyNever(mockRepository.saveCartItem(any));
      });

      test('should prevent adding more than one sandwich', () async {
        final sandwich1 =
            Product(id: 1, name: 'xBurger', price: 10.0, type: 'sandwich');
        final sandwich2 =
            Product(id: 2, name: 'xEgg', price: 12.0, type: 'sandwich');
        final existingItems = [CartItem(product: sandwich1)];

        when(mockRepository.getCartItems())
            .thenAnswer((_) async => Right(existingItems));

        await cartService.initializeCart();

        final result = await cartService.addItem(sandwich2);

        expect(result, equals('onlyOneSandwich'));
        expect(cartService.items.length, equals(1));
        verifyNever(mockRepository.saveCartItem(any));
      });

      test('should prevent adding more than one fries', () async {
        final fries = Product(id: 1, name: 'fries', price: 5.0, type: 'extra');
        final newFries =
            Product(id: 2, name: 'fries', price: 5.0, type: 'extra');
        final existingItems = [CartItem(product: fries)];

        when(mockRepository.getCartItems())
            .thenAnswer((_) async => Right(existingItems));

        await cartService.initializeCart();

        final result = await cartService.addItem(newFries);

        expect(result, equals('onlyOneFries'));
        expect(cartService.items.length, equals(1));
        verifyNever(mockRepository.saveCartItem(any));
      });

      test('should prevent adding more than one soft drink', () async {
        final drink =
            Product(id: 1, name: 'softDrink', price: 3.0, type: 'extra');
        final newDrink =
            Product(id: 2, name: 'softDrink', price: 3.0, type: 'extra');
        final existingItems = [CartItem(product: drink)];

        when(mockRepository.getCartItems())
            .thenAnswer((_) async => Right(existingItems));

        await cartService.initializeCart();

        final result = await cartService.addItem(newDrink);

        expect(result, equals('onlyOneDrink'));
        expect(cartService.items.length, equals(1));
        verifyNever(mockRepository.saveCartItem(any));
      });

      test('should handle save error and remove item from memory', () async {
        final product =
            Product(id: 1, name: 'xBurger', price: 10.0, type: 'sandwich');
        when(mockRepository.getCartItems())
            .thenAnswer((_) async => const Right([]));
        when(mockRepository.saveCartItem(any))
            .thenAnswer((_) async => const Left(DatabaseFailure('Save error')));

        await cartService.initializeCart();

        final result = await cartService.addItem(product);

        expect(result, isEmpty);
        expect(cartService.items, isEmpty);
        expect(cartService.errorMessage, contains('Erro ao salvar item'));
      });
    });

    group('Remove Item', () {
      test('should remove item from cart', () async {
        final product =
            Product(id: 1, name: 'xBurger', price: 10.0, type: 'sandwich');
        final cartItem = CartItem(product: product);
        final existingItems = [cartItem];

        when(mockRepository.getCartItems())
            .thenAnswer((_) async => Right(existingItems));
        when(mockRepository.removeCartItem(1))
            .thenAnswer((_) async => const Right(null));

        await cartService.initializeCart();

        cartService.removeItem(cartItem);

        expect(cartService.items, isEmpty);
        verify(mockRepository.removeCartItem(1)).called(1);
      });

      test('should handle remove error', () async {
        final product =
            Product(id: 1, name: 'xBurger', price: 10.0, type: 'sandwich');
        final cartItem = CartItem(product: product);
        final existingItems = [cartItem];

        when(mockRepository.getCartItems())
            .thenAnswer((_) async => Right(existingItems));
        when(mockRepository.removeCartItem(1)).thenAnswer(
            (_) async => const Left(DatabaseFailure('Remove error')));

        await cartService.initializeCart();

        cartService.removeItem(cartItem);

        await Future.delayed(const Duration(milliseconds: 10));

        expect(cartService.items, isEmpty);
        expect(cartService.errorMessage, contains('Erro ao remover item'));
      });
    });

    group('Clear Cart', () {
      test('should clear all items from cart', () async {
        final existingItems = [
          CartItem(
              product: Product(
                  id: 1, name: 'xBurger', price: 10.0, type: 'sandwich')),
          CartItem(
              product:
                  Product(id: 2, name: 'fries', price: 5.0, type: 'extra')),
        ];

        when(mockRepository.getCartItems())
            .thenAnswer((_) async => Right(existingItems));
        when(mockRepository.clearCart())
            .thenAnswer((_) async => const Right(null));

        await cartService.initializeCart();

        await cartService.clearCart();

        expect(cartService.items, isEmpty);
        expect(cartService.isEmpty, isTrue);
        verify(mockRepository.clearCart()).called(1);
      });

      test('should handle clear error', () async {
        when(mockRepository.getCartItems())
            .thenAnswer((_) async => const Right([]));
        when(mockRepository.clearCart()).thenAnswer(
            (_) async => const Left(DatabaseFailure('Clear error')));

        await cartService.initializeCart();

        await cartService.clearCart();

        expect(cartService.items, isEmpty);
        expect(cartService.errorMessage, contains('Erro ao limpar carrinho'));
      });
    });

    group('Calculations', () {
      test('should calculate subtotal correctly', () async {
        final existingItems = [
          CartItem(
              product: Product(
                  id: 1, name: 'xBurger', price: 10.0, type: 'sandwich')),
          CartItem(
              product:
                  Product(id: 2, name: 'fries', price: 5.0, type: 'extra')),
          CartItem(
              product:
                  Product(id: 3, name: 'softDrink', price: 3.0, type: 'extra')),
        ];

        when(mockRepository.getCartItems())
            .thenAnswer((_) async => Right(existingItems));

        await cartService.initializeCart();

        expect(cartService.getSubtotal(), equals(18.0));
      });

      test('should calculate 20% discount for full combo', () async {
        final existingItems = [
          CartItem(
              product: Product(
                  id: 1, name: 'xBurger', price: 10.0, type: 'sandwich')),
          CartItem(
              product:
                  Product(id: 2, name: 'fries', price: 5.0, type: 'extra')),
          CartItem(
              product:
                  Product(id: 3, name: 'softDrink', price: 3.0, type: 'extra')),
        ];

        when(mockRepository.getCartItems())
            .thenAnswer((_) async => Right(existingItems));

        await cartService.initializeCart();

        expect(cartService.getDiscount(), equals(3.6));
        expect(cartService.getDiscountDescription(), equals('comboDiscount'));
        expect(cartService.getTotal(), equals(14.4));
      });

      test('should calculate 15% discount for sandwich + drink', () async {
        final existingItems = [
          CartItem(
              product: Product(
                  id: 1, name: 'xBurger', price: 10.0, type: 'sandwich')),
          CartItem(
              product:
                  Product(id: 3, name: 'softDrink', price: 3.0, type: 'extra')),
        ];

        when(mockRepository.getCartItems())
            .thenAnswer((_) async => Right(existingItems));

        await cartService.initializeCart();

        expect(cartService.getDiscount(), equals(1.95));
        expect(cartService.getDiscountDescription(), equals('drinkDiscount'));
        expect(cartService.getTotal(), equals(11.05));
      });

      test('should calculate 10% discount for sandwich + fries', () async {
        final existingItems = [
          CartItem(
              product: Product(
                  id: 1, name: 'xBurger', price: 10.0, type: 'sandwich')),
          CartItem(
              product:
                  Product(id: 2, name: 'fries', price: 5.0, type: 'extra')),
        ];

        when(mockRepository.getCartItems())
            .thenAnswer((_) async => Right(existingItems));

        await cartService.initializeCart();

        expect(cartService.getDiscount(), equals(1.5));
        expect(cartService.getDiscountDescription(), equals('friesDiscount'));
        expect(cartService.getTotal(), equals(13.5));
      });

      test('should not apply discount for single items', () async {
        final existingItems = [
          CartItem(
              product: Product(
                  id: 1, name: 'xBurger', price: 10.0, type: 'sandwich')),
        ];

        when(mockRepository.getCartItems())
            .thenAnswer((_) async => Right(existingItems));

        await cartService.initializeCart();

        expect(cartService.getDiscount(), equals(0.0));
        expect(cartService.getDiscountDescription(), isEmpty);
        expect(cartService.getTotal(), equals(10.0));
      });
    });

    group('Has Stored Cart', () {
      test('should return true when cart has items', () async {
        // Arrange
        when(mockRepository.hasCartItems())
            .thenAnswer((_) async => const Right(true));

        // Act
        final result = await cartService.hasStoredCart();

        // Assert
        expect(result, isTrue);
        verify(mockRepository.hasCartItems()).called(1);
      });

      test('should return false when cart is empty', () async {
        // Arrange
        when(mockRepository.hasCartItems())
            .thenAnswer((_) async => const Right(false));

        // Act
        final result = await cartService.hasStoredCart();

        // Assert
        expect(result, isFalse);
        verify(mockRepository.hasCartItems()).called(1);
      });

      test('should return false on error', () async {
        // Arrange
        when(mockRepository.hasCartItems()).thenAnswer(
            (_) async => const Left(DatabaseFailure('Database error')));

        // Act
        final result = await cartService.hasStoredCart();

        // Assert
        expect(result, isFalse);
      });
    });

    group('Error Handling', () {
      test('should clear error message', () async {
        // Arrange
        when(mockRepository.getCartItems()).thenAnswer(
            (_) async => const Left(DatabaseFailure('Database error')));

        await cartService.initializeCart();
        expect(cartService.errorMessage, isNotNull);

        // Act
        cartService.clearError();

        // Assert
        expect(cartService.errorMessage, isNull);
      });
    });

    group('Total Quantity', () {
      test('should calculate total quantity correctly', () async {
        // Arrange
        final existingItems = [
          CartItem(
              product: Product(
                  id: 1, name: 'xBurger', price: 10.0, type: 'sandwich'),
              quantity: 1),
          CartItem(
              product: Product(id: 2, name: 'fries', price: 5.0, type: 'extra'),
              quantity: 2),
          CartItem(
              product:
                  Product(id: 3, name: 'softDrink', price: 3.0, type: 'extra'),
              quantity: 1),
        ];

        when(mockRepository.getCartItems())
            .thenAnswer((_) async => Right(existingItems));

        await cartService.initializeCart();

        // Act & Assert
        expect(cartService.totalQuantity, equals(4));
      });
    });
  });
}
