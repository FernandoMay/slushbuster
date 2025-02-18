class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        imageUrl: json['imageUrl'],
        price: json['price'].toDouble(),
      );
}

class Cart {
  final List<CartItem> items;

  Cart({List<CartItem>? items}) : items = items ?? [];

  // Getter for products from cart items
  List<Product> get products => items.map((item) => item.product).toList();

  double get totalPrice {
    return items.fold(0, (total, item) => total + item.subtotal);
  }

  int get itemCount => items.length;

  void addProduct(Product product) {
    try {
      final existingItem = items.firstWhere(
        (item) => item.product.id == product.id,
        orElse: () => CartItem(product: product, quantity: 0),
      );

      if (existingItem.quantity == 0) {
        items.add(CartItem(product: product, quantity: 1));
      } else {
        existingItem.quantity++;
      }
    } catch (e) {
      print('Error adding product to cart: $e');
    }
  }

  void removeProduct(Product product) {
    try {
      final existingItemIndex = items.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (existingItemIndex != -1) {
        final existingItem = items[existingItemIndex];
        if (existingItem.quantity > 1) {
          existingItem.quantity--;
        } else {
          items.removeAt(existingItemIndex);
        }
      }
    } catch (e) {
      print('Error removing product from cart: $e');
    }
  }

  void updateQuantity(Product product, int quantity) {
    try {
      final existingItemIndex = items.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (existingItemIndex != -1) {
        if (quantity <= 0) {
          items.removeAt(existingItemIndex);
        } else {
          items[existingItemIndex].quantity = quantity;
        }
      }
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  void clear() {
    items.clear();
  }

  // Factory constructor for empty cart
  factory Cart.empty() => Cart(items: []);
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  double get subtotal {
    return quantity * product.price;
  }
}

class User {
  final String uid;
  final String name;
  final String email;

  User({
    required this.uid,
    required this.name,
    required this.email,
  });
}
