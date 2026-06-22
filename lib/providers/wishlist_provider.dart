import 'package:flutter/foundation.dart';
import '../models/product.dart';

class WishlistProvider extends ChangeNotifier {
  final Map<int, Product> _items = {};

  List<Product> get items => _items.values.toList();
  int get itemCount => _items.length;

  bool isInWishlist(int productId) => _items.containsKey(productId);

  bool isWishlisted(int productId) => _items.containsKey(productId);

  void toggle(Product product) {
    if (_items.containsKey(product.id)) {
      _items.remove(product.id);
    } else {
      _items[product.id] = product;
    }
    notifyListeners();
  }

  void remove(int productId) {
    _items.remove(productId);
    notifyListeners();
  }
}