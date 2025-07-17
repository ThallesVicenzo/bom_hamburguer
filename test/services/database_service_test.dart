import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:bom_hamburguer/services/database_service.dart';
import 'dart:io';

void main() {
  late DatabaseServiceImpl databaseService;

  setUpAll(() {
    // Inicializa o sqflite para testes
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    databaseService = DatabaseServiceImpl();
  });

  tearDown(() async {
    // Fecha e limpa o banco após cada teste
    await databaseService.closeDatabase();

    // Remove o arquivo de banco se existir
    try {
      final db = await databaseService.database;
      final path = db.path;
      await databaseService.closeDatabase();
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Ignora erros de limpeza
    }
  });

  group('DatabaseService', () {
    group('Table Names', () {
      test('should return correct products table name', () {
        expect(databaseService.productsTable, equals('products'));
      });

      test('should return correct cart table name', () {
        expect(databaseService.cartTable, equals('cart_items'));
      });
    });

    group('Database Initialization', () {
      test('should initialize database successfully', () async {
        // Act
        final db = await databaseService.database;

        // Assert
        expect(db, isNotNull);
        expect(db.isOpen, isTrue);
      });

      test('should return same database instance on multiple calls', () async {
        // Act
        final db1 = await databaseService.database;
        final db2 = await databaseService.database;

        // Assert
        expect(db1, same(db2));
      });

      test('should create products table', () async {
        // Act
        final db = await databaseService.database;

        // Assert
        final tables = await db.rawQuery(
            "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
            ['products']);
        expect(tables, isNotEmpty);
      });

      test('should create cart_items table', () async {
        // Act
        final db = await databaseService.database;

        // Assert
        final tables = await db.rawQuery(
            "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
            ['cart_items']);
        expect(tables, isNotEmpty);
      });

      test('should verify products table structure', () async {
        // Act
        final db = await databaseService.database;

        // Assert
        final columns = await db.rawQuery("PRAGMA table_info(products)");
        final columnNames = columns.map((col) => col['name']).toList();

        expect(columnNames, contains('id'));
        expect(columnNames, contains('name'));
        expect(columnNames, contains('price'));
        expect(columnNames, contains('type'));
        expect(columnNames, contains('imageUrl'));
      });

      test('should verify cart_items table structure', () async {
        // Act
        final db = await databaseService.database;

        // Assert
        final columns = await db.rawQuery("PRAGMA table_info(cart_items)");
        final columnNames = columns.map((col) => col['name']).toList();

        expect(columnNames, contains('id'));
        expect(columnNames, contains('product_id'));
        expect(columnNames, contains('product_name'));
        expect(columnNames, contains('product_price'));
        expect(columnNames, contains('product_type'));
        expect(columnNames, contains('product_image_url'));
        expect(columnNames, contains('quantity'));
        expect(columnNames, contains('created_at'));
      });
    });

    group('Initial Data', () {
      test('should insert initial products on database creation', () async {
        // Act
        final db = await databaseService.database;

        // Assert
        final products = await db.query('products');
        expect(products.length, equals(5));
      });

      test('should insert correct sandwich products', () async {
        // Act
        final db = await databaseService.database;

        // Assert
        final sandwiches = await db
            .query('products', where: 'type = ?', whereArgs: ['sandwich']);

        expect(sandwiches.length, equals(3));

        final sandwichNames = sandwiches.map((s) => s['name']).toList();
        expect(sandwichNames, contains('Classic Burger'));
        expect(sandwichNames, contains('Cheese Burger'));
        expect(sandwichNames, contains('Bacon Burger'));
      });

      test('should insert correct extra products', () async {
        // Act
        final db = await databaseService.database;

        // Assert
        final extras =
            await db.query('products', where: 'type = ?', whereArgs: ['extra']);

        expect(extras.length, equals(2));

        final extraNames = extras.map((e) => e['name']).toList();
        expect(extraNames, contains('fries'));
        expect(extraNames, contains('softDrink'));
      });

      test('should insert products with correct prices', () async {
        // Act
        final db = await databaseService.database;

        // Assert
        final classicBurger = await db.query('products',
            where: 'name = ?', whereArgs: ['Classic Burger']);
        expect(classicBurger.first['price'], equals(15.5));

        final fries =
            await db.query('products', where: 'name = ?', whereArgs: ['fries']);
        expect(fries.first['price'], equals(8.0));

        final softDrink = await db
            .query('products', where: 'name = ?', whereArgs: ['softDrink']);
        expect(softDrink.first['price'], equals(5.0));
      });

      test('should insert products with correct IDs', () async {
        // Act
        final db = await databaseService.database;

        // Assert
        final products = await db.query('products', orderBy: 'id');

        expect(products[0]['id'], equals(1));
        expect(products[0]['name'], equals('Classic Burger'));

        expect(products[1]['id'], equals(2));
        expect(products[1]['name'], equals('Cheese Burger'));

        expect(products[2]['id'], equals(3));
        expect(products[2]['name'], equals('Bacon Burger'));

        expect(products[3]['id'], equals(4));
        expect(products[3]['name'], equals('fries'));

        expect(products[4]['id'], equals(5));
        expect(products[4]['name'], equals('softDrink'));
      });
    });

    group('Database Operations', () {
      test('should allow inserting data into products table', () async {
        // Arrange
        final db = await databaseService.database;
        final newProduct = {
          'id': 6,
          'name': 'Test Burger',
          'price': 20.0,
          'type': 'sandwich',
          'imageUrl': null,
        };

        // Act
        await db.insert('products', newProduct);

        // Assert
        final products =
            await db.query('products', where: 'id = ?', whereArgs: [6]);
        expect(products.length, equals(1));
        expect(products.first['name'], equals('Test Burger'));
      });

      test('should allow inserting data into cart_items table', () async {
        // Arrange
        final db = await databaseService.database;
        final cartItem = {
          'product_id': 1,
          'product_name': 'Classic Burger',
          'product_price': 15.5,
          'product_type': 'sandwich',
          'product_image_url': null,
          'quantity': 1,
          'created_at': DateTime.now().toIso8601String(),
        };

        // Act
        await db.insert('cart_items', cartItem);

        // Assert
        final cartItems = await db.query('cart_items');
        expect(cartItems.length, equals(1));
        expect(cartItems.first['product_name'], equals('Classic Burger'));
      });

      test('should allow querying products by type', () async {
        // Act
        final db = await databaseService.database;

        // Assert - Considera que pode haver produtos de testes anteriores
        final sandwiches = await db
            .query('products', where: 'type = ?', whereArgs: ['sandwich']);
        expect(sandwiches.length, greaterThanOrEqualTo(3));

        final extras =
            await db.query('products', where: 'type = ?', whereArgs: ['extra']);
        expect(extras.length, greaterThanOrEqualTo(2));
      });

      test('should allow updating product data', () async {
        // Arrange
        final db = await databaseService.database;

        // Act
        await db.update('products', {'price': 16.0},
            where: 'id = ?', whereArgs: [1]);

        // Assert
        final product =
            await db.query('products', where: 'id = ?', whereArgs: [1]);
        expect(product.first['price'], equals(16.0));
      });

      test('should allow deleting cart items', () async {
        // Arrange
        final db = await databaseService.database;
        final cartItem = {
          'product_id': 1,
          'product_name': 'Classic Burger',
          'product_price': 15.5,
          'product_type': 'sandwich',
          'product_image_url': null,
          'quantity': 1,
          'created_at': DateTime.now().toIso8601String(),
        };
        await db.insert('cart_items', cartItem);

        // Act
        await db.delete('cart_items', where: 'product_id = ?', whereArgs: [1]);

        // Assert
        final cartItems = await db.query('cart_items');
        expect(cartItems, isEmpty);
      });
    });

    group('Database Closing', () {
      test('should close database successfully', () async {
        // Arrange
        final db = await databaseService.database;
        expect(db.isOpen, isTrue);

        // Act
        await databaseService.closeDatabase();

        // Assert
        expect(db.isOpen, isFalse);
      });

      test('should handle closing database when already closed', () async {
        // Arrange
        await databaseService.database; // Initialize
        await databaseService.closeDatabase(); // Close

        // Act & Assert - Should not throw
        await databaseService.closeDatabase();
      });

      test('should handle closing database when never opened', () async {
        // Act & Assert - Should not throw
        await databaseService.closeDatabase();
      });

      test('should allow reopening database after closing', () async {
        // Arrange
        final db1 = await databaseService.database;
        await databaseService.closeDatabase();

        // Act
        final db2 = await databaseService.database;

        // Assert
        expect(db2, isNotNull);
        expect(db2.isOpen, isTrue);
        expect(db1, isNot(same(db2))); // Different instances
      });
    });

    group('Database Persistence', () {
      test('should maintain data after reopening database', () async {
        // Arrange
        final db1 = await databaseService.database;
        final cartItem = {
          'product_id': 1,
          'product_name': 'Classic Burger',
          'product_price': 15.5,
          'product_type': 'sandwich',
          'product_image_url': null,
          'quantity': 1,
          'created_at': DateTime.now().toIso8601String(),
        };
        await db1.insert('cart_items', cartItem);
        await databaseService.closeDatabase();

        // Act
        final db2 = await databaseService.database;

        // Assert
        final cartItems = await db2.query('cart_items');
        expect(cartItems.length, equals(1));
        expect(cartItems.first['product_name'], equals('Classic Burger'));
      });

      test('should maintain initial products after reopening', () async {
        // Arrange
        await databaseService.database; // Initialize
        await databaseService.closeDatabase();

        // Act
        final db = await databaseService.database;

        // Assert - Considera que pode haver produtos de testes anteriores
        final products = await db.query('products');
        expect(products.length, greaterThanOrEqualTo(5));
      });
    });

    group('Error Handling', () {
      test('should handle invalid SQL gracefully', () async {
        // Arrange
        final db = await databaseService.database;

        // Act & Assert
        expect(
          () => db.rawQuery('INVALID SQL'),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle constraint violations', () async {
        // Arrange
        final db = await databaseService.database;
        final duplicateProduct = {
          'id': 1, // Duplicate ID
          'name': 'Duplicate',
          'price': 10.0,
          'type': 'sandwich',
        };

        // Act & Assert
        expect(
          () => db.insert('products', duplicateProduct),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Database Version', () {
      test('should use correct database version', () async {
        // Act
        final db = await databaseService.database;

        // Assert
        final result = await db.rawQuery('PRAGMA user_version');
        final version = result.first['user_version'];
        expect(version, equals(1));
      });
    });
  });
}
