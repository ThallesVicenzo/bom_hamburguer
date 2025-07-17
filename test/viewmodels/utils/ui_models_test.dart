import 'package:flutter_test/flutter_test.dart';
import 'package:bom_hamburguer/viewmodels/utils/ui_models.dart';

void main() {
  group('UIMessageType', () {
    test('should have all expected enum values', () {
      // Assert
      expect(UIMessageType.values.length, equals(4));
      expect(UIMessageType.values, contains(UIMessageType.success));
      expect(UIMessageType.values, contains(UIMessageType.error));
      expect(UIMessageType.values, contains(UIMessageType.warning));
      expect(UIMessageType.values, contains(UIMessageType.info));
    });

    test('should have correct string representation', () {
      // Assert
      expect(UIMessageType.success.toString(), equals('UIMessageType.success'));
      expect(UIMessageType.error.toString(), equals('UIMessageType.error'));
      expect(UIMessageType.warning.toString(), equals('UIMessageType.warning'));
      expect(UIMessageType.info.toString(), equals('UIMessageType.info'));
    });

    test('should be comparable', () {
      // Assert
      expect(UIMessageType.success == UIMessageType.success, isTrue);
      expect(UIMessageType.success == UIMessageType.error, isFalse);
      expect(UIMessageType.error != UIMessageType.warning, isTrue);
    });
  });

  group('UIMessage', () {
    group('Constructor', () {
      test('should create UIMessage with required parameters', () {
        // Act
        final message = UIMessage(
          message: 'Test message',
          type: UIMessageType.success,
        );

        // Assert
        expect(message.message, equals('Test message'));
        expect(message.type, equals(UIMessageType.success));
        expect(message.actionLabel, isNull);
        expect(message.onAction, isNull);
      });

      test('should create UIMessage with all parameters', () {
        // Arrange
        void testAction() {}

        // Act
        final message = UIMessage(
          message: 'Test message with action',
          type: UIMessageType.error,
          actionLabel: 'Retry',
          onAction: testAction,
        );

        // Assert
        expect(message.message, equals('Test message with action'));
        expect(message.type, equals(UIMessageType.error));
        expect(message.actionLabel, equals('Retry'));
        expect(message.onAction, equals(testAction));
      });

      test('should allow null actionLabel with null onAction', () {
        // Act
        final message = UIMessage(
          message: 'Test message',
          type: UIMessageType.info,
          actionLabel: null,
          onAction: null,
        );

        // Assert
        expect(message.actionLabel, isNull);
        expect(message.onAction, isNull);
      });

      test('should allow actionLabel without onAction', () {
        // Act
        final message = UIMessage(
          message: 'Test message',
          type: UIMessageType.warning,
          actionLabel: 'OK',
        );

        // Assert
        expect(message.actionLabel, equals('OK'));
        expect(message.onAction, isNull);
      });

      test('should allow onAction without actionLabel', () {
        // Arrange
        void testAction() {}

        // Act
        final message = UIMessage(
          message: 'Test message',
          type: UIMessageType.success,
          onAction: testAction,
        );

        // Assert
        expect(message.actionLabel, isNull);
        expect(message.onAction, equals(testAction));
      });
    });

    group('Message Types', () {
      test('should create success message correctly', () {
        // Act
        final message = UIMessage(
          message: 'Operation successful',
          type: UIMessageType.success,
        );

        // Assert
        expect(message.type, equals(UIMessageType.success));
        expect(message.message, equals('Operation successful'));
      });

      test('should create error message correctly', () {
        // Act
        final message = UIMessage(
          message: 'An error occurred',
          type: UIMessageType.error,
        );

        // Assert
        expect(message.type, equals(UIMessageType.error));
        expect(message.message, equals('An error occurred'));
      });

      test('should create warning message correctly', () {
        // Act
        final message = UIMessage(
          message: 'Warning: Check your input',
          type: UIMessageType.warning,
        );

        // Assert
        expect(message.type, equals(UIMessageType.warning));
        expect(message.message, equals('Warning: Check your input'));
      });

      test('should create info message correctly', () {
        // Act
        final message = UIMessage(
          message: 'Information: Process started',
          type: UIMessageType.info,
        );

        // Assert
        expect(message.type, equals(UIMessageType.info));
        expect(message.message, equals('Information: Process started'));
      });
    });

    group('Action Callback', () {
      test('should execute onAction callback when called', () {
        // Arrange
        var actionExecuted = false;
        void testAction() {
          actionExecuted = true;
        }

        final message = UIMessage(
          message: 'Test message',
          type: UIMessageType.success,
          actionLabel: 'Execute',
          onAction: testAction,
        );

        // Act
        message.onAction?.call();

        // Assert
        expect(actionExecuted, isTrue);
      });

      test('should handle null onAction gracefully', () {
        // Arrange
        final message = UIMessage(
          message: 'Test message',
          type: UIMessageType.success,
        );

        // Act & Assert - should not throw
        expect(() => message.onAction?.call(), returnsNormally);
      });

      test('should pass parameters to callback if needed', () {
        // Arrange
        String? receivedData;
        void testAction() {
          receivedData = 'callback executed';
        }

        final message = UIMessage(
          message: 'Test message',
          type: UIMessageType.success,
          onAction: testAction,
        );

        // Act
        message.onAction?.call();

        // Assert
        expect(receivedData, equals('callback executed'));
      });
    });

    group('Edge Cases', () {
      test('should handle empty message string', () {
        // Act
        final message = UIMessage(
          message: '',
          type: UIMessageType.info,
        );

        // Assert
        expect(message.message, equals(''));
        expect(message.type, equals(UIMessageType.info));
      });

      test('should handle very long message string', () {
        // Arrange
        final longMessage = 'A' * 1000;

        // Act
        final message = UIMessage(
          message: longMessage,
          type: UIMessageType.error,
        );

        // Assert
        expect(message.message, equals(longMessage));
        expect(message.message.length, equals(1000));
      });

      test('should handle special characters in message', () {
        // Act
        final message = UIMessage(
          message:
              'Message with special chars: !@#\$%^&*()_+{}|:"<>?[]\\;\'./,`~',
          type: UIMessageType.warning,
        );

        // Assert
        expect(message.message, contains('!@#\$%^&*()'));
        expect(message.type, equals(UIMessageType.warning));
      });

      test('should handle unicode characters in message', () {
        // Act
        final message = UIMessage(
          message: 'Mensagem com acentos: ção, ã, é, ü, ñ 🎉',
          type: UIMessageType.success,
        );

        // Assert
        expect(message.message, contains('ção'));
        expect(message.message, contains('🎉'));
      });

      test('should handle empty actionLabel', () {
        // Act
        final message = UIMessage(
          message: 'Test message',
          type: UIMessageType.info,
          actionLabel: '',
        );

        // Assert
        expect(message.actionLabel, equals(''));
      });
    });
  });

  group('OrderResult', () {
    group('Constructor', () {
      test('should create OrderResult with all required parameters', () {
        // Act
        final orderResult = OrderResult(
          customerName: 'John Doe',
          total: 25.50,
          discount: 2.50,
          itemCount: 3,
        );

        // Assert
        expect(orderResult.customerName, equals('John Doe'));
        expect(orderResult.total, equals(25.50));
        expect(orderResult.discount, equals(2.50));
        expect(orderResult.itemCount, equals(3));
      });

      test('should handle zero values correctly', () {
        // Act
        final orderResult = OrderResult(
          customerName: 'Jane Smith',
          total: 0.0,
          discount: 0.0,
          itemCount: 0,
        );

        // Assert
        expect(orderResult.customerName, equals('Jane Smith'));
        expect(orderResult.total, equals(0.0));
        expect(orderResult.discount, equals(0.0));
        expect(orderResult.itemCount, equals(0));
      });

      test('should handle negative discount correctly', () {
        // Act
        final orderResult = OrderResult(
          customerName: 'Bob Wilson',
          total: 50.0,
          discount: -5.0,
          itemCount: 2,
        );

        // Assert
        expect(orderResult.customerName, equals('Bob Wilson'));
        expect(orderResult.total, equals(50.0));
        expect(orderResult.discount, equals(-5.0));
        expect(orderResult.itemCount, equals(2));
      });
    });

    group('Data Types', () {
      test('should handle double precision for monetary values', () {
        // Act
        final orderResult = OrderResult(
          customerName: 'Test User',
          total: 123.456789,
          discount: 12.345678,
          itemCount: 1,
        );

        // Assert
        expect(orderResult.total, equals(123.456789));
        expect(orderResult.discount, equals(12.345678));
      });

      test('should handle large monetary values', () {
        // Act
        final orderResult = OrderResult(
          customerName: 'Rich Customer',
          total: 999999.99,
          discount: 50000.00,
          itemCount: 100,
        );

        // Assert
        expect(orderResult.total, equals(999999.99));
        expect(orderResult.discount, equals(50000.00));
        expect(orderResult.itemCount, equals(100));
      });

      test('should handle large item counts', () {
        // Act
        final orderResult = OrderResult(
          customerName: 'Bulk Order',
          total: 1000.0,
          discount: 100.0,
          itemCount: 999999,
        );

        // Assert
        expect(orderResult.itemCount, equals(999999));
      });
    });

    group('Customer Name Handling', () {
      test('should handle empty customer name', () {
        // Act
        final orderResult = OrderResult(
          customerName: '',
          total: 15.0,
          discount: 1.0,
          itemCount: 1,
        );

        // Assert
        expect(orderResult.customerName, equals(''));
      });

      test('should handle very long customer name', () {
        // Arrange
        final longName = 'John ${'Doe ' * 100}';

        // Act
        final orderResult = OrderResult(
          customerName: longName,
          total: 25.0,
          discount: 0.0,
          itemCount: 2,
        );

        // Assert
        expect(orderResult.customerName, equals(longName));
        expect(orderResult.customerName.length, greaterThan(300));
      });

      test('should handle special characters in customer name', () {
        // Act
        final orderResult = OrderResult(
          customerName: 'José da Silva-Santos Jr. (III)',
          total: 30.0,
          discount: 3.0,
          itemCount: 2,
        );

        // Assert
        expect(
            orderResult.customerName, equals('José da Silva-Santos Jr. (III)'));
        expect(orderResult.customerName, contains('é'));
        expect(orderResult.customerName, contains('-'));
        expect(orderResult.customerName, contains('('));
      });

      test('should handle unicode characters in customer name', () {
        // Act
        final orderResult = OrderResult(
          customerName: 'François Müller 王小明',
          total: 40.0,
          discount: 4.0,
          itemCount: 3,
        );

        // Assert
        expect(orderResult.customerName, contains('ç'));
        expect(orderResult.customerName, contains('ü'));
        expect(orderResult.customerName, contains('王'));
      });
    });

    group('Business Logic Validation', () {
      test('should represent valid order with positive values', () {
        // Act
        final orderResult = OrderResult(
          customerName: 'Valid Customer',
          total: 45.75,
          discount: 5.75,
          itemCount: 4,
        );

        // Assert - net total would be 40.00
        expect(orderResult.total, greaterThan(orderResult.discount));
        expect(orderResult.itemCount, greaterThan(0));
        expect(orderResult.customerName, isNotEmpty);
      });

      test('should handle order where discount equals total', () {
        // Act
        final orderResult = OrderResult(
          customerName: 'Free Order Customer',
          total: 20.0,
          discount: 20.0,
          itemCount: 1,
        );

        // Assert - net total would be 0.00
        expect(orderResult.total, equals(orderResult.discount));
        expect(orderResult.itemCount, greaterThan(0));
      });

      test('should handle promotional order with high discount', () {
        // Act
        final orderResult = OrderResult(
          customerName: 'Promo Customer',
          total: 100.0,
          discount: 90.0,
          itemCount: 5,
        );

        // Assert - 90% discount
        expect(orderResult.discount / orderResult.total, equals(0.9));
        expect(orderResult.itemCount, equals(5));
      });
    });

    group('Edge Cases', () {
      test('should handle very small monetary values', () {
        // Act
        final orderResult = OrderResult(
          customerName: 'Penny Customer',
          total: 0.01,
          discount: 0.001,
          itemCount: 1,
        );

        // Assert
        expect(orderResult.total, equals(0.01));
        expect(orderResult.discount, equals(0.001));
      });

      test('should handle negative item count', () {
        // Act
        final orderResult = OrderResult(
          customerName: 'Return Customer',
          total: -15.0,
          discount: 0.0,
          itemCount: -1,
        );

        // Assert
        expect(orderResult.itemCount, equals(-1));
        expect(orderResult.total, equals(-15.0));
      });

      test('should maintain data integrity across all fields', () {
        // Act
        final orderResult = OrderResult(
          customerName: 'Integrity Test',
          total: 123.45,
          discount: 12.34,
          itemCount: 7,
        );

        // Assert - verify all fields maintain their values
        expect(orderResult.customerName, equals('Integrity Test'));
        expect(orderResult.total, equals(123.45));
        expect(orderResult.discount, equals(12.34));
        expect(orderResult.itemCount, equals(7));

        // Verify calculated net total
        final netTotal = orderResult.total - orderResult.discount;
        expect(netTotal, equals(111.11));
      });
    });
  });
}
