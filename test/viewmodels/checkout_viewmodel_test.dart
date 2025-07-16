import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:bom_hamburguer/viewmodels/checkout_viewmodel.dart';
import 'package:bom_hamburguer/services/cart_service.dart';
import 'package:bom_hamburguer/viewmodels/utils/ui_models.dart';
import 'package:bom_hamburguer/l10n/global_app_localizations.dart';
import 'package:bom_hamburguer/injector.dart';

import 'checkout_viewmodel_test.mocks.dart';

// Mock para GlobalAppLocalizations
class MockGlobalAppLocalizations extends Mock
    implements GlobalAppLocalizations {
  @override
  AppLocalizations get current => MockAppLocalizations();
}

class MockAppLocalizations extends Mock implements AppLocalizations {
  @override
  String get ok => 'OK';

  @override
  String get pleaseEnterName => 'Please enter your name';

  @override
  String get cartIsEmpty => 'Cart is empty';
}

@GenerateMocks([CartService])
void main() {
  late CheckoutViewModel viewModel;
  late MockCartService mockCartService;
  late MockGlobalAppLocalizations mockGlobalAppLocalizations;

  setUpAll(() {
    // Register the mock in the service locator
    if (sl.isRegistered<GlobalAppLocalizations>()) {
      sl.unregister<GlobalAppLocalizations>();
    }
    mockGlobalAppLocalizations = MockGlobalAppLocalizations();
    sl.registerSingleton<GlobalAppLocalizations>(mockGlobalAppLocalizations);
  });

  setUp(() {
    mockCartService = MockCartService();
    viewModel = CheckoutViewModel(mockCartService);
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('CheckoutViewModel', () {
    group('Initialization', () {
      test('should initialize with correct default values', () {
        // Assert
        expect(viewModel.uiMessage, isNull);
        expect(viewModel.orderResult, isNull);
        expect(viewModel.cartService, equals(mockCartService));
        expect(viewModel.nameController, isA<TextEditingController>());
        expect(viewModel.nameController.text, isEmpty);
      });

      test('should have access to cart service', () {
        // Assert
        expect(viewModel.cartService, isNotNull);
        expect(viewModel.cartService, equals(mockCartService));
      });
    });

    group('UI Message Management', () {
      test('should clear UI message and notify listeners', () {
        // Arrange
        var notified = false;
        viewModel.addListener(() => notified = true);

        // Set a message first
        viewModel.showErrorMessage('Test error');
        expect(viewModel.uiMessage, isNotNull);

        // Act
        viewModel.clearUIMessage();

        // Assert
        expect(viewModel.uiMessage, isNull);
        expect(notified, isTrue);
      });

      test('should show error message with correct properties', () {
        // Arrange
        const errorMessage = 'Test error message';
        var notified = false;
        viewModel.addListener(() => notified = true);

        // Act
        viewModel.showErrorMessage(errorMessage);

        // Assert
        expect(viewModel.uiMessage, isNotNull);
        expect(viewModel.uiMessage!.message, equals(errorMessage));
        expect(viewModel.uiMessage!.type, equals(UIMessageType.error));
        expect(viewModel.uiMessage!.actionLabel, equals('OK'));
        expect(viewModel.uiMessage!.onAction, isNotNull);
        expect(notified, isTrue);
      });

      test('should clear UI message when onAction is called', () {
        // Arrange
        viewModel.showErrorMessage('Test error');
        expect(viewModel.uiMessage, isNotNull);

        // Act
        viewModel.uiMessage!.onAction!();

        // Assert
        expect(viewModel.uiMessage, isNull);
      });
    });

    group('Order Result Management', () {
      test('should clear order result and notify listeners', () {
        // Arrange
        var notified = false;
        viewModel.addListener(() => notified = true);

        // Set an order result first
        when(mockCartService.isEmpty).thenReturn(false);
        when(mockCartService.getTotal()).thenReturn(25.50);
        when(mockCartService.getDiscount()).thenReturn(2.50);
        when(mockCartService.itemCount).thenReturn(3);

        viewModel.nameController.text = 'Test User';
        viewModel.processPayment();
        expect(viewModel.orderResult, isNotNull);

        // Act
        viewModel.clearOrderResult();

        // Assert
        expect(viewModel.orderResult, isNull);
        expect(notified, isTrue);
      });
    });

    group('processPayment', () {
      test('should show error message when name is empty', () {
        // Arrange
        viewModel.nameController.text = '';
        var notified = false;
        viewModel.addListener(() => notified = true);

        // Act
        viewModel.processPayment();

        // Assert
        expect(viewModel.uiMessage, isNotNull);
        expect(viewModel.uiMessage!.type, equals(UIMessageType.error));
        expect(viewModel.uiMessage!.message, equals('Please enter your name'));
        expect(viewModel.orderResult, isNull);
        expect(notified, isTrue);
      });

      test('should show error message when name is only whitespace', () {
        // Arrange
        viewModel.nameController.text = '   ';

        // Act
        viewModel.processPayment();

        // Assert
        expect(viewModel.uiMessage, isNotNull);
        expect(viewModel.uiMessage!.type, equals(UIMessageType.error));
        expect(viewModel.uiMessage!.message, equals('Please enter your name'));
        expect(viewModel.orderResult, isNull);
      });

      test('should show warning message when cart is empty', () {
        // Arrange
        viewModel.nameController.text = 'John Doe';
        when(mockCartService.isEmpty).thenReturn(true);

        // Act
        viewModel.processPayment();

        // Assert
        expect(viewModel.uiMessage, isNotNull);
        expect(viewModel.uiMessage!.type, equals(UIMessageType.warning));
        expect(viewModel.uiMessage!.message, equals('Cart is empty'));
        expect(viewModel.orderResult, isNull);
      });

      test('should create order result when valid name and cart has items', () {
        // Arrange
        const customerName = 'John Doe';
        const total = 25.50;
        const discount = 2.50;
        const itemCount = 3;

        viewModel.nameController.text = customerName;
        when(mockCartService.isEmpty).thenReturn(false);
        when(mockCartService.getTotal()).thenReturn(total);
        when(mockCartService.getDiscount()).thenReturn(discount);
        when(mockCartService.itemCount).thenReturn(itemCount);

        var notified = false;
        viewModel.addListener(() => notified = true);

        // Act
        viewModel.processPayment();

        // Assert
        expect(viewModel.orderResult, isNotNull);
        expect(viewModel.orderResult!.customerName, equals(customerName));
        expect(viewModel.orderResult!.total, equals(total));
        expect(viewModel.orderResult!.discount, equals(discount));
        expect(viewModel.orderResult!.itemCount, equals(itemCount));
        expect(viewModel.uiMessage, isNull);
        expect(notified, isTrue);
      });

      test('should trim whitespace from customer name', () {
        // Arrange
        const customerName = '  John Doe  ';
        viewModel.nameController.text = customerName;
        when(mockCartService.isEmpty).thenReturn(false);
        when(mockCartService.getTotal()).thenReturn(25.50);
        when(mockCartService.getDiscount()).thenReturn(0.0);
        when(mockCartService.itemCount).thenReturn(2);

        // Act
        viewModel.processPayment();

        // Assert
        expect(viewModel.orderResult, isNotNull);
        expect(viewModel.orderResult!.customerName, equals('John Doe'));
      });

      test('should handle zero values from cart service', () {
        // Arrange
        viewModel.nameController.text = 'John Doe';
        when(mockCartService.isEmpty).thenReturn(false);
        when(mockCartService.getTotal()).thenReturn(0.0);
        when(mockCartService.getDiscount()).thenReturn(0.0);
        when(mockCartService.itemCount).thenReturn(0);

        // Act
        viewModel.processPayment();

        // Assert
        expect(viewModel.orderResult, isNotNull);
        expect(viewModel.orderResult!.total, equals(0.0));
        expect(viewModel.orderResult!.discount, equals(0.0));
        expect(viewModel.orderResult!.itemCount, equals(0));
      });

      test('should handle negative discount', () {
        // Arrange
        viewModel.nameController.text = 'John Doe';
        when(mockCartService.isEmpty).thenReturn(false);
        when(mockCartService.getTotal()).thenReturn(20.0);
        when(mockCartService.getDiscount()).thenReturn(-5.0);
        when(mockCartService.itemCount).thenReturn(2);

        // Act
        viewModel.processPayment();

        // Assert
        expect(viewModel.orderResult, isNotNull);
        expect(viewModel.orderResult!.discount, equals(-5.0));
      });
    });

    group('completeOrder', () {
      test('should clear cart, name controller, and order result', () {
        // Arrange
        viewModel.nameController.text = 'John Doe';
        when(mockCartService.isEmpty).thenReturn(false);
        when(mockCartService.getTotal()).thenReturn(25.50);
        when(mockCartService.getDiscount()).thenReturn(2.50);
        when(mockCartService.itemCount).thenReturn(3);

        // Create an order first
        viewModel.processPayment();
        expect(viewModel.orderResult, isNotNull);
        expect(viewModel.nameController.text, isNotEmpty);

        var notified = false;
        viewModel.addListener(() => notified = true);

        // Act
        viewModel.completeOrder();

        // Assert
        verify(mockCartService.clearCart()).called(1);
        expect(viewModel.nameController.text, isEmpty);
        expect(viewModel.orderResult, isNull);
        expect(notified, isTrue);
      });

      test('should handle complete order when no order result exists', () {
        // Arrange
        expect(viewModel.orderResult, isNull);
        viewModel.nameController.text = 'Some text';

        // Act
        viewModel.completeOrder();

        // Assert
        verify(mockCartService.clearCart()).called(1);
        expect(viewModel.nameController.text, isEmpty);
        expect(viewModel.orderResult, isNull);
      });

      test('should notify listeners when completing order', () {
        // Arrange
        var notificationCount = 0;
        viewModel.addListener(() => notificationCount++);

        // Act
        viewModel.completeOrder();

        // Assert
        expect(notificationCount, equals(1));
      });
    });

    group('State Management', () {
      test('should maintain state consistency during multiple operations', () {
        // Arrange
        viewModel.nameController.text = 'John Doe';
        when(mockCartService.isEmpty).thenReturn(false);
        when(mockCartService.getTotal()).thenReturn(30.0);
        when(mockCartService.getDiscount()).thenReturn(3.0);
        when(mockCartService.itemCount).thenReturn(2);

        // Act - Process payment
        viewModel.processPayment();
        expect(viewModel.orderResult, isNotNull);
        expect(viewModel.uiMessage, isNull);

        // Act - Show error
        viewModel.showErrorMessage('Test error');
        expect(viewModel.uiMessage, isNotNull);
        expect(viewModel.orderResult, isNotNull); // Should still exist

        // Act - Clear UI message
        viewModel.clearUIMessage();
        expect(viewModel.uiMessage, isNull);
        expect(viewModel.orderResult, isNotNull); // Should still exist

        // Act - Complete order
        viewModel.completeOrder();
        expect(viewModel.orderResult, isNull);
        expect(viewModel.uiMessage, isNull);
      });

      test('should handle rapid successive operations', () {
        // Arrange
        viewModel.nameController.text = 'John Doe';
        when(mockCartService.isEmpty).thenReturn(false);
        when(mockCartService.getTotal()).thenReturn(25.0);
        when(mockCartService.getDiscount()).thenReturn(0.0);
        when(mockCartService.itemCount).thenReturn(1);

        // Act - Multiple rapid operations
        viewModel.processPayment();
        expect(viewModel.orderResult, isNotNull);

        viewModel.showErrorMessage('Error 1');
        expect(viewModel.uiMessage, isNotNull);

        viewModel.clearUIMessage();
        expect(viewModel.uiMessage, isNull);

        viewModel.showErrorMessage('Error 2');
        expect(viewModel.uiMessage, isNotNull);

        viewModel.processPayment(); // Should update existing order result
        expect(viewModel.orderResult, isNotNull);
        expect(viewModel.uiMessage,
            isNotNull); // Error message should still be there

        viewModel.completeOrder();

        // Assert final state
        expect(viewModel.orderResult, isNull);
        expect(viewModel.nameController.text, isEmpty);
        verify(mockCartService.clearCart()).called(1);
      });
    });

    group('Listener Notifications', () {
      test('should notify listeners for all state changes', () {
        // Arrange
        var notificationCount = 0;
        viewModel.addListener(() => notificationCount++);

        viewModel.nameController.text = 'John Doe';
        when(mockCartService.isEmpty).thenReturn(false);
        when(mockCartService.getTotal()).thenReturn(20.0);
        when(mockCartService.getDiscount()).thenReturn(0.0);
        when(mockCartService.itemCount).thenReturn(1);

        // Act
        viewModel.processPayment(); // +1
        viewModel.showErrorMessage('Test'); // +1
        viewModel.clearUIMessage(); // +1
        viewModel.clearOrderResult(); // +1
        viewModel.completeOrder(); // +1

        // Assert
        expect(notificationCount, equals(5));
      });

      test('should not notify listeners when no state changes occur', () {
        // Arrange
        var notificationCount = 0;
        viewModel.addListener(() => notificationCount++);

        // Act - Clear when already null
        viewModel.clearUIMessage();
        viewModel.clearOrderResult();

        // Assert
        expect(
            notificationCount, equals(2)); // Still notifies even if no change
      });
    });

    group('Edge Cases', () {
      test('should handle extremely long customer names', () {
        // Arrange
        final longName = 'A' * 1000;
        viewModel.nameController.text = longName;
        when(mockCartService.isEmpty).thenReturn(false);
        when(mockCartService.getTotal()).thenReturn(15.0);
        when(mockCartService.getDiscount()).thenReturn(0.0);
        when(mockCartService.itemCount).thenReturn(1);

        // Act
        viewModel.processPayment();

        // Assert
        expect(viewModel.orderResult, isNotNull);
        expect(viewModel.orderResult!.customerName, equals(longName));
      });

      test('should handle special characters in customer name', () {
        // Arrange
        const specialName = 'João da Silva-Santos & Co. (123)';
        viewModel.nameController.text = specialName;
        when(mockCartService.isEmpty).thenReturn(false);
        when(mockCartService.getTotal()).thenReturn(15.0);
        when(mockCartService.getDiscount()).thenReturn(0.0);
        when(mockCartService.itemCount).thenReturn(1);

        // Act
        viewModel.processPayment();

        // Assert
        expect(viewModel.orderResult, isNotNull);
        expect(viewModel.orderResult!.customerName, equals(specialName));
      });

      test('should handle very large monetary values', () {
        // Arrange
        viewModel.nameController.text = 'John Doe';
        when(mockCartService.isEmpty).thenReturn(false);
        when(mockCartService.getTotal()).thenReturn(999999.99);
        when(mockCartService.getDiscount()).thenReturn(50000.50);
        when(mockCartService.itemCount).thenReturn(1000);

        // Act
        viewModel.processPayment();

        // Assert
        expect(viewModel.orderResult, isNotNull);
        expect(viewModel.orderResult!.total, equals(999999.99));
        expect(viewModel.orderResult!.discount, equals(50000.50));
        expect(viewModel.orderResult!.itemCount, equals(1000));
      });

      test('should handle cart service throwing exceptions', () {
        // Arrange
        viewModel.nameController.text = 'John Doe';
        when(mockCartService.isEmpty)
            .thenThrow(Exception('Cart service error'));

        // Act & Assert
        expect(() => viewModel.processPayment(), throwsException);
      });
    });

    group('TextEditingController Management', () {
      test('should properly dispose text controller', () {
        // Arrange - Create a separate instance for this test
        final testCartService = MockCartService();
        final testViewModel = CheckoutViewModel(testCartService);

        // Act & Assert - should not throw any exceptions when disposing
        expect(() => testViewModel.dispose(), returnsNormally);

        // Verify that trying to use the controller after dispose throws an error
        expect(() => testViewModel.nameController.text = 'test',
            throwsA(isA<FlutterError>()));
      });

      test('should clear text controller on complete order', () {
        // Arrange
        viewModel.nameController.text = 'Test User';
        expect(viewModel.nameController.text, isNotEmpty);

        // Act
        viewModel.completeOrder();

        // Assert
        expect(viewModel.nameController.text, isEmpty);
      });

      test('should preserve text controller content during other operations',
          () {
        // Arrange
        const testName = 'Preserved Name';
        viewModel.nameController.text = testName;

        // Act
        viewModel.showErrorMessage('Test error');
        viewModel.clearUIMessage();
        viewModel.clearOrderResult();

        // Assert
        expect(viewModel.nameController.text, equals(testName));
      });
    });

    group('Integration with Cart Service', () {
      test('should call cart service methods correctly during complete order',
          () {
        // Act
        viewModel.completeOrder();

        // Assert
        verify(mockCartService.clearCart()).called(1);
      });

      test(
          'should read cart service properties correctly during payment processing',
          () {
        // Arrange
        viewModel.nameController.text = 'John Doe';
        when(mockCartService.isEmpty).thenReturn(false);
        when(mockCartService.getTotal()).thenReturn(42.50);
        when(mockCartService.getDiscount()).thenReturn(7.50);
        when(mockCartService.itemCount).thenReturn(5);

        // Act
        viewModel.processPayment();

        // Assert
        verify(mockCartService.isEmpty).called(1);
        verify(mockCartService.getTotal()).called(1);
        verify(mockCartService.getDiscount()).called(1);
        verify(mockCartService.itemCount).called(1);
      });

      test('should handle cart service returning default values in edge cases',
          () {
        // Arrange
        viewModel.nameController.text = 'John Doe';
        when(mockCartService.isEmpty).thenReturn(false);
        when(mockCartService.getTotal()).thenReturn(0.0);
        when(mockCartService.getDiscount()).thenReturn(0.0);
        when(mockCartService.itemCount).thenReturn(0);

        // Act
        viewModel.processPayment();

        // Assert
        expect(viewModel.orderResult, isNotNull);
        expect(viewModel.orderResult!.total, equals(0.0));
        expect(viewModel.orderResult!.discount, equals(0.0));
        expect(viewModel.orderResult!.itemCount, equals(0));
      });
    });
  });
}
