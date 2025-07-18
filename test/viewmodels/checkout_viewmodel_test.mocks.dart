// Mocks generated by Mockito 5.4.6 from annotations
// in bom_hamburguer/test/viewmodels/checkout_viewmodel_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;
import 'dart:ui' as _i7;

import 'package:bom_hamburguer/models/cart_item.dart' as _i3;
import 'package:bom_hamburguer/models/product.dart' as _i5;
import 'package:bom_hamburguer/services/cart_service.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i6;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [CartService].
///
/// See the documentation for Mockito's code generation for more information.
class MockCartService extends _i1.Mock implements _i2.CartService {
  MockCartService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  List<_i3.CartItem> get items => (super.noSuchMethod(
        Invocation.getter(#items),
        returnValue: <_i3.CartItem>[],
      ) as List<_i3.CartItem>);

  @override
  bool get isLoading => (super.noSuchMethod(
        Invocation.getter(#isLoading),
        returnValue: false,
      ) as bool);

  @override
  bool get isEmpty => (super.noSuchMethod(
        Invocation.getter(#isEmpty),
        returnValue: false,
      ) as bool);

  @override
  bool get isNotEmpty => (super.noSuchMethod(
        Invocation.getter(#isNotEmpty),
        returnValue: false,
      ) as bool);

  @override
  int get itemCount => (super.noSuchMethod(
        Invocation.getter(#itemCount),
        returnValue: 0,
      ) as int);

  @override
  int get totalQuantity => (super.noSuchMethod(
        Invocation.getter(#totalQuantity),
        returnValue: 0,
      ) as int);

  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);

  @override
  void clearError() => super.noSuchMethod(
        Invocation.method(
          #clearError,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.Future<void> initializeCart({bool? showLoading = true}) =>
      (super.noSuchMethod(
        Invocation.method(
          #initializeCart,
          [],
          {#showLoading: showLoading},
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<String> addItem(_i5.Product? product) => (super.noSuchMethod(
        Invocation.method(
          #addItem,
          [product],
        ),
        returnValue: _i4.Future<String>.value(_i6.dummyValue<String>(
          this,
          Invocation.method(
            #addItem,
            [product],
          ),
        )),
      ) as _i4.Future<String>);

  @override
  void removeItem(_i3.CartItem? cartItem) => super.noSuchMethod(
        Invocation.method(
          #removeItem,
          [cartItem],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.Future<void> clearCart() => (super.noSuchMethod(
        Invocation.method(
          #clearCart,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  double getSubtotal() => (super.noSuchMethod(
        Invocation.method(
          #getSubtotal,
          [],
        ),
        returnValue: 0.0,
      ) as double);

  @override
  double getDiscount() => (super.noSuchMethod(
        Invocation.method(
          #getDiscount,
          [],
        ),
        returnValue: 0.0,
      ) as double);

  @override
  double getTotal() => (super.noSuchMethod(
        Invocation.method(
          #getTotal,
          [],
        ),
        returnValue: 0.0,
      ) as double);

  @override
  String getDiscountDescription() => (super.noSuchMethod(
        Invocation.method(
          #getDiscountDescription,
          [],
        ),
        returnValue: _i6.dummyValue<String>(
          this,
          Invocation.method(
            #getDiscountDescription,
            [],
          ),
        ),
      ) as String);

  @override
  _i4.Future<bool> hasStoredCart() => (super.noSuchMethod(
        Invocation.method(
          #hasStoredCart,
          [],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);

  @override
  void addListener(_i7.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void removeListener(_i7.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
