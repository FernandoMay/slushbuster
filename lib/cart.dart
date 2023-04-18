import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slushbuster/cartbloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Carrito de Compras'),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoadedState) {
            final cart = state.cart;
            return ListView.builder(
              itemCount: cart.products.length,
              itemBuilder: (context, index) {
                final product = cart.products[index];
                return ListTile(
                  leading: Image.network(product.image),
                  title: Text(product.name),
                  subtitle: Text('\$${product.price}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_shopping_cart),
                    onPressed: () {
                      BlocProvider.of<CartBloc>(context)
                          .add(RemoveProductFromCartEvent(product));
                    },
                  ),
                );
              },
            );
          } else if (state is CartEmptyState) {
            return const Center(
              child: Text('Tu carrito está vacío'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
