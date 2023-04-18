import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slushbuster/cart.dart';
import 'package:slushbuster/models.dart';
import 'package:slushbuster/productpage.dart';

class HomePage extends StatefulWidget {
  // final CartBloc cartBloc;

  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> _products;
  late List<Product> _recommendedProducts;

  @override
  void initState() {
    super.initState();

    _recommendedProducts = [
      Product(
        id: '1',
        name: 'Chaqueta',
        description: 'Una chaqueta elegante para el invierno',
        imageUrl: 'https://via.placeholder.com/150',
        price: 50.0,
      ),
      Product(
        id: '2',
        name: 'Jeans',
        description: 'Unos jeans cómodos para cualquier ocasión',
        imageUrl: 'https://via.placeholder.com/150',
        price: 30.0,
      ),
      Product(
        id: '3',
        name: 'Zapatillas',
        description: 'Unas zapatillas deportivas para correr',
        imageUrl: 'https://via.placeholder.com/150',
        price: 40.0,
      ),
    ];
    _products = _getProducts();
  }

  Future<List<Product>> _getProducts() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('products').get();

    final List<Product> products = [];

    for (final doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      // final id = doc.id;
      final product = Product.fromJson(data);

      products.add(product);
    }

    return products;
  }

  void _onProductPressed(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductPage(
          productId: product.id,
          databaseReference: null,
        ),
      ),
    );
  }

  void _searchProduct(String query) {
    setState(() {
      _products = _getProducts().then((products) => products
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slushbuster'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _recommendedProducts.length,
              itemBuilder: (context, index) {
                final product = _recommendedProducts[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => _onProductPressed(product),
                    child: Column(
                      children: [
                        Image.network(
                          product.imageUrl,
                          height: 150.0,
                          width: 150.0,
                        ),
                        const SizedBox(height: 5.0),
                        Text(product.name),
                        const SizedBox(height: 5.0),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar productos',
              ),
              onChanged: (value) {
                _searchProduct(value);
              },
            ),
          ),
          const SizedBox(height: 10.0),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _products,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  final products = snapshot.data!;

                  return GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];

                      return InkWell(
                        onTap: () => _onProductPressed(product),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(product.name),
                            const SizedBox(height: 5.0),
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:slushbuster/cart.dart';
// import 'package:slushbuster/cartbloc.dart';
// import 'package:slushbuster/models.dart';
// import 'package:slushbuster/productpage.dart';

// class HomePage extends StatefulWidget {
//   final CartBloc cartBloc;

//   const HomePage({
//     required this.cartBloc,
//   });

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late List<Product> _products;

//   @override
//   void initState() {
//     super.initState();
    

//   void _onProductPressed(Product product) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ProductPage(
//           productId: product.id, databaseReference: null,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Slushbuster'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.shopping_cart),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const CartPage(),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: _products.length,
//         itemBuilder: (context, index) {
//           final product = _products[index];

//           return Card(
//             child: ListTile(
//               leading: Image.network(
//                 product.imageUrl,
//                 width: 50.0,
//                 height: 50.0,
//                 fit: BoxFit.cover,
//               ),
//               title: Text(product.name),
//               subtitle: Text(product.description),
//               trailing: Text('\$${product.price}'),
//               onTap: () => _onProductPressed(product),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
