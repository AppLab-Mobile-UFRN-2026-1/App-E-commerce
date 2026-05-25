class Product {
  const Product({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
  });

  final String name;
  final String description;
  final double price;
  final String icon;

  String get formattedPrice => 'R\$ ${price.toStringAsFixed(2)}';
}
