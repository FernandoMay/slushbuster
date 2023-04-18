import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:slushbuster/cartbloc.dart';
import 'package:slushbuster/models.dart';

class ProductPage extends StatefulWidget {
  final DatabaseReference databaseReference;
  final String productId;

  const ProductPage({required this.databaseReference, required this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Product _product;

  @override
  void initState() {
    super.initState();

    widget.databaseReference
        .child('products/${widget.productId}')
        .onValue
        .listen((event) {
      final data = event.snapshot.value as Map<String, dynamic>;
      _product = Product.fromJson(data);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Producto'),
      ),
      body: _product != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.network(_product.imageUrl),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    _product.name,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '\$${_product.price}',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    _product.description,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<CartBloc>(context)
                          .add(AddProductToCartEvent(_product));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Producto agregado al carrito'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Text('Agregar al Carrito'),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
