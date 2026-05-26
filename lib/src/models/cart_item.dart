import 'product.dart';

class CartItem {
  const CartItem({
    required this.product,
    required this.quantity,
  });

  final Product product;
  final int quantity;

  int get unitPriceInCents => (product.price * 100).round();

  int get subtotalInCents => unitPriceInCents * quantity;

  double get subtotal => subtotalInCents / 100;

  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}
