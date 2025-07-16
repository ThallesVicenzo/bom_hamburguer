import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:bom_hamburguer/viewmodels/home_screen_viewmodel.dart';
import 'package:bom_hamburguer/repositories/product_repository.dart';
import 'package:bom_hamburguer/models/product.dart';
import 'package:bom_hamburguer/services/errors/failure_impl.dart';

import 'home_screen_viewmodel_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
  });

  HomeScreenViewModel createViewModel() {
    return HomeScreenViewModel(mockRepository);
  }

  group('HomeScreenViewModel', () {
    group('Initialization', () {
      test('should initialize with loading state and empty products list',
          () async {
        // Arrange
        when(mockRepository.getProducts())
            .thenAnswer((_) async => const Right([]));

        // Act
        final viewModel = createViewModel();

        // Assert initial state
        expect(viewModel.products, isEmpty);
        expect(viewModel.isLoading, isTrue);
        expect(viewModel.uiMessage, isNull);
        expect(viewModel.sandwiches, isEmpty);
        expect(viewModel.extras, isEmpty);

        // Wait for initialization to complete
        await Future.delayed(Duration.zero);
        expect(viewModel.isLoading, isFalse);

        viewModel.dispose();
      });

      test('should automatically fetch products on initialization', () async {
        // Arrange
        final testProducts = [
          Product(id: 1, name: 'Burger', price: 15.0, type: 'sandwich'),
          Product(id: 2, name: 'Fries', price: 8.0, type: 'extra'),
        ];
        when(mockRepository.getProducts())
            .thenAnswer((_) async => Right(testProducts));

        // Act
        final viewModel = createViewModel();

        // Wait for async initialization
        await Future.delayed(Duration.zero);

        // Assert
        verify(mockRepository.getProducts()).called(1);

        viewModel.dispose();
      });
    });

    group('fetchProducts', () {
      test('should populate products list on successful fetch', () async {
        // Arrange
        final testProducts = [
          Product(id: 1, name: 'Classic Burger', price: 15.5, type: 'sandwich'),
          Product(id: 2, name: 'Cheese Burger', price: 17.0, type: 'sandwich'),
          Product(id: 3, name: 'French Fries', price: 8.0, type: 'extra'),
          Product(id: 4, name: 'Onion Rings', price: 10.0, type: 'extra'),
        ];
        when(mockRepository.getProducts())
            .thenAnswer((_) async => Right(testProducts));

        // Act
        final viewModel = createViewModel();
        await Future.delayed(Duration.zero); // Wait for initialization

        // Assert
        expect(viewModel.products, equals(testProducts));
        expect(viewModel.products.length, equals(4));
        expect(viewModel.isLoading, isFalse);

        viewModel.dispose();
      });

      test('should clear products list on fetch failure', () async {
        // Arrange
        when(mockRepository.getProducts())
            .thenAnswer((_) async => Left(ServiceError('Database error')));

        // Act
        final viewModel = createViewModel();
        await Future.delayed(Duration.zero);

        // Assert
        expect(viewModel.products, isEmpty);
        expect(viewModel.isLoading, isFalse);

        viewModel.dispose();
      });

      test('should notify listeners during loading state changes', () async {
        // Arrange
        var notificationCount = 0;
        when(mockRepository.getProducts())
            .thenAnswer((_) async => const Right([]));

        final viewModel = createViewModel();
        viewModel.addListener(() => notificationCount++);

        // Act
        await viewModel.fetchProducts();

        // Assert
        expect(notificationCount,
            greaterThanOrEqualTo(2)); // At least start and end of loading

        viewModel.dispose();
      });
    });

    group('Product Filtering', () {
      test('should filter sandwiches correctly', () async {
        // Arrange
        final testProducts = [
          Product(id: 1, name: 'Classic Burger', price: 15.5, type: 'sandwich'),
          Product(id: 2, name: 'Cheese Burger', price: 17.0, type: 'sandwich'),
          Product(id: 3, name: 'French Fries', price: 8.0, type: 'extra'),
          Product(id: 4, name: 'Onion Rings', price: 10.0, type: 'extra'),
          Product(id: 5, name: 'Veggie Burger', price: 14.0, type: 'sandwich'),
        ];
        when(mockRepository.getProducts())
            .thenAnswer((_) async => Right(testProducts));

        // Act
        final viewModel = createViewModel();
        await Future.delayed(Duration.zero);

        // Assert
        expect(viewModel.sandwiches.length, equals(3));
        expect(viewModel.sandwiches.every((p) => p.type == 'sandwich'), isTrue);
        expect(
            viewModel.sandwiches.map((p) => p.name),
            containsAll([
              'Classic Burger',
              'Cheese Burger',
              'Veggie Burger',
            ]));

        viewModel.dispose();
      });

      test('should filter extras correctly', () async {
        // Arrange
        final testProducts = [
          Product(id: 1, name: 'Classic Burger', price: 15.5, type: 'sandwich'),
          Product(id: 2, name: 'Cheese Burger', price: 17.0, type: 'sandwich'),
          Product(id: 3, name: 'French Fries', price: 8.0, type: 'extra'),
          Product(id: 4, name: 'Onion Rings', price: 10.0, type: 'extra'),
          Product(id: 5, name: 'Soda', price: 5.0, type: 'extra'),
        ];
        when(mockRepository.getProducts())
            .thenAnswer((_) async => Right(testProducts));

        // Act
        final viewModel = createViewModel();
        await Future.delayed(Duration.zero);

        // Assert
        expect(viewModel.extras.length, equals(3));
        expect(viewModel.extras.every((p) => p.type == 'extra'), isTrue);
        expect(
            viewModel.extras.map((p) => p.name),
            containsAll([
              'French Fries',
              'Onion Rings',
              'Soda',
            ]));

        viewModel.dispose();
      });

      test('should return empty lists when no products match filter', () async {
        // Arrange
        final testProducts = [
          Product(id: 1, name: 'Drink', price: 5.0, type: 'beverage'),
          Product(id: 2, name: 'Dessert', price: 7.0, type: 'dessert'),
        ];
        when(mockRepository.getProducts())
            .thenAnswer((_) async => Right(testProducts));

        // Act
        final viewModel = createViewModel();
        await Future.delayed(Duration.zero);

        // Assert
        expect(viewModel.sandwiches, isEmpty);
        expect(viewModel.extras, isEmpty);
        expect(viewModel.products.length, equals(2));

        viewModel.dispose();
      });
    });

    group('UI Message Management', () {
      test('should start with null UI message', () async {
        // Arrange
        when(mockRepository.getProducts())
            .thenAnswer((_) async => const Right([]));

        // Act
        final viewModel = createViewModel();
        await Future.delayed(Duration.zero); // Wait for initialization

        // Assert
        expect(viewModel.uiMessage, isNull);

        viewModel.dispose();
      });

      test('should clear UI message', () async {
        // Arrange
        var notificationCount = 0;
        when(mockRepository.getProducts())
            .thenAnswer((_) async => const Right([]));

        final viewModel = createViewModel();
        await Future.delayed(Duration.zero); // Wait for initialization
        viewModel.addListener(() => notificationCount++);

        // Act
        viewModel.clearUIMessage();

        // Assert
        expect(viewModel.uiMessage, isNull);
        expect(notificationCount, equals(1));

        viewModel.dispose();
      });
    });

    group('State Management', () {
      test('should maintain correct state during multiple fetch operations',
          () async {
        // Arrange
        final products1 = [
          Product(id: 1, name: 'Burger1', price: 15.0, type: 'sandwich')
        ];
        final products2 = [
          Product(id: 2, name: 'Burger2', price: 17.0, type: 'sandwich')
        ];

        when(mockRepository.getProducts())
            .thenAnswer((_) async => Right(products1));

        // Act
        final viewModel = createViewModel();
        await Future.delayed(Duration.zero);

        // Assert first fetch
        expect(viewModel.products, equals(products1));
        expect(viewModel.isLoading, isFalse);

        // Act - second fetch
        when(mockRepository.getProducts())
            .thenAnswer((_) async => Right(products2));
        await viewModel.fetchProducts();

        // Assert second fetch
        expect(viewModel.products, equals(products2));
        expect(viewModel.isLoading, isFalse);

        viewModel.dispose();
      });

      test('should handle repository exceptions gracefully', () async {
        // Arrange
        when(mockRepository.getProducts())
            .thenAnswer((_) async => Left(ServiceError('Unexpected error')));

        // Act
        final viewModel = createViewModel();
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.products, isEmpty);

        viewModel.dispose();
      });
    });

    group('Edge Cases', () {
      test('should handle very large product lists', () async {
        // Arrange
        final largeProductList = List.generate(
            1000,
            (index) => Product(
                  id: index,
                  name: 'Product $index',
                  price: 10.0 + index,
                  type: index % 2 == 0 ? 'sandwich' : 'extra',
                ));
        when(mockRepository.getProducts())
            .thenAnswer((_) async => Right(largeProductList));

        // Act
        final viewModel = createViewModel();
        await Future.delayed(Duration.zero);

        // Assert
        expect(viewModel.products.length, equals(1000));
        expect(viewModel.sandwiches.length, equals(500));
        expect(viewModel.extras.length, equals(500));

        viewModel.dispose();
      });

      test('should dispose properly', () async {
        // Arrange
        when(mockRepository.getProducts())
            .thenAnswer((_) async => const Right([]));

        // Act & Assert - should not throw any exceptions
        final testViewModel = createViewModel();
        await Future.delayed(Duration.zero); // Wait for initialization
        expect(() => testViewModel.dispose(), returnsNormally);
      });
    });
  });
}
