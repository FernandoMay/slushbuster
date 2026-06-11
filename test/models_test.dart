import 'package:flutter_test/flutter_test.dart';
import 'package:slushbuster/models.dart';
import 'package:slushbuster/cartbloc.dart';

void main() {
  group('Product model', () {
    test('fromJson creates Product correctly', () {
      final json = {
        'id': '1',
        'name': 'Test Product',
        'description': 'A test product',
        'imageUrl': 'https://example.com/image.png',
        'price': 29.99,
      };

      final product = Product.fromJson(json);

      expect(product.id, '1');
      expect(product.name, 'Test Product');
      expect(product.description, 'A test product');
      expect(product.imageUrl, 'https://example.com/image.png');
      expect(product.price, 29.99);
    });
  });

  group('Cart model', () {
    test('empty cart has no items', () {
      final cart = Cart.empty();
      expect(cart.items, isEmpty);
      expect(cart.itemCount, 0);
      expect(cart.totalPrice, 0.0);
    });

    test('addProduct adds item to cart', () {
      final cart = Cart.empty();
      final product = Product(
        id: '1',
        name: 'Test',
        description: 'Desc',
        imageUrl: 'https://example.com/img.png',
        price: 10.0,
      );

      cart.addProduct(product);
      expect(cart.itemCount, 1);
      expect(cart.items.first.quantity, 1);
      expect(cart.totalPrice, 10.0);
    });

    test('addProduct increments quantity for existing item', () {
      final cart = Cart.empty();
      final product = Product(
        id: '1', name: 'Test', description: 'Desc',
        imageUrl: 'https://example.com/img.png', price: 10.0,
      );

      cart.addProduct(product);
      cart.addProduct(product);
      expect(cart.itemCount, 1);
      expect(cart.items.first.quantity, 2);
      expect(cart.totalPrice, 20.0);
    });

    test('removeProduct decrements quantity', () {
      final cart = Cart.empty();
      final product = Product(
        id: '1', name: 'Test', description: 'Desc',
        imageUrl: 'https://example.com/img.png', price: 10.0,
      );

      cart.addProduct(product);
      cart.addProduct(product);
      cart.removeProduct(product);
      expect(cart.items.first.quantity, 1);
    });

    test('removeProduct removes item when quantity reaches 0', () {
      final cart = Cart.empty();
      final product = Product(
        id: '1', name: 'Test', description: 'Desc',
        imageUrl: 'https://example.com/img.png', price: 10.0,
      );

      cart.addProduct(product);
      cart.removeProduct(product);
      expect(cart.items, isEmpty);
    });

    test('updateQuantity sets exact quantity', () {
      final cart = Cart.empty();
      final product = Product(
        id: '1', name: 'Test', description: 'Desc',
        imageUrl: 'https://example.com/img.png', price: 10.0,
      );

      cart.addProduct(product);
      cart.updateQuantity(product, 5);
      expect(cart.items.first.quantity, 5);
      expect(cart.totalPrice, 50.0);
    });

    test('updateQuantity with 0 removes item', () {
      final cart = Cart.empty();
      final product = Product(
        id: '1', name: 'Test', description: 'Desc',
        imageUrl: 'https://example.com/img.png', price: 10.0,
      );

      cart.addProduct(product);
      cart.updateQuantity(product, 0);
      expect(cart.items, isEmpty);
    });

    test('clear removes all items', () {
      final cart = Cart.empty();
      final product = Product(
        id: '1', name: 'Test', description: 'Desc',
        imageUrl: 'https://example.com/img.png', price: 10.0,
      );

      cart.addProduct(product);
      cart.clear();
      expect(cart.items, isEmpty);
    });

    test('products getter returns correct list', () {
      final cart = Cart.empty();
      final product = Product(
        id: '1', name: 'Test', description: 'Desc',
        imageUrl: 'https://example.com/img.png', price: 10.0,
      );

      cart.addProduct(product);
      expect(cart.products.length, 1);
      expect(cart.products.first, product);
    });
  });

  group('CartBloc', () {
    test('initial state is CartEmptyState', () {
      final bloc = CartBloc();
      expect(bloc.state, isA<CartEmptyState>());
      bloc.close();
    });

    test('AddProductToCartEvent emits CartLoadedState with item', () async {
      final bloc = CartBloc();
      final product = Product(
        id: '1', name: 'Test', description: 'Desc',
        imageUrl: 'https://example.com/img.png', price: 10.0,
      );

      final future = expectLater(
        bloc.stream,
        emits(isA<CartLoadedState>()),
      );
      bloc.add(AddProductToCartEvent(product));
      await future;
      expect((bloc.state as CartLoadedState).cart.items.length, 1);
      bloc.close();
    });

    test('RemoveProductFromCartEvent removes item and emits CartEmptyState', () async {
      final bloc = CartBloc();
      final product = Product(
        id: '1', name: 'Test', description: 'Desc',
        imageUrl: 'https://example.com/img.png', price: 10.0,
      );

      final future = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<CartLoadedState>(),
          isA<CartEmptyState>(),
        ]),
      );
      bloc.add(AddProductToCartEvent(product));
      bloc.add(RemoveProductFromCartEvent(product));
      await future;
      bloc.close();
    });

    test('ClearCartEvent clears cart and emits CartEmptyState', () async {
      final bloc = CartBloc();
      final product = Product(
        id: '1', name: 'Test', description: 'Desc',
        imageUrl: 'https://example.com/img.png', price: 10.0,
      );

      final future = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<CartLoadedState>(),
          isA<CartEmptyState>(),
        ]),
      );
      bloc.add(AddProductToCartEvent(product));
      bloc.add(ClearCartEvent());
      await future;
      bloc.close();
    });
  });
}
