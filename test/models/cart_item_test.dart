import 'package:flutter_test/flutter_test.dart';
import 'package:bom_hamburguer/models/cart_item.dart';
import 'package:bom_hamburguer/models/product.dart';
import 'dart:convert';

void main() {
  group('CartItem', () {
    late Product testProduct;
    late CartItem testCartItem;
    late Map<String, dynamic> testCartItemMap;
    late String testCartItemJson;

    setUp(() {
      testProduct = Product(
        id: 1,
        name: 'Classic Burger',
        price: 15.5,
        type: 'sandwich',
        imageUrl: 'https://example.com/burger.jpg',
      );

      testCartItem = CartItem(
        product: testProduct,
        quantity: 2,
      );

      testCartItemMap = {
        'product': {
          'id': 1,
          'name': 'Classic Burger',
          'price': 15.5,
          'type': 'sandwich',
          'imageUrl': 'https://example.com/burger.jpg',
        },
        'quantity': 2,
      };

      testCartItemJson = json.encode(testCartItemMap);
    });

    group('Constructor', () {
      test('should create cart item with all required fields', () {
        // Act
        final cartItem = CartItem(
          product: testProduct,
          quantity: 3,
        );

        // Assert
        expect(cartItem.product, equals(testProduct));
        expect(cartItem.quantity, equals(3));
      });

      test('should create cart item with default quantity of 1', () {
        // Act
        final cartItem = CartItem(product: testProduct);

        // Assert
        expect(cartItem.product, equals(testProduct));
        expect(cartItem.quantity, equals(1));
      });

      test('should create cart item with zero quantity', () {
        // Act
        final cartItem = CartItem(
          product: testProduct,
          quantity: 0,
        );

        // Assert
        expect(cartItem.quantity, equals(0));
      });

      test('should create cart item with negative quantity', () {
        // Act
        final cartItem = CartItem(
          product: testProduct,
          quantity: -1,
        );

        // Assert
        expect(cartItem.quantity, equals(-1));
      });

      test('should allow quantity modification after creation', () {
        // Arrange
        final cartItem = CartItem(product: testProduct, quantity: 1);

        // Act
        cartItem.quantity = 5;

        // Assert
        expect(cartItem.quantity, equals(5));
      });
    });

    group('totalPrice', () {
      test('should calculate total price correctly', () {
        // Arrange
        final cartItem = CartItem(
          product: testProduct,
          quantity: 3,
        );

        // Act
        final totalPrice = cartItem.totalPrice;

        // Assert
        expect(totalPrice, equals(46.5)); // 15.5 * 3
      });

      test('should return zero for zero quantity', () {
        // Arrange
        final cartItem = CartItem(
          product: testProduct,
          quantity: 0,
        );

        // Act
        final totalPrice = cartItem.totalPrice;

        // Assert
        expect(totalPrice, equals(0.0));
      });

      test('should handle negative quantity', () {
        // Arrange
        final cartItem = CartItem(
          product: testProduct,
          quantity: -2,
        );

        // Act
        final totalPrice = cartItem.totalPrice;

        // Assert
        expect(totalPrice, equals(-31.0)); // 15.5 * -2
      });

      test('should update total price when quantity changes', () {
        // Arrange
        final cartItem = CartItem(
          product: testProduct,
          quantity: 1,
        );
        expect(cartItem.totalPrice, equals(15.5));

        // Act
        cartItem.quantity = 4;

        // Assert
        expect(cartItem.totalPrice, equals(62.0)); // 15.5 * 4
      });

      test('should handle decimal quantities and prices', () {
        // Arrange
        final expensiveProduct = Product(
          id: 2,
          name: 'Premium Burger',
          price: 25.75,
          type: 'sandwich',
        );
        final cartItem = CartItem(
          product: expensiveProduct,
          quantity: 3,
        );

        // Act
        final totalPrice = cartItem.totalPrice;

        // Assert
        expect(totalPrice, equals(77.25)); // 25.75 * 3
      });

      test('should handle very large quantities', () {
        // Arrange
        final cartItem = CartItem(
          product: testProduct,
          quantity: 1000,
        );

        // Act
        final totalPrice = cartItem.totalPrice;

        // Assert
        expect(totalPrice, equals(15500.0)); // 15.5 * 1000
      });
    });

    group('toMap', () {
      test('should convert cart item to map correctly', () {
        // Act
        final result = testCartItem.toMap();

        // Assert
        expect(result, equals(testCartItemMap));
        expect(result['quantity'], equals(2));
        expect(result['product'], isA<Map<String, dynamic>>());
      });

      test('should include product map in result', () {
        // Act
        final result = testCartItem.toMap();

        // Assert
        final productMap = result['product'] as Map<String, dynamic>;
        expect(productMap['id'], equals(1));
        expect(productMap['name'], equals('Classic Burger'));
        expect(productMap['price'], equals(15.5));
        expect(productMap['type'], equals('sandwich'));
      });

      test('should handle zero quantity in toMap', () {
        // Arrange
        final cartItem = CartItem(
          product: testProduct,
          quantity: 0,
        );

        // Act
        final result = cartItem.toMap();

        // Assert
        expect(result['quantity'], equals(0));
      });

      test('should handle negative quantity in toMap', () {
        // Arrange
        final cartItem = CartItem(
          product: testProduct,
          quantity: -5,
        );

        // Act
        final result = cartItem.toMap();

        // Assert
        expect(result['quantity'], equals(-5));
      });

      test('should contain all required fields', () {
        // Act
        final result = testCartItem.toMap();

        // Assert
        expect(result.containsKey('product'), isTrue);
        expect(result.containsKey('quantity'), isTrue);
        expect(result.keys.length, equals(2));
      });
    });

    group('fromMap', () {
      test('should create cart item from map correctly', () {
        // Act
        final result = CartItem.fromMap(testCartItemMap);

        // Assert
        expect(result.quantity, equals(testCartItem.quantity));
        expect(result.product.id, equals(testCartItem.product.id));
        expect(result.product.name, equals(testCartItem.product.name));
        expect(result.product.price, equals(testCartItem.product.price));
        expect(result.product.type, equals(testCartItem.product.type));
        expect(result.product.imageUrl, equals(testCartItem.product.imageUrl));
      });

      test('should handle zero quantity in fromMap', () {
        // Arrange
        final mapWithZeroQuantity = {
          'product': testProduct.toMap(),
          'quantity': 0,
        };

        // Act
        final result = CartItem.fromMap(mapWithZeroQuantity);

        // Assert
        expect(result.quantity, equals(0));
      });

      test('should handle negative quantity in fromMap', () {
        // Arrange
        final mapWithNegativeQuantity = {
          'product': testProduct.toMap(),
          'quantity': -3,
        };

        // Act
        final result = CartItem.fromMap(mapWithNegativeQuantity);

        // Assert
        expect(result.quantity, equals(-3));
      });

      test('should throw error for missing product', () {
        // Arrange
        final incompleteMap = {
          'quantity': 2,
        };

        // Act & Assert
        expect(
            () => CartItem.fromMap(incompleteMap), throwsA(isA<TypeError>()));
      });

      test('should throw error for missing quantity', () {
        // Arrange
        final incompleteMap = {
          'product': testProduct.toMap(),
        };

        // Act & Assert
        expect(
            () => CartItem.fromMap(incompleteMap), throwsA(isA<TypeError>()));
      });

      test('should handle different numeric types for quantity', () {
        // Arrange
        final mapWithDoubleQuantity = {
          'product': testProduct.toMap(),
          'quantity': 2.0,
        };

        // Act
        final result = CartItem.fromMap(mapWithDoubleQuantity);

        // Assert
        expect(result.quantity, equals(2));
      });
    });

    group('toJson', () {
      test('should convert cart item to JSON string correctly', () {
        // Act
        final result = testCartItem.toJson();

        // Assert
        expect(result, equals(testCartItemJson));
        expect(result, isA<String>());
      });

      test('should create valid JSON that can be parsed', () {
        // Act
        final jsonString = testCartItem.toJson();
        final parsedMap = json.decode(jsonString);

        // Assert
        expect(parsedMap, equals(testCartItemMap));
      });

      test('should handle zero quantity in JSON', () {
        // Arrange
        final cartItem = CartItem(
          product: testProduct,
          quantity: 0,
        );

        // Act
        final jsonString = cartItem.toJson();
        final parsedMap = json.decode(jsonString);

        // Assert
        expect(parsedMap['quantity'], equals(0));
      });

      test('should include nested product data in JSON', () {
        // Act
        final jsonString = testCartItem.toJson();
        final parsedMap = json.decode(jsonString);

        // Assert
        final productData = parsedMap['product'];
        expect(productData['id'], equals(1));
        expect(productData['name'], equals('Classic Burger'));
        expect(productData['price'], equals(15.5));
      });
    });

    group('fromJson', () {
      test('should create cart item from JSON string correctly', () {
        // Act
        final result = CartItem.fromJson(testCartItemJson);

        // Assert
        expect(result.quantity, equals(testCartItem.quantity));
        expect(result.product.id, equals(testCartItem.product.id));
        expect(result.product.name, equals(testCartItem.product.name));
        expect(result.product.price, equals(testCartItem.product.price));
        expect(result.product.type, equals(testCartItem.product.type));
        expect(result.product.imageUrl, equals(testCartItem.product.imageUrl));
      });

      test('should handle zero quantity in JSON', () {
        // Arrange
        final jsonWithZeroQuantity = json.encode({
          'product': testProduct.toMap(),
          'quantity': 0,
        });

        // Act
        final result = CartItem.fromJson(jsonWithZeroQuantity);

        // Assert
        expect(result.quantity, equals(0));
      });

      test('should throw FormatException for invalid JSON', () {
        // Arrange
        const invalidJson = 'invalid json string';

        // Act & Assert
        expect(() => CartItem.fromJson(invalidJson),
            throwsA(isA<FormatException>()));
      });

      test('should throw error for missing required fields', () {
        // Arrange
        final incompleteJson = json.encode({
          'quantity': 2,
          // missing 'product'
        });

        // Act & Assert
        expect(
            () => CartItem.fromJson(incompleteJson), throwsA(isA<TypeError>()));
      });

      test('should handle nested product with null imageUrl', () {
        // Arrange
        final productWithoutImage = Product(
          id: 2,
          name: 'Simple Burger',
          price: 10.0,
          type: 'sandwich',
        );
        final cartItemJson = CartItem(
          product: productWithoutImage,
          quantity: 1,
        ).toJson();

        // Act
        final result = CartItem.fromJson(cartItemJson);

        // Assert
        expect(result.product.imageUrl, isNull);
      });
    });

    group('Roundtrip Conversion', () {
      test('should maintain data integrity through toMap -> fromMap', () {
        // Act
        final map = testCartItem.toMap();
        final reconstructed = CartItem.fromMap(map);

        // Assert
        expect(reconstructed.quantity, equals(testCartItem.quantity));
        expect(reconstructed.product.id, equals(testCartItem.product.id));
        expect(reconstructed.product.name, equals(testCartItem.product.name));
        expect(reconstructed.product.price, equals(testCartItem.product.price));
        expect(reconstructed.product.type, equals(testCartItem.product.type));
        expect(reconstructed.product.imageUrl,
            equals(testCartItem.product.imageUrl));
        expect(reconstructed.totalPrice, equals(testCartItem.totalPrice));
      });

      test('should maintain data integrity through toJson -> fromJson', () {
        // Act
        final jsonString = testCartItem.toJson();
        final reconstructed = CartItem.fromJson(jsonString);

        // Assert
        expect(reconstructed.quantity, equals(testCartItem.quantity));
        expect(reconstructed.product.id, equals(testCartItem.product.id));
        expect(reconstructed.product.name, equals(testCartItem.product.name));
        expect(reconstructed.product.price, equals(testCartItem.product.price));
        expect(reconstructed.product.type, equals(testCartItem.product.type));
        expect(reconstructed.product.imageUrl,
            equals(testCartItem.product.imageUrl));
        expect(reconstructed.totalPrice, equals(testCartItem.totalPrice));
      });

      test('should handle multiple roundtrip conversions', () {
        // Act
        final json1 = testCartItem.toJson();
        final item1 = CartItem.fromJson(json1);
        final json2 = item1.toJson();
        final item2 = CartItem.fromJson(json2);

        // Assert
        expect(item2.quantity, equals(testCartItem.quantity));
        expect(item2.product.id, equals(testCartItem.product.id));
        expect(item2.totalPrice, equals(testCartItem.totalPrice));
      });
    });

    group('Business Logic', () {
      test('should calculate correct total for multiple items', () {
        // Arrange
        final items = [
          CartItem(product: testProduct, quantity: 2), // 15.5 * 2 = 31.0
          CartItem(
              product: Product(id: 2, name: 'Fries', price: 8.0, type: 'side'),
              quantity: 1), // 8.0 * 1 = 8.0
          CartItem(
              product: Product(id: 3, name: 'Drink', price: 5.5, type: 'drink'),
              quantity: 3), // 5.5 * 3 = 16.5
        ];

        // Act
        final totalPrice =
            items.fold(0.0, (sum, item) => sum + item.totalPrice);

        // Assert
        expect(totalPrice, equals(55.5)); // 31.0 + 8.0 + 16.5
      });

      test('should handle quantity updates correctly', () {
        // Arrange
        final cartItem = CartItem(product: testProduct, quantity: 1);
        expect(cartItem.totalPrice, equals(15.5));

        // Act & Assert - increasing quantity
        cartItem.quantity = 3;
        expect(cartItem.totalPrice, equals(46.5));

        // Act & Assert - decreasing quantity
        cartItem.quantity = 1;
        expect(cartItem.totalPrice, equals(15.5));

        // Act & Assert - zero quantity
        cartItem.quantity = 0;
        expect(cartItem.totalPrice, equals(0.0));
      });

      test('should maintain product reference integrity', () {
        // Arrange
        final cartItem = CartItem(product: testProduct, quantity: 2);

        // Act
        cartItem.quantity = 5;

        // Assert - product should remain unchanged
        expect(cartItem.product.id, equals(testProduct.id));
        expect(cartItem.product.name, equals(testProduct.name));
        expect(cartItem.product.price, equals(testProduct.price));
        expect(cartItem.product.type, equals(testProduct.type));
        expect(cartItem.product.imageUrl, equals(testProduct.imageUrl));
      });
    });

    group('Edge Cases', () {
      test('should handle very large quantities', () {
        // Arrange
        final cartItem = CartItem(
          product: testProduct,
          quantity: 1000000,
        );

        // Act
        final totalPrice = cartItem.totalPrice;

        // Assert
        expect(totalPrice, equals(15500000.0)); // 15.5 * 1,000,000
      });

      test('should handle precision with decimal quantities and prices', () {
        // Arrange
        final preciseProduct = Product(
          id: 1,
          name: 'Precise Product',
          price: 12.345,
          type: 'test',
        );
        final cartItem = CartItem(
          product: preciseProduct,
          quantity: 3,
        );

        // Act
        final totalPrice = cartItem.totalPrice;

        // Assert
        expect(totalPrice, closeTo(37.035, 0.001)); // 12.345 * 3
      });

      test('should handle cart item with product having zero price', () {
        // Arrange
        final freeProduct = Product(
          id: 1,
          name: 'Free Sample',
          price: 0.0,
          type: 'sample',
        );
        final cartItem = CartItem(
          product: freeProduct,
          quantity: 5,
        );

        // Act
        final totalPrice = cartItem.totalPrice;

        // Assert
        expect(totalPrice, equals(0.0));
      });

      test('should serialize and deserialize complex nested data', () {
        // Arrange
        final complexProduct = Product(
          id: 999,
          name: 'Complex "Product" with & symbols',
          price: 123.456789,
          type: 'special & unique',
          imageUrl: 'https://example.com/path?param=value&other=123#anchor',
        );
        final cartItem = CartItem(
          product: complexProduct,
          quantity: 42,
        );

        // Act
        final jsonString = cartItem.toJson();
        final reconstructed = CartItem.fromJson(jsonString);

        // Assert
        expect(reconstructed.product.name, equals(complexProduct.name));
        expect(reconstructed.product.type, equals(complexProduct.type));
        expect(reconstructed.product.imageUrl, equals(complexProduct.imageUrl));
        expect(reconstructed.product.price, equals(complexProduct.price));
        expect(reconstructed.quantity, equals(42));
      });
    });
  });
}
