import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:slushbuster/models.dart';

@immutable
abstract class CartState {}

class CartEmptyState extends CartState {}

class CartLoadingState extends CartState {}

class CartLoadedState extends CartState {
  final Cart cart;

  CartLoadedState(this.cart);
}

class CartErrorState extends CartState {
  final String message;
  CartErrorState(this.message);
}

@immutable
abstract class CartEvent {}

class LoadCartEvent extends CartEvent {}

class AddProductToCartEvent extends CartEvent {
  final Product product;
  AddProductToCartEvent(this.product);
}

class RemoveProductFromCartEvent extends CartEvent {
  final Product product;
  RemoveProductFromCartEvent(this.product);
}

class UpdateQuantityEvent extends CartEvent {
  final Product product;
  final int quantity;
  UpdateQuantityEvent(this.product, this.quantity);
}

class ClearCartEvent extends CartEvent {}

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartEmptyState()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddProductToCartEvent>(_onAddProduct);
    on<RemoveProductFromCartEvent>(_onRemoveProduct);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<ClearCartEvent>(_onClearCart);
  }

  final Cart _cart = Cart.empty();

  void _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    try {
      await _loadCart();
      emit(CartLoadedState(_cart));
    } catch (e) {
      emit(CartErrorState(e.toString()));
    }
  }

  void _onAddProduct(AddProductToCartEvent event, Emitter<CartState> emit) {
    try {
      _cart.addProduct(event.product);
      emit(CartLoadedState(_cart));
    } catch (e) {
      emit(CartErrorState(e.toString()));
    }
  }

  void _onRemoveProduct(RemoveProductFromCartEvent event, Emitter<CartState> emit) {
    try {
      _cart.removeProduct(event.product);
      if (_cart.items.isEmpty) {
        emit(CartEmptyState());
      } else {
        emit(CartLoadedState(_cart));
      }
    } catch (e) {
      emit(CartErrorState(e.toString()));
    }
  }

  void _onUpdateQuantity(UpdateQuantityEvent event, Emitter<CartState> emit) {
    try {
      _cart.updateQuantity(event.product, event.quantity);
      if (_cart.items.isEmpty) {
        emit(CartEmptyState());
      } else {
        emit(CartLoadedState(_cart));
      }
    } catch (e) {
      emit(CartErrorState(e.toString()));
    }
  }

  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    try {
      _cart.clear();
      emit(CartEmptyState());
    } catch (e) {
      emit(CartErrorState(e.toString()));
    }
  }

  Future<void> _loadCart() async {
    // Implement cart loading logic here (e.g., from local storage or API)
    await Future.delayed(const Duration(milliseconds: 500)); // Simulated delay
  }
}
