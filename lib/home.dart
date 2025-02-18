import 'package:flutter/material.dart';
import 'package:slushbuster/cart.dart';
import 'package:slushbuster/models.dart';
import 'package:slushbuster/productpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Product> _products;
  late List<Product> _filteredProducts;

  @override
  void initState() {
    super.initState();
    _products = [
      Product(
        id: '1',
        name: 'Chaqueta de Invierno',
        description: 'Una chaqueta elegante y cálida para el invierno',
        imageUrl: 'https://picsum.photos/200/300?random=1',
        price: 89.99,
      ),
      Product(
        id: '2',
        name: 'Jeans Clásicos',
        description: 'Jeans cómodos y duraderos para cualquier ocasión',
        imageUrl: 'https://picsum.photos/200/300?random=2',
        price: 59.99,
      ),
      Product(
        id: '3',
        name: 'Zapatillas Deportivas',
        description: 'Zapatillas ideales para correr y hacer ejercicio',
        imageUrl: 'https://picsum.photos/200/300?random=3',
        price: 79.99,
      ),
      Product(
        id: '4',
        name: 'Camisa Casual',
        description: 'Camisa elegante para ocasiones casuales',
        imageUrl: 'https://picsum.photos/200/300?random=4',
        price: 45.99,
      ),
      Product(
        id: '5',
        name: 'Sudadera con Capucha',
        description: 'Sudadera cómoda y moderna para el día a día',
        imageUrl: 'https://picsum.photos/200/300?random=5',
        price: 49.99,
      ),
      Product(
        id: '6',
        name: 'Gorra Deportiva',
        description: 'Gorra ajustable para protegerte del sol',
        imageUrl: 'https://picsum.photos/200/300?random=6',
        price: 24.99,
      ),
    ];
    _filteredProducts = List.from(_products);
  }

  void _onProductPressed(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductPage(product: product),
      ),
    );
  }

  void _searchProduct(String query) {
    setState(() {
      _filteredProducts = _products
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
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
      body: CustomScrollView(
        slivers: [
          // Featured Products
          SliverToBoxAdapter(
            child: Container(
              height: 200.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => _onProductPressed(product),
                      child: Hero(
                        tag: 'product_${product.id}',
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.network(
                                  product.imageUrl,
                                  height: 120.0,
                                  width: 150.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: Theme.of(context).textTheme.titleMedium,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar productos',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: _searchProduct,
              ),
            ),
          ),
          // Product Grid
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = _filteredProducts[index];
                  return InkWell(
                    onTap: () => _onProductPressed(product),
                    child: Hero(
                      tag: 'product_${product.id}',
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: Theme.of(context).textTheme.titleMedium,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: _filteredProducts.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
