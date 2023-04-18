import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:slushbuster/models.dart';

class CartState {}

class CartEmptyState extends CartState {}

class CartLoadingState extends CartState {}

class CartLoadedState extends CartState {
  final Cart cart;

  CartLoadedState(this.cart);
}

class CartErrorState extends CartState {}

class CartEvent {}

class LoadCartEvent extends CartEvent {}

class AddProductToCartEvent extends CartEvent {
  final Product product;

  AddProductToCartEvent(this.product);
}

class RemoveProductFromCartEvent extends CartEvent {
  final Product product;

  RemoveProductFromCartEvent(this.product);
}

class ClearCartEvent extends CartEvent {}

class CartBloc extends Bloc<CartEvent, CartState> {
  final Cart _cart = Cart.empty();

  CartBloc(super.initialState);

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is LoadCartEvent) {
      yield CartLoadingState();
      try {
        await _loadCart();
        yield CartLoadedState(_cart);
      } catch (e) {
        yield CartErrorState();
      }
    } else if (event is AddProductToCartEvent) {
      _cart.addProduct(event.product);
      yield CartLoadedState(_cart);
    } else if (event is RemoveProductFromCartEvent) {
      _cart.removeProduct(event.product);
      yield CartLoadedState(_cart);
    } else if (event is ClearCartEvent) {
      _cart.clear();
      yield CartEmptyState();
    }
  }

  Future<void> _loadCart() async {
// Load cart items from database
  }
}
