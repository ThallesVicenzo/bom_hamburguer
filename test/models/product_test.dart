import 'package:flutter_test/flutter_test.dart';
import 'package:bom_hamburguer/models/product.dart';
import 'dart:convert';

void main() {
  group('Product', () {
    late Product testProduct;
    late Map<String, dynamic> testProductMap;
    late String testProductJson;

    setUp(() {
      testProduct = Product(
        id: 1,
        name: 'Classic Burger',
        price: 15.5,
        type: 'sandwich',
        imageUrl: 'https://example.com/burger.jpg',
      );

      testProductMap = {
        'id': 1,
        'name': 'Classic Burger',
        'price': 15.5,
        'type': 'sandwich',
        'imageUrl': 'https://example.com/burger.jpg',
      };

      testProductJson = json.encode(testProductMap);
    });

    group('Constructor', () {
      test('should create product with all required fields', () {
        // Act
        final product = Product(
          id: 1,
          name: 'Test Product',
          price: 10.0,
          type: 'test',
        );

        // Assert
        expect(product.id, equals(1));
        expect(product.name, equals('Test Product'));
        expect(product.price, equals(10.0));
        expect(product.type, equals('test'));
        expect(product.imageUrl, isNull);
      });

      test('should create product with optional imageUrl', () {
        // Act
        final product = Product(
          id: 1,
          name: 'Test Product',
          price: 10.0,
          type: 'test',
          imageUrl: 'test_url',
        );

        // Assert
        expect(product.id, equals(1));
        expect(product.name, equals('Test Product'));
        expect(product.price, equals(10.0));
        expect(product.type, equals('test'));
        expect(product.imageUrl, equals('test_url'));
      });

      test('should handle negative price', () {
        // Act
        final product = Product(
          id: 1,
          name: 'Free Product',
          price: -5.0,
          type: 'test',
        );

        // Assert
        expect(product.price, equals(-5.0));
      });

      test('should handle zero price', () {
        // Act
        final product = Product(
          id: 1,
          name: 'Free Product',
          price: 0.0,
          type: 'test',
        );

        // Assert
        expect(product.price, equals(0.0));
      });

      test('should handle empty strings', () {
        // Act
        final product = Product(
          id: 0,
          name: '',
          price: 0.0,
          type: '',
          imageUrl: '',
        );

        // Assert
        expect(product.id, equals(0));
        expect(product.name, equals(''));
        expect(product.price, equals(0.0));
        expect(product.type, equals(''));
        expect(product.imageUrl, equals(''));
      });
    });

    group('toMap', () {
      test('should convert product to map correctly', () {
        // Act
        final result = testProduct.toMap();

        // Assert
        expect(result, equals(testProductMap));
        expect(result['id'], equals(1));
        expect(result['name'], equals('Classic Burger'));
        expect(result['price'], equals(15.5));
        expect(result['type'], equals('sandwich'));
        expect(result['imageUrl'], equals('https://example.com/burger.jpg'));
      });

      test('should handle null imageUrl in toMap', () {
        // Arrange
        final product = Product(
          id: 1,
          name: 'Test Product',
          price: 10.0,
          type: 'test',
        );

        // Act
        final result = product.toMap();

        // Assert
        expect(result['imageUrl'], isNull);
        expect(result.containsKey('imageUrl'), isTrue);
      });

      test('should include all required fields in map', () {
        // Act
        final result = testProduct.toMap();

        // Assert
        expect(result.containsKey('id'), isTrue);
        expect(result.containsKey('name'), isTrue);
        expect(result.containsKey('price'), isTrue);
        expect(result.containsKey('type'), isTrue);
        expect(result.containsKey('imageUrl'), isTrue);
      });
    });

    group('fromMap', () {
      test('should create product from map correctly', () {
        // Act
        final result = Product.fromMap(testProductMap);

        // Assert
        expect(result.id, equals(testProduct.id));
        expect(result.name, equals(testProduct.name));
        expect(result.price, equals(testProduct.price));
        expect(result.type, equals(testProduct.type));
        expect(result.imageUrl, equals(testProduct.imageUrl));
      });

      test('should handle null imageUrl in fromMap', () {
        // Arrange
        final mapWithNullImage = {
          'id': 1,
          'name': 'Test Product',
          'price': 10.0,
          'type': 'test',
          'imageUrl': null,
        };

        // Act
        final result = Product.fromMap(mapWithNullImage);

        // Assert
        expect(result.id, equals(1));
        expect(result.name, equals('Test Product'));
        expect(result.price, equals(10.0));
        expect(result.type, equals('test'));
        expect(result.imageUrl, isNull);
      });

      test('should handle missing imageUrl key in fromMap', () {
        // Arrange
        final mapWithoutImage = {
          'id': 1,
          'name': 'Test Product',
          'price': 10.0,
          'type': 'test',
        };

        // Act
        final result = Product.fromMap(mapWithoutImage);

        // Assert
        expect(result.id, equals(1));
        expect(result.name, equals('Test Product'));
        expect(result.price, equals(10.0));
        expect(result.type, equals('test'));
        expect(result.imageUrl, isNull);
      });

      test('should handle different numeric types for id', () {
        // Arrange
        final mapWithStringId = {
          'id': '1',
          'name': 'Test Product',
          'price': 10.0,
          'type': 'test',
        };

        // Act & Assert
        expect(
            () => Product.fromMap(mapWithStringId), throwsA(isA<TypeError>()));
      });

      test('should handle different numeric types for price', () {
        // Arrange
        final mapWithIntPrice = {
          'id': 1,
          'name': 'Test Product',
          'price': 10,
          'type': 'test',
        };

        // Act
        final result = Product.fromMap(mapWithIntPrice);

        // Assert
        expect(result.price, equals(10.0));
      });
    });

    group('toJson', () {
      test('should convert product to JSON string correctly', () {
        // Act
        final result = testProduct.toJson();

        // Assert
        expect(result, equals(testProductJson));
        expect(result, isA<String>());
      });

      test('should create valid JSON that can be parsed', () {
        // Act
        final jsonString = testProduct.toJson();
        final parsedMap = json.decode(jsonString);

        // Assert
        expect(parsedMap, equals(testProductMap));
      });

      test('should handle null imageUrl in JSON', () {
        // Arrange
        final product = Product(
          id: 1,
          name: 'Test Product',
          price: 10.0,
          type: 'test',
        );

        // Act
        final jsonString = product.toJson();
        final parsedMap = json.decode(jsonString);

        // Assert
        expect(parsedMap['imageUrl'], isNull);
      });
    });

    group('fromJson', () {
      test('should create product from JSON string correctly', () {
        // Act
        final result = Product.fromJson(testProductJson);

        // Assert
        expect(result.id, equals(testProduct.id));
        expect(result.name, equals(testProduct.name));
        expect(result.price, equals(testProduct.price));
        expect(result.type, equals(testProduct.type));
        expect(result.imageUrl, equals(testProduct.imageUrl));
      });

      test('should handle null imageUrl in JSON', () {
        // Arrange
        final jsonWithNullImage = json.encode({
          'id': 1,
          'name': 'Test Product',
          'price': 10.0,
          'type': 'test',
          'imageUrl': null,
        });

        // Act
        final result = Product.fromJson(jsonWithNullImage);

        // Assert
        expect(result.imageUrl, isNull);
      });

      test('should throw FormatException for invalid JSON', () {
        // Arrange
        const invalidJson = 'invalid json string';

        // Act & Assert
        expect(() => Product.fromJson(invalidJson),
            throwsA(isA<FormatException>()));
      });

      test('should throw TypeError for missing required fields', () {
        // Arrange
        final incompleteJson = json.encode({
          'name': 'Test Product',
          'price': 10.0,
          // missing 'id' and 'type'
        });

        // Act & Assert
        expect(
            () => Product.fromJson(incompleteJson), throwsA(isA<TypeError>()));
      });
    });

    group('Roundtrip Conversion', () {
      test('should maintain data integrity through toMap -> fromMap', () {
        // Act
        final map = testProduct.toMap();
        final reconstructed = Product.fromMap(map);

        // Assert
        expect(reconstructed.id, equals(testProduct.id));
        expect(reconstructed.name, equals(testProduct.name));
        expect(reconstructed.price, equals(testProduct.price));
        expect(reconstructed.type, equals(testProduct.type));
        expect(reconstructed.imageUrl, equals(testProduct.imageUrl));
      });

      test('should maintain data integrity through toJson -> fromJson', () {
        // Act
        final jsonString = testProduct.toJson();
        final reconstructed = Product.fromJson(jsonString);

        // Assert
        expect(reconstructed.id, equals(testProduct.id));
        expect(reconstructed.name, equals(testProduct.name));
        expect(reconstructed.price, equals(testProduct.price));
        expect(reconstructed.type, equals(testProduct.type));
        expect(reconstructed.imageUrl, equals(testProduct.imageUrl));
      });

      test('should handle null imageUrl in roundtrip conversion', () {
        // Arrange
        final productWithNullImage = Product(
          id: 1,
          name: 'Test Product',
          price: 10.0,
          type: 'test',
        );

        // Act
        final jsonString = productWithNullImage.toJson();
        final reconstructed = Product.fromJson(jsonString);

        // Assert
        expect(reconstructed.id, equals(productWithNullImage.id));
        expect(reconstructed.name, equals(productWithNullImage.name));
        expect(reconstructed.price, equals(productWithNullImage.price));
        expect(reconstructed.type, equals(productWithNullImage.type));
        expect(reconstructed.imageUrl, equals(productWithNullImage.imageUrl));
        expect(reconstructed.imageUrl, isNull);
      });
    });

    group('Edge Cases', () {
      test('should handle very large numbers', () {
        // Arrange
        final product = Product(
          id: 9999999,
          name: 'Expensive Product',
          price: 999999.99,
          type: 'luxury',
        );

        // Act
        final map = product.toMap();
        final reconstructed = Product.fromMap(map);

        // Assert
        expect(reconstructed.id, equals(9999999));
        expect(reconstructed.price, equals(999999.99));
      });

      test('should handle special characters in strings', () {
        // Arrange
        final product = Product(
          id: 1,
          name: 'Spëcîál Bürger™ with "quotes" & symbols!',
          price: 15.5,
          type: 'sandwich & more',
          imageUrl: 'https://example.com/path?param=value&other=123',
        );

        // Act
        final jsonString = product.toJson();
        final reconstructed = Product.fromJson(jsonString);

        // Assert
        expect(reconstructed.name, equals(product.name));
        expect(reconstructed.type, equals(product.type));
        expect(reconstructed.imageUrl, equals(product.imageUrl));
      });

      test('should handle decimal precision', () {
        // Arrange
        final product = Product(
          id: 1,
          name: 'Precise Price Product',
          price: 15.123456789,
          type: 'test',
        );

        // Act
        final jsonString = product.toJson();
        final reconstructed = Product.fromJson(jsonString);

        // Assert
        expect(reconstructed.price, equals(15.123456789));
      });
    });
  });
}
