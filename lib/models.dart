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

  Cart({
    required this.items,
  });

  double get totalPrice {
    return items.fold(0, (total, item) => total + item.subtotal);
  }

  void addProduct(Product product) {
    final existingItem =
        items.firstWhere((item) => item.product.id == product.id);

    if (existingItem != null) {
      existingItem.quantity++;
    } else {
      items.add(CartItem(product: product, quantity: 1));
    }
  }

  void removeProduct(Product product) {
    final existingItemIndex =
        items.indexWhere((item) => item.product.id == product.id);

    if (existingItemIndex != -1) {
      final existingItem = items[existingItemIndex];
      if (existingItem.quantity > 1) {
        existingItem.quantity--;
      } else {
        items.removeAt(existingItemIndex);
      }
    }
  }

  void clear() {
    items.clear();
  }
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
