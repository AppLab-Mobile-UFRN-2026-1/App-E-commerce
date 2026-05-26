import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartService extends ChangeNotifier {
  final Map<int, CartItem> _items = {};
  int _cachedTotalItems = 0;
  int _cachedTotalPriceInCents = 0;

  UnmodifiableListView<CartItem> get items {
    return UnmodifiableListView(_items.values);
  }

  bool get isEmpty => _items.isEmpty;

  int get totalItems => _cachedTotalItems;

  int get totalPriceInCents => _cachedTotalPriceInCents;

  double get totalPrice => totalPriceInCents / 100;

  void addProduct(Product product) {
    final item = _items[product.id];

    if (item == null) {
      _items[product.id] = CartItem(product: product, quantity: 1);
      _cachedTotalItems++;
      _cachedTotalPriceInCents += (product.price * 100).round();
    } else {
      _items[product.id] = item.copyWith(quantity: item.quantity + 1);
      _cachedTotalItems++;
      _cachedTotalPriceInCents += item.unitPriceInCents;
    }

    notifyListeners();
  }

  void increment(int productId) {
    final item = _items[productId];

    if (item == null) {
      return;
    }

    _items[productId] = item.copyWith(quantity: item.quantity + 1);
    _cachedTotalItems++;
    _cachedTotalPriceInCents += item.unitPriceInCents;

    notifyListeners();
  }

  void decrement(int productId) {
    final item = _items[productId];

    if (item == null) {
      return;
    }

    if (item.quantity <= 1) {
      _items.remove(productId);
    } else {
      _items[productId] = item.copyWith(quantity: item.quantity - 1);
    }

    _cachedTotalItems--;
    _cachedTotalPriceInCents -= item.unitPriceInCents;
    notifyListeners();
  }

  void remove(int productId) {
    final item = _items.remove(productId);

    if (item == null) {
      return;
    }

    _cachedTotalItems -= item.quantity;
    _cachedTotalPriceInCents -= item.subtotalInCents;
    notifyListeners();
  }

  void clear() {
    if (_items.isEmpty) {
      return;
    }

    _items.clear();
    _cachedTotalItems = 0;
    _cachedTotalPriceInCents = 0;
    notifyListeners();
  }
}
