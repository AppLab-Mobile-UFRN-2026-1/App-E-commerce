import 'product.dart';

class CartItem {
  const CartItem({required this.product, required this.quantity});

  final Product product;
  final int quantity;

  int get unitPriceInCents => (product.price * 100).round();

  int get subtotalInCents => unitPriceInCents * quantity;

  double get subtotal => subtotalInCents / 100;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final product = json['product'];
    final quantity = json['quantity'];

    if (product is! Map<String, dynamic>) {
      throw const FormatException('Produto do carrinho inválido.');
    }

    if (quantity is! int || quantity < 1) {
      throw const FormatException('Quantidade do carrinho inválida.');
    }

    return CartItem(product: Product.fromJson(product), quantity: quantity);
  }

  Map<String, dynamic> toJson() {
    return {'product': product.toJson(), 'quantity': quantity};
  }

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}
