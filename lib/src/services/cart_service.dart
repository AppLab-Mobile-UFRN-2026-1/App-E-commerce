import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartService extends ChangeNotifier {
  CartService({required String username})
    : _cartItemsKey = _buildCartItemsKey(username) {
    ready = _restoreCart();
  }

  static const _cartItemsKeyPrefix = 'cart_items';
  static const _legacyCartItemsKey = 'cart_items';

  late final Future<void> ready;
  final String _cartItemsKey;

  final Map<int, CartItem> _items = {};
  int _cachedTotalItems = 0;
  int _cachedTotalPriceInCents = 0;
  Future<void> _storageOperation = Future<void>.value();
  bool _hasLocalChanges = false;
  bool _isDisposed = false;

  UnmodifiableListView<CartItem> get items {
    return UnmodifiableListView(_items.values);
  }

  bool get isEmpty => _items.isEmpty;

  int get totalItems => _cachedTotalItems;

  int get totalPriceInCents => _cachedTotalPriceInCents;

  double get totalPrice => totalPriceInCents / 100;

  Future<void> addProduct(Product product) async {
    _hasLocalChanges = true;
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
    await _queuePersistCart();
  }

  Future<void> increment(int productId) async {
    final item = _items[productId];

    if (item == null) {
      return;
    }

    _hasLocalChanges = true;
    _items[productId] = item.copyWith(quantity: item.quantity + 1);
    _cachedTotalItems++;
    _cachedTotalPriceInCents += item.unitPriceInCents;

    notifyListeners();
    await _queuePersistCart();
  }

  Future<void> decrement(int productId) async {
    final item = _items[productId];

    if (item == null) {
      return;
    }

    _hasLocalChanges = true;
    if (item.quantity <= 1) {
      _items.remove(productId);
    } else {
      _items[productId] = item.copyWith(quantity: item.quantity - 1);
    }

    _cachedTotalItems--;
    _cachedTotalPriceInCents -= item.unitPriceInCents;
    notifyListeners();
    await _queuePersistCart();
  }

  Future<void> remove(int productId) async {
    final item = _items.remove(productId);

    if (item == null) {
      return;
    }

    _hasLocalChanges = true;
    _cachedTotalItems -= item.quantity;
    _cachedTotalPriceInCents -= item.subtotalInCents;
    notifyListeners();
    await _queuePersistCart();
  }

  Future<void> clear() async {
    _hasLocalChanges = true;

    if (_items.isEmpty) {
      await _queueRemovePersistedCart();
      return;
    }

    _items.clear();
    _cachedTotalItems = 0;
    _cachedTotalPriceInCents = 0;
    notifyListeners();
    await _queueRemovePersistedCart();
  }

  Future<void> _restoreCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var cartJson = prefs.getString(_cartItemsKey);
      final shouldMigrateLegacyCart = cartJson == null;

      cartJson ??= prefs.getString(_legacyCartItemsKey);

      if (cartJson == null || _hasLocalChanges) {
        return;
      }

      final decoded = jsonDecode(cartJson);

      if (decoded is! List) {
        await prefs.remove(_cartItemsKey);
        return;
      }

      final restoredItems = <int, CartItem>{};

      for (final itemJson in decoded) {
        if (itemJson is! Map<String, dynamic>) {
          throw const FormatException('Item do carrinho inválido.');
        }

        final item = CartItem.fromJson(itemJson);
        restoredItems[item.product.id] = item;
      }

      if (_isDisposed || _hasLocalChanges) {
        return;
      }

      _items
        ..clear()
        ..addAll(restoredItems);
      _recalculateTotals();
      notifyListeners();

      if (shouldMigrateLegacyCart) {
        await prefs.setString(_cartItemsKey, cartJson);
        await prefs.remove(_legacyCartItemsKey);
      }
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cartItemsKey);
    }
  }

  Future<void> _queuePersistCart() {
    final cartJson = jsonEncode(
      _items.values.map((item) => item.toJson()).toList(),
    );

    _storageOperation = _storageOperation.then<void>(
      (_) => _persistCart(cartJson),
      onError: (_) => _persistCart(cartJson),
    );

    return _storageOperation;
  }

  Future<void> _persistCart(String cartJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cartItemsKey, cartJson);
  }

  Future<void> _queueRemovePersistedCart() {
    _storageOperation = _storageOperation.then<void>(
      (_) => _removePersistedCart(),
      onError: (_) => _removePersistedCart(),
    );

    return _storageOperation;
  }

  Future<void> _removePersistedCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartItemsKey);
  }

  void _recalculateTotals() {
    _cachedTotalItems = 0;
    _cachedTotalPriceInCents = 0;

    for (final item in _items.values) {
      _cachedTotalItems += item.quantity;
      _cachedTotalPriceInCents += item.subtotalInCents;
    }
  }

  static String _buildCartItemsKey(String username) {
    final userKey = base64Url.encode(utf8.encode(username.trim()));
    return '${_cartItemsKeyPrefix}_$userKey';
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
